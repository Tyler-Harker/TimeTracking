namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

public class OidcSettings
{
    public const string SectionName = "Oidc";

    /// <summary>
    /// Redirect URIs registered for the pm-web SPA in addition to the built-in defaults
    /// (http://localhost:3000/auth/callback and https://timetracking.harker.dev/auth/callback).
    /// </summary>
    public List<string> WebRedirectUris { get; set; } = [];

    /// <summary>
    /// Post-logout redirect URIs for the pm-web SPA in addition to the built-in defaults.
    /// </summary>
    public List<string> WebPostLogoutRedirectUris { get; set; } = [];

    /// <summary>
    /// Confidential machine-to-machine clients. Seeded on startup; existing clients are
    /// updated in place if the secret or scopes change.
    /// </summary>
    public List<MachineClient> MachineClients { get; set; } = [];

    public class MachineClient
    {
        public string ClientId { get; set; } = string.Empty;
        public string ClientSecret { get; set; } = string.Empty;
        public string? DisplayName { get; set; }
        public List<string> Scopes { get; set; } = [];
    }
}
