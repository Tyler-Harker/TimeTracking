using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class OrganizationConfiguration : IEntityTypeConfiguration<Organization>
{
    public void Configure(EntityTypeBuilder<Organization> builder)
    {
        builder.HasKey(o => o.Id);
        builder.Property(o => o.Name).HasMaxLength(200).IsRequired();
        builder.Property(o => o.Slug).HasMaxLength(200).IsRequired();
        builder.HasIndex(o => o.Slug).IsUnique();
        builder.Property(o => o.Description).HasMaxLength(1000);
        builder.Property(o => o.DefaultBillableRate).HasPrecision(18, 2);
    }
}
