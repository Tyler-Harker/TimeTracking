namespace ProjectManager.Api.Data.Entities;

public class OpenIddictSigningCertificate
{
    public Guid Id { get; set; }
    public string Use { get; set; } = string.Empty;
    public byte[] PfxBytes { get; set; } = [];
    public string PfxPassword { get; set; } = string.Empty;
    public DateTime NotBefore { get; set; }
    public DateTime NotAfter { get; set; }
    public DateTime CreatedAt { get; set; }
}
