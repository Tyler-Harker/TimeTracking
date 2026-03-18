using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class OrganizationClientProjectConfiguration : IEntityTypeConfiguration<OrganizationClientProject>
{
    public void Configure(EntityTypeBuilder<OrganizationClientProject> builder)
    {
        builder.HasKey(ocp => new { ocp.OrganizationId, ocp.ClientId, ocp.ProjectId });

        builder.HasOne(ocp => ocp.OrganizationClient)
            .WithMany(oc => oc.OrganizationClientProjects)
            .HasForeignKey(ocp => new { ocp.OrganizationId, ocp.ClientId });

        builder.HasOne(ocp => ocp.Project)
            .WithMany(p => p.OrganizationClientProjects)
            .HasForeignKey(ocp => ocp.ProjectId);
    }
}
