using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class InvoiceLineItemConfiguration : IEntityTypeConfiguration<InvoiceLineItem>
{
    public void Configure(EntityTypeBuilder<InvoiceLineItem> builder)
    {
        builder.HasKey(ili => ili.Id);
        builder.Property(ili => ili.Description).HasMaxLength(500).IsRequired();
        builder.Property(ili => ili.Quantity).HasPrecision(10, 2);
        builder.Property(ili => ili.UnitPrice).HasPrecision(18, 2);
        builder.Property(ili => ili.Amount).HasPrecision(18, 2);

        builder.HasOne(ili => ili.Invoice)
            .WithMany(i => i.LineItems)
            .HasForeignKey(ili => ili.InvoiceId);
    }
}
