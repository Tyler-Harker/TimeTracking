namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

public static class OidcConstants
{
    public const string ApiScope = "pm_api";
    public const string ApiResource = "pm-api";

    public const string WebClientId = "pm-web";

    public const string CookieScheme = "Identity.Application";

    /// <summary>
    /// Composite authentication scheme that routes legacy HS256 JWTs to the original
    /// JwtBearer handler and OpenIddict-issued tokens to the OpenIddict validation handler.
    /// </summary>
    public const string CompositeBearerScheme = "Bearer";

    public const string LegacyJwtScheme = "LegacyJwt";
}
