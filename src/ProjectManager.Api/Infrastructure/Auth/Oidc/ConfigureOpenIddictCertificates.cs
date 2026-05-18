using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using OpenIddict.Server;

namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

/// <summary>
/// Late-binds the signing/encryption credentials sourced from PostgreSQL into the
/// OpenIddict server options. Runs once on first access.
/// </summary>
public sealed class ConfigureOpenIddictCertificates(OpenIddictCertificateStore store)
    : IPostConfigureOptions<OpenIddictServerOptions>
{
    public void PostConfigure(string? name, OpenIddictServerOptions options)
    {
        store.InitializeAsync().GetAwaiter().GetResult();

        var signing = store.SigningCertificate;
        var encryption = store.EncryptionCertificate;

        var signingKey = new X509SecurityKey(signing) { KeyId = ComputeKeyId(signing) };
        options.SigningCredentials.Add(new SigningCredentials(signingKey, SecurityAlgorithms.RsaSha256));

        var encryptionKey = new X509SecurityKey(encryption) { KeyId = ComputeKeyId(encryption) };
        options.EncryptionCredentials.Add(new EncryptingCredentials(
            encryptionKey,
            SecurityAlgorithms.RsaOAEP,
            SecurityAlgorithms.Aes256CbcHmacSha512));
    }

    private static string ComputeKeyId(System.Security.Cryptography.X509Certificates.X509Certificate2 cert)
        => Convert.ToBase64String(cert.GetCertHash()).TrimEnd('=').Replace('+', '-').Replace('/', '_');
}
