using Microsoft.Extensions.Options;
using OpenIddict.Abstractions;

namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

/// <summary>
/// Idempotent seeder that registers/updates the pm-web SPA client and any configured
/// machine-to-machine clients in PostgreSQL on every startup. Safe to re-run.
/// </summary>
public sealed class OidcClientSeeder(
    IOpenIddictApplicationManager applicationManager,
    IOpenIddictScopeManager scopeManager,
    IOptions<OidcSettings> options,
    ILogger<OidcClientSeeder> logger)
{
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        await EnsureApiScopeAsync(cancellationToken);
        await EnsureWebClientAsync(cancellationToken);
        await EnsureMachineClientsAsync(cancellationToken);
    }

    private async Task EnsureApiScopeAsync(CancellationToken ct)
    {
        var existing = await scopeManager.FindByNameAsync(OidcConstants.ApiScope, ct);
        var descriptor = new OpenIddictScopeDescriptor
        {
            Name = OidcConstants.ApiScope,
            DisplayName = "ProjectManager API access",
            Resources = { OidcConstants.ApiResource }
        };

        if (existing is null)
        {
            await scopeManager.CreateAsync(descriptor, ct);
            logger.LogInformation("Created OIDC scope {Scope}", OidcConstants.ApiScope);
        }
        else
        {
            await scopeManager.UpdateAsync(existing, descriptor, ct);
        }
    }

    private async Task EnsureWebClientAsync(CancellationToken ct)
    {
        var settings = options.Value;
        var redirectUris = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "http://localhost:3000/auth/callback",
            "https://timetracking.harker.dev/auth/callback",
        };
        foreach (var uri in settings.WebRedirectUris) redirectUris.Add(uri);

        var postLogout = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "http://localhost:3000/",
            "https://timetracking.harker.dev/",
        };
        foreach (var uri in settings.WebPostLogoutRedirectUris) postLogout.Add(uri);

        var descriptor = new OpenIddictApplicationDescriptor
        {
            ClientId = OidcConstants.WebClientId,
            ClientType = OpenIddictConstants.ClientTypes.Public,
            ConsentType = OpenIddictConstants.ConsentTypes.Implicit,
            DisplayName = "ProjectManager Web",
            ApplicationType = OpenIddictConstants.ApplicationTypes.Web,
            Permissions =
            {
                OpenIddictConstants.Permissions.Endpoints.Authorization,
                OpenIddictConstants.Permissions.Endpoints.Token,
                OpenIddictConstants.Permissions.Endpoints.EndSession,
                OpenIddictConstants.Permissions.GrantTypes.AuthorizationCode,
                OpenIddictConstants.Permissions.GrantTypes.RefreshToken,
                OpenIddictConstants.Permissions.ResponseTypes.Code,
                // openid must be explicitly permitted; OpenIddict drops requested scopes the
                // client isn't allowed to use, and userinfo returns 403 without openid.
                OpenIddictConstants.Permissions.Prefixes.Scope + OpenIddictConstants.Scopes.OpenId,
                OpenIddictConstants.Permissions.Scopes.Email,
                OpenIddictConstants.Permissions.Scopes.Profile,
                OpenIddictConstants.Permissions.Prefixes.Scope + OpenIddictConstants.Scopes.OfflineAccess,
                OpenIddictConstants.Permissions.Prefixes.Scope + OidcConstants.ApiScope,
            },
            Requirements =
            {
                OpenIddictConstants.Requirements.Features.ProofKeyForCodeExchange,
            },
        };

        foreach (var uri in redirectUris) descriptor.RedirectUris.Add(new Uri(uri));
        foreach (var uri in postLogout) descriptor.PostLogoutRedirectUris.Add(new Uri(uri));

        var existing = await applicationManager.FindByClientIdAsync(OidcConstants.WebClientId, ct);
        if (existing is null)
        {
            await applicationManager.CreateAsync(descriptor, ct);
            logger.LogInformation("Created OIDC client {ClientId}", OidcConstants.WebClientId);
        }
        else
        {
            await applicationManager.UpdateAsync(existing, descriptor, ct);
        }
    }

    private async Task EnsureMachineClientsAsync(CancellationToken ct)
    {
        foreach (var client in options.Value.MachineClients)
        {
            if (string.IsNullOrWhiteSpace(client.ClientId) || string.IsNullOrWhiteSpace(client.ClientSecret))
            {
                logger.LogWarning("Skipping machine client with missing id or secret.");
                continue;
            }

            var descriptor = new OpenIddictApplicationDescriptor
            {
                ClientId = client.ClientId,
                ClientSecret = client.ClientSecret,
                ClientType = OpenIddictConstants.ClientTypes.Confidential,
                ConsentType = OpenIddictConstants.ConsentTypes.Implicit,
                DisplayName = client.DisplayName ?? client.ClientId,
                Permissions =
                {
                    OpenIddictConstants.Permissions.Endpoints.Token,
                    OpenIddictConstants.Permissions.Endpoints.Introspection,
                    OpenIddictConstants.Permissions.GrantTypes.ClientCredentials,
                },
            };

            foreach (var scope in client.Scopes.Count == 0 ? [OidcConstants.ApiScope] : client.Scopes)
            {
                descriptor.Permissions.Add(OpenIddictConstants.Permissions.Prefixes.Scope + scope);
            }

            var existing = await applicationManager.FindByClientIdAsync(client.ClientId, ct);
            if (existing is null)
            {
                await applicationManager.CreateAsync(descriptor, ct);
                logger.LogInformation("Created OIDC machine client {ClientId}", client.ClientId);
            }
            else
            {
                await applicationManager.UpdateAsync(existing, descriptor, ct);
            }
        }
    }
}
