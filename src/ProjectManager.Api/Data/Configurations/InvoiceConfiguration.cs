using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class InvoiceConfiguration : IEntityTypeConfiguration<Invoice>
{
    public void Configure(EntityTypeBuilder<Invoice> builder)
    {
        builder.HasKey(i => i.Id);
        builder.Property(i => i.InvoiceNumber).HasMaxLength(50).IsRequired();
        builder.Property(i => i.Status).HasConversion<string>().HasMaxLength(50);
        builder.Property(i => i.TotalAmount).HasPrecision(18, 2);
        builder.Property(i => i.TaxRate).HasPrecision(8, 4);
        builder.Property(i => i.TaxAmount).HasPrecision(18, 2);
        builder.Property(i => i.Notes).HasMaxLength(2000);

        builder.HasIndex(i => new { i.OrganizationId, i.InvoiceNumber }).IsUnique();

        builder.HasOne(i => i.Organization)
            .WithMany(o => o.Invoices)
            .HasForeignKey(i => i.OrganizationId);

        builder.HasOne(i => i.Client)
            .WithMany()
            .HasForeignKey(i => i.ClientId)
            .IsRequired(false);

        builder.HasOne(i => i.Project)
            .WithMany(p => p.Invoices)
            .HasForeignKey(i => i.ProjectId)
            .IsRequired(false);
    }
}
