using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class OpenIddictSigningCertificateConfiguration : IEntityTypeConfiguration<OpenIddictSigningCertificate>
{
    public void Configure(EntityTypeBuilder<OpenIddictSigningCertificate> builder)
    {
        builder.ToTable("OpenIddictSigningCertificates");
        builder.HasKey(c => c.Id);
        builder.Property(c => c.Use).HasMaxLength(32).IsRequired();
        builder.Property(c => c.PfxPassword).HasMaxLength(128).IsRequired();
        builder.HasIndex(c => c.Use).IsUnique();
    }
}
