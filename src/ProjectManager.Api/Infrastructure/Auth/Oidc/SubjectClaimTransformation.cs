using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using OpenIddict.Abstractions;

namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

/// <summary>
/// Bridges the OpenIddict claim shape to the legacy claim shape this codebase expects.
///
/// The legacy JwtBearer handler maps inbound JWT short claim names to long URN-style ones
/// by default (sub → ClaimTypes.NameIdentifier, email → ClaimTypes.Email). OpenIddict's
/// validation handler uses JsonWebTokenHandler which does not do this mapping, so existing
/// handlers that read FindFirstValue(ClaimTypes.NameIdentifier) get null with OIDC tokens.
///
/// This transformation runs once per request after authentication and adds NameIdentifier
/// and Email claims sourced from sub/email when they are missing. Idempotent.
/// </summary>
public sealed class SubjectClaimTransformation : IClaimsTransformation
{
    public Task<ClaimsPrincipal> TransformAsync(ClaimsPrincipal principal)
    {
        if (principal.Identity is not ClaimsIdentity identity || !identity.IsAuthenticated)
            return Task.FromResult(principal);

        AddIfMissing(identity, ClaimTypes.NameIdentifier, OpenIddictConstants.Claims.Subject);
        AddIfMissing(identity, ClaimTypes.Email, OpenIddictConstants.Claims.Email);

        return Task.FromResult(principal);
    }

    private static void AddIfMissing(ClaimsIdentity identity, string targetType, string sourceType)
    {
        if (identity.FindFirst(targetType) is not null) return;
        var source = identity.FindFirst(sourceType);
        if (source is null) return;
        identity.AddClaim(new Claim(targetType, source.Value));
    }
}
