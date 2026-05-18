using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using ProjectManager.Api.Data;
using Quartz;

namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

public static class OpenIddictRegistration
{
    public static IServiceCollection AddProjectManagerOpenIddict(
        this IServiceCollection services,
        JwtSettings legacyJwtSettings)
    {
        services.AddSingleton<OpenIddictCertificateStore>();
        services.AddSingleton<Microsoft.Extensions.Options.IPostConfigureOptions<OpenIddict.Server.OpenIddictServerOptions>, ConfigureOpenIddictCertificates>();

        services.AddOpenIddict()
            .AddCore(options =>
            {
                options.UseEntityFrameworkCore()
                    .UseDbContext<AppDbContext>()
                    .ReplaceDefaultEntities<Guid>();

                options.UseQuartz();
            })
            .AddServer(options =>
            {
                options.SetAuthorizationEndpointUris("connect/authorize")
                    .SetTokenEndpointUris("connect/token")
                    .SetUserInfoEndpointUris("connect/userinfo")
                    .SetEndSessionEndpointUris("connect/logout")
                    .SetIntrospectionEndpointUris("connect/introspect")
                    .SetJsonWebKeySetEndpointUris(".well-known/jwks");

                options.AllowAuthorizationCodeFlow()
                    .RequireProofKeyForCodeExchange()
                    .AllowClientCredentialsFlow()
                    .AllowRefreshTokenFlow();

                options.RegisterScopes(
                    OpenIddictConstants.Scopes.OpenId,
                    OpenIddictConstants.Scopes.Profile,
                    OpenIddictConstants.Scopes.Email,
                    OpenIddictConstants.Scopes.OfflineAccess,
                    OidcConstants.ApiScope);

                options.RegisterClaims(
                    OpenIddictConstants.Claims.Subject,
                    OpenIddictConstants.Claims.Email,
                    OpenIddictConstants.Claims.GivenName,
                    OpenIddictConstants.Claims.FamilyName,
                    OpenIddictConstants.Claims.Name,
                    "org");

                // Access tokens are JWS only (not JWE-wrapped) so any standard JWT client can
                // validate them with the public key from the JWKS endpoint.
                options.DisableAccessTokenEncryption();

                options.SetAccessTokenLifetime(TimeSpan.FromMinutes(60))
                    .SetIdentityTokenLifetime(TimeSpan.FromMinutes(60))
                    .SetRefreshTokenLifetime(TimeSpan.FromDays(14));

                // Certificates are added by ConfigureOpenIddictCertificates after DI is ready.

                options.UseAspNetCore()
                    .EnableAuthorizationEndpointPassthrough()
                    .EnableTokenEndpointPassthrough()
                    .EnableUserInfoEndpointPassthrough()
                    .EnableEndSessionEndpointPassthrough()
                    .EnableStatusCodePagesIntegration();
            })
            .AddValidation(options =>
            {
                options.UseLocalServer();
                options.UseAspNetCore();
            });

        // Quartz pruning of expired authorizations/tokens.
        services.AddQuartz(q =>
        {
            q.UseSimpleTypeLoader();
            q.UseInMemoryStore();
        });
        services.AddQuartzHostedService(opts => opts.WaitForJobsToComplete = true);

        // Compose two bearer handlers under a single "Bearer" scheme. Legacy HS256 tokens
        // route to JwtBearer; RS256 tokens (issued by OpenIddict) route to OpenIddict's
        // validation handler.
        services.AddAuthentication(OidcConstants.CompositeBearerScheme)
            .AddJwtBearer(OidcConstants.LegacyJwtScheme, options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = legacyJwtSettings.Issuer,
                    ValidAudience = legacyJwtSettings.Audience,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(legacyJwtSettings.Secret)),
                    ClockSkew = TimeSpan.Zero
                };
            })
            .AddPolicyScheme(OidcConstants.CompositeBearerScheme, OidcConstants.CompositeBearerScheme, options =>
            {
                options.ForwardDefaultSelector = context =>
                {
                    var authHeader = context.Request.Headers.Authorization.ToString();
                    if (string.IsNullOrEmpty(authHeader) || !authHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
                        return OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme;

                    var token = authHeader["Bearer ".Length..].Trim();
                    return LooksLikeLegacyHs256(token)
                        ? OidcConstants.LegacyJwtScheme
                        : OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme;
                };
            });

        return services;
    }

    private static bool LooksLikeLegacyHs256(string token)
    {
        var firstDot = token.IndexOf('.');
        if (firstDot <= 0) return false;
        var headerSegment = token[..firstDot];
        try
        {
            var padded = headerSegment.Replace('-', '+').Replace('_', '/');
            padded = padded.PadRight(padded.Length + ((4 - padded.Length % 4) % 4), '=');
            var json = Encoding.UTF8.GetString(Convert.FromBase64String(padded));
            return json.Contains("\"HS256\"", StringComparison.OrdinalIgnoreCase);
        }
        catch
        {
            return false;
        }
    }
}
