using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class OrganizationClientConfiguration : IEntityTypeConfiguration<OrganizationClient>
{
    public void Configure(EntityTypeBuilder<OrganizationClient> builder)
    {
        builder.HasKey(oc => new { oc.OrganizationId, oc.ClientId });

        builder.HasOne(oc => oc.Organization)
            .WithMany(o => o.OrganizationClients)
            .HasForeignKey(oc => oc.OrganizationId);

        builder.HasOne(oc => oc.Client)
            .WithMany(c => c.OrganizationClients)
            .HasForeignKey(oc => oc.ClientId);
    }
}
