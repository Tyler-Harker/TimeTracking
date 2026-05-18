using System.Collections.Immutable;
using System.Security.Claims;
using Carter;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Server.AspNetCore;
using OpenIddict.Validation.AspNetCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.Auth.Oidc;

namespace ProjectManager.Api.Features.Auth.Oidc;

/// <summary>
/// OIDC /connect/* endpoints: authorize, token (auth code + refresh + client credentials),
/// userinfo, logout. Issues claims in the same shape as JwtService (sub, email, given_name,
/// family_name, org=orgId:role) so downstream policies and the multi-tenancy middleware
/// keep working unchanged.
/// </summary>
public class OidcConnect : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        app.MapMethods("/connect/authorize", ["GET", "POST"], AuthorizeAsync)
            .AllowAnonymous()
            .ExcludeFromDescription();

        app.MapPost("/connect/token", TokenAsync)
            .AllowAnonymous()
            .ExcludeFromDescription();

        app.MapMethods("/connect/userinfo", ["GET", "POST"], UserInfoAsync)
            .RequireAuthorization(policy => policy
                .AddAuthenticationSchemes(OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme)
                .RequireAuthenticatedUser())
            .ExcludeFromDescription();

        app.MapPost("/connect/logout", LogoutAsync)
            .AllowAnonymous()
            .ExcludeFromDescription();
    }

    private static async Task<IResult> AuthorizeAsync(
        HttpContext http,
        UserManager<User> userManager,
        AppDbContext db)
    {
        var request = http.GetOpenIddictServerRequest()
            ?? throw new InvalidOperationException("OpenIddict request not present.");

        // Require an authenticated Identity cookie. If absent, challenge the cookie scheme so
        // the user is bounced to /account/login and then back here.
        var result = await http.AuthenticateAsync(OidcConstants.CookieScheme);
        if (!result.Succeeded)
        {
            return Results.Challenge(
                authenticationSchemes: [OidcConstants.CookieScheme],
                properties: new AuthenticationProperties
                {
                    RedirectUri = http.Request.PathBase + http.Request.Path + QueryString.Create(
                        http.Request.HasFormContentType
                            ? (await http.Request.ReadFormAsync()).ToList()
                            : http.Request.Query.ToList())
                });
        }

        var user = await userManager.GetUserAsync(result.Principal)
            ?? throw new InvalidOperationException("Authenticated user not found.");

        if (!user.IsActive)
        {
            var properties = new AuthenticationProperties(new Dictionary<string, string?>
            {
                [OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.AccessDenied,
                [OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] = "Account is deactivated."
            });
            return Results.Forbid(properties, [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
        }

        var memberships = await db.OrganizationUsers
            .Include(ou => ou.Organization)
            .Where(ou => ou.UserId == user.Id)
            .ToListAsync();

        var principal = BuildUserPrincipal(user, memberships, request.GetScopes(), ResolveIssuer(http));

        return Results.SignIn(principal, properties: null, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
    }

    private static async Task<IResult> TokenAsync(
        HttpContext http,
        UserManager<User> userManager,
        AppDbContext db,
        IOpenIddictApplicationManager applicationManager)
    {
        var request = http.GetOpenIddictServerRequest()
            ?? throw new InvalidOperationException("OpenIddict request not present.");

        if (request.IsAuthorizationCodeGrantType() || request.IsRefreshTokenGrantType())
        {
            var result = await http.AuthenticateAsync(OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
            if (!result.Succeeded || result.Principal is null)
            {
                return Results.Forbid(
                    new AuthenticationProperties(new Dictionary<string, string?>
                    {
                        [OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant,
                        [OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] = "The authorization code or refresh token is no longer valid."
                    }),
                    [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
            }

            var subject = result.Principal.GetClaim(OpenIddictConstants.Claims.Subject);
            if (string.IsNullOrEmpty(subject) || !Guid.TryParse(subject, out var userId))
            {
                return Results.Forbid(
                    new AuthenticationProperties(new Dictionary<string, string?>
                    {
                        [OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant
                    }),
                    [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
            }

            var user = await userManager.FindByIdAsync(userId.ToString());
            if (user is null || !user.IsActive)
            {
                return Results.Forbid(
                    new AuthenticationProperties(new Dictionary<string, string?>
                    {
                        [OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant,
                        [OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] = "User no longer exists or is deactivated."
                    }),
                    [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
            }

            var memberships = await db.OrganizationUsers
                .Include(ou => ou.Organization)
                .Where(ou => ou.UserId == user.Id)
                .ToListAsync();

            var principal = BuildUserPrincipal(user, memberships, result.Principal.GetScopes(), ResolveIssuer(http));
            return Results.SignIn(principal, properties: null, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
        }

        if (request.IsClientCredentialsGrantType())
        {
            var application = await applicationManager.FindByClientIdAsync(request.ClientId!)
                ?? throw new InvalidOperationException("Application cannot be found.");

            var identity = new ClaimsIdentity(
                authenticationType: OpenIddictServerAspNetCoreDefaults.AuthenticationScheme,
                nameType: OpenIddictConstants.Claims.Name,
                roleType: OpenIddictConstants.Claims.Role);

            var clientId = await applicationManager.GetClientIdAsync(application);
            var displayName = await applicationManager.GetDisplayNameAsync(application);

            identity.SetClaim(OpenIddictConstants.Claims.Subject, clientId);
            identity.SetClaim(OpenIddictConstants.Claims.Name, displayName);

            var principal = new ClaimsPrincipal(identity);
            principal.SetScopes(request.GetScopes());
            // Machine-to-machine tokens only need to call the API resource server, not /connect/userinfo.
            principal.SetResources(OidcConstants.ApiResource);
            foreach (var claim in principal.Claims)
            {
                claim.SetDestinations(ResolveDestinations(claim, principal));
            }

            return Results.SignIn(principal, properties: null, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
        }

        throw new InvalidOperationException("The specified grant type is not supported.");
    }

    private static async Task<IResult> UserInfoAsync(
        HttpContext http,
        UserManager<User> userManager,
        AppDbContext db)
    {
        // Authenticate via the OpenIddict validation handler (resource-server style). The
        // server-scheme AuthenticateAsync path didn't pick up the bearer token reliably in
        // this pipeline and ended up issuing a default challenge → 403 insufficient_access.
        // The validation handler reads the Authorization header, validates the JWT against
        // the local server's signing keys, and returns the principal.
        var auth = await http.AuthenticateAsync(OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme);
        if (!auth.Succeeded || auth.Principal is null)
            return Results.Unauthorized();

        var principal = auth.Principal;
        var subject = principal.GetClaim(OpenIddictConstants.Claims.Subject);
        if (string.IsNullOrEmpty(subject) || !Guid.TryParse(subject, out var userId))
            return Results.Unauthorized();

        var user = await userManager.FindByIdAsync(userId.ToString());
        if (user is null)
            return Results.Unauthorized();

        var memberships = await db.OrganizationUsers
            .Include(ou => ou.Organization)
            .Where(ou => ou.UserId == user.Id)
            .ToListAsync();

        var claims = new Dictionary<string, object>(StringComparer.Ordinal)
        {
            [OpenIddictConstants.Claims.Subject] = user.Id.ToString(),
        };

        if (principal.HasScope(OpenIddictConstants.Scopes.Email) && !string.IsNullOrEmpty(user.Email))
        {
            claims[OpenIddictConstants.Claims.Email] = user.Email;
            claims[OpenIddictConstants.Claims.EmailVerified] = user.EmailConfirmed;
        }

        if (principal.HasScope(OpenIddictConstants.Scopes.Profile))
        {
            claims[OpenIddictConstants.Claims.GivenName] = user.FirstName;
            claims[OpenIddictConstants.Claims.FamilyName] = user.LastName;
            claims[OpenIddictConstants.Claims.Name] = $"{user.FirstName} {user.LastName}".Trim();
            if (!string.IsNullOrEmpty(user.AvatarUrl))
                claims[OpenIddictConstants.Claims.Picture] = user.AvatarUrl;
        }

        claims["org"] = memberships
            .Select(m => $"{m.OrganizationId}:{m.Role}")
            .ToArray();

        return Results.Ok(claims);
    }

    private static async Task<IResult> LogoutAsync(HttpContext http, SignInManager<User> signInManager)
    {
        await signInManager.SignOutAsync();
        return Results.SignOut(
            new AuthenticationProperties { RedirectUri = "/" },
            [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
    }

    private static ClaimsPrincipal BuildUserPrincipal(
        User user,
        IReadOnlyList<OrganizationUser> memberships,
        ImmutableArray<string> scopes,
        string issuer)
    {
        var identity = new ClaimsIdentity(
            authenticationType: OpenIddictServerAspNetCoreDefaults.AuthenticationScheme,
            nameType: OpenIddictConstants.Claims.Name,
            roleType: OpenIddictConstants.Claims.Role);

        identity.SetClaim(OpenIddictConstants.Claims.Subject, user.Id.ToString())
                .SetClaim(OpenIddictConstants.Claims.Email, user.Email)
                .SetClaim(OpenIddictConstants.Claims.GivenName, user.FirstName)
                .SetClaim(OpenIddictConstants.Claims.FamilyName, user.LastName)
                .SetClaim(OpenIddictConstants.Claims.Name, $"{user.FirstName} {user.LastName}".Trim());

        // Match the legacy org=orgId:Role claim shape JwtService.GenerateToken produces.
        foreach (var membership in memberships)
        {
            identity.AddClaim(new Claim("org", $"{membership.OrganizationId}:{membership.Role}"));
        }

        var principal = new ClaimsPrincipal(identity);
        principal.SetScopes(scopes);
        // Include both the API resource and the issuer URL as audiences. The API resource
        // server validates tokens against pm-api; OpenIddict's /connect/userinfo endpoint
        // requires the audience to include the issuer URL, otherwise it returns 403.
        principal.SetResources(OidcConstants.ApiResource, issuer);

        foreach (var claim in principal.Claims)
        {
            claim.SetDestinations(ResolveDestinations(claim, principal));
        }

        return principal;
    }

    private static string ResolveIssuer(HttpContext http)
    {
        // Relies on UseForwardedHeaders to surface the original scheme/host when behind a proxy.
        var host = http.Request.Host.HasValue ? http.Request.Host.Value : "localhost";
        return $"{http.Request.Scheme}://{host}/";
    }

    private static IEnumerable<string> ResolveDestinations(Claim claim, ClaimsPrincipal principal)
    {
        switch (claim.Type)
        {
            case OpenIddictConstants.Claims.Name:
            case OpenIddictConstants.Claims.GivenName:
            case OpenIddictConstants.Claims.FamilyName:
                yield return OpenIddictConstants.Destinations.AccessToken;
                if (principal.HasScope(OpenIddictConstants.Scopes.Profile))
                    yield return OpenIddictConstants.Destinations.IdentityToken;
                yield break;

            case OpenIddictConstants.Claims.Email:
                yield return OpenIddictConstants.Destinations.AccessToken;
                if (principal.HasScope(OpenIddictConstants.Scopes.Email))
                    yield return OpenIddictConstants.Destinations.IdentityToken;
                yield break;

            case "org":
                // Embed org memberships in both access and id tokens; downstream uses them.
                yield return OpenIddictConstants.Destinations.AccessToken;
                yield return OpenIddictConstants.Destinations.IdentityToken;
                yield break;

            case "AspNet.Identity.SecurityStamp":
                yield break;

            default:
                yield return OpenIddictConstants.Destinations.AccessToken;
                yield break;
        }
    }
}
