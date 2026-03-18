using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class TeamConfiguration : IEntityTypeConfiguration<Team>
{
    public void Configure(EntityTypeBuilder<Team> builder)
    {
        builder.HasKey(t => t.Id);
        builder.Property(t => t.Name).HasMaxLength(200).IsRequired();
        builder.Property(t => t.Description).HasMaxLength(1000);

        builder.HasIndex(t => new { t.ProjectId, t.Name }).IsUnique();

        builder.HasOne(t => t.Project)
            .WithMany(p => p.Teams)
            .HasForeignKey(t => t.ProjectId);
    }
}
