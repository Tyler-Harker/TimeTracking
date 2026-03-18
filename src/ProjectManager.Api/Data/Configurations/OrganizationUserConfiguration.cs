using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class OrganizationUserConfiguration : IEntityTypeConfiguration<OrganizationUser>
{
    public void Configure(EntityTypeBuilder<OrganizationUser> builder)
    {
        builder.HasKey(ou => new { ou.OrganizationId, ou.UserId });

        builder.HasOne(ou => ou.Organization)
            .WithMany(o => o.OrganizationUsers)
            .HasForeignKey(ou => ou.OrganizationId);

        builder.HasOne(ou => ou.User)
            .WithMany(u => u.OrganizationUsers)
            .HasForeignKey(ou => ou.UserId);

        builder.Property(ou => ou.Role)
            .HasConversion<string>()
            .HasMaxLength(50);
    }
}
