using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Infrastructure.Auth.Oidc;

/// <summary>
/// Loads (and on first run, generates and persists) the OIDC signing and encryption
/// certificates from PostgreSQL so every API instance shares the same keys.
/// </summary>
public sealed class OpenIddictCertificateStore(IServiceScopeFactory scopeFactory)
{
    public const string SigningUse = "signing";
    public const string EncryptionUse = "encryption";

    private X509Certificate2? _signing;
    private X509Certificate2? _encryption;
    private readonly SemaphoreSlim _gate = new(1, 1);

    public X509Certificate2 SigningCertificate => _signing
        ?? throw new InvalidOperationException("Signing certificate has not been initialized.");

    public X509Certificate2 EncryptionCertificate => _encryption
        ?? throw new InvalidOperationException("Encryption certificate has not been initialized.");

    public async Task InitializeAsync(CancellationToken cancellationToken = default)
    {
        await _gate.WaitAsync(cancellationToken);
        try
        {
            if (_signing is not null && _encryption is not null)
                return;

            using var scope = scopeFactory.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            _signing = await LoadOrCreateAsync(db, SigningUse, X509KeyUsageFlags.DigitalSignature, cancellationToken);
            _encryption = await LoadOrCreateAsync(db, EncryptionUse, X509KeyUsageFlags.KeyEncipherment, cancellationToken);
        }
        finally
        {
            _gate.Release();
        }
    }

    private static async Task<X509Certificate2> LoadOrCreateAsync(
        AppDbContext db,
        string use,
        X509KeyUsageFlags usageFlags,
        CancellationToken ct)
    {
        var existing = await db.OpenIddictSigningCertificates
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.Use == use, ct);

        if (existing is not null && existing.NotAfter > DateTime.UtcNow.AddDays(30))
        {
            return X509CertificateLoader.LoadPkcs12(
                existing.PfxBytes,
                existing.PfxPassword,
                X509KeyStorageFlags.EphemeralKeySet);
        }

        var (cert, pfx, password) = GenerateRsaCertificate(
            subject: $"CN=ProjectManager OIDC {use}",
            usageFlags: usageFlags,
            lifetime: TimeSpan.FromDays(365 * 2));

        var record = new OpenIddictSigningCertificate
        {
            Id = Guid.NewGuid(),
            Use = use,
            PfxBytes = pfx,
            PfxPassword = password,
            NotBefore = cert.NotBefore.ToUniversalTime(),
            NotAfter = cert.NotAfter.ToUniversalTime(),
            CreatedAt = DateTime.UtcNow,
        };

        if (existing is not null)
        {
            db.OpenIddictSigningCertificates.Remove(
                await db.OpenIddictSigningCertificates.FirstAsync(c => c.Id == existing.Id, ct));
        }

        db.OpenIddictSigningCertificates.Add(record);
        await db.SaveChangesAsync(ct);

        return cert;
    }

    private static (X509Certificate2 Cert, byte[] Pfx, string Password) GenerateRsaCertificate(
        string subject,
        X509KeyUsageFlags usageFlags,
        TimeSpan lifetime)
    {
        using var rsa = RSA.Create(2048);
        var request = new CertificateRequest(
            subject,
            rsa,
            HashAlgorithmName.SHA256,
            RSASignaturePadding.Pkcs1);

        request.CertificateExtensions.Add(new X509KeyUsageExtension(usageFlags, critical: true));
        request.CertificateExtensions.Add(new X509BasicConstraintsExtension(false, false, 0, critical: true));

        var notBefore = DateTimeOffset.UtcNow.AddMinutes(-5);
        var notAfter = notBefore.Add(lifetime);

        using var temp = request.CreateSelfSigned(notBefore, notAfter);
        var password = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));
        var pfx = temp.Export(X509ContentType.Pfx, password);

        var loaded = X509CertificateLoader.LoadPkcs12(
            pfx,
            password,
            X509KeyStorageFlags.EphemeralKeySet);

        return (loaded, pfx, password);
    }
}
