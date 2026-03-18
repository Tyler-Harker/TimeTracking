using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class ClientConfiguration : IEntityTypeConfiguration<Client>
{
    public void Configure(EntityTypeBuilder<Client> builder)
    {
        builder.HasKey(c => c.Id);
        builder.Property(c => c.Name).HasMaxLength(200).IsRequired();
        builder.Property(c => c.Address).HasMaxLength(500);
        builder.Property(c => c.Website).HasMaxLength(500);
        builder.Property(c => c.DefaultBillableRate).HasPrecision(18, 2);
    }
}
