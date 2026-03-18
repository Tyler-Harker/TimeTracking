using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class ProjectConfiguration : IEntityTypeConfiguration<Project>
{
    public void Configure(EntityTypeBuilder<Project> builder)
    {
        builder.HasKey(p => p.Id);
        builder.Property(p => p.Name).HasMaxLength(200).IsRequired();
        builder.Property(p => p.Description).HasMaxLength(2000);
        builder.Property(p => p.Status).HasConversion<string>().HasMaxLength(50);
        builder.Property(p => p.BudgetAmount).HasPrecision(18, 2);
        builder.Property(p => p.DefaultBillableRate).HasPrecision(18, 2);
    }
}
