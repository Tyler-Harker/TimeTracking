using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class TimeEntryConfiguration : IEntityTypeConfiguration<TimeEntry>
{
    public void Configure(EntityTypeBuilder<TimeEntry> builder)
    {
        builder.HasKey(te => te.Id);
        builder.Property(te => te.Hours).HasPrecision(8, 2);
        builder.Property(te => te.Description).HasMaxLength(2000);
        builder.Property(te => te.BillableRate).HasPrecision(18, 2);

        builder.HasOne(te => te.User)
            .WithMany(u => u.TimeEntries)
            .HasForeignKey(te => te.UserId);

        builder.HasOne(te => te.Project)
            .WithMany(p => p.TimeEntries)
            .HasForeignKey(te => te.ProjectId);

        builder.HasOne(te => te.Organization)
            .WithMany(o => o.TimeEntries)
            .HasForeignKey(te => te.OrganizationId);

        builder.HasOne(te => te.InvoiceLineItem)
            .WithMany(ili => ili.TimeEntries)
            .HasForeignKey(te => te.InvoiceLineItemId)
            .IsRequired(false);

        builder.HasOne(te => te.Task)
            .WithMany(t => t.TimeEntries)
            .HasForeignKey(te => te.TaskId)
            .IsRequired(false);

        builder.HasIndex(te => new { te.OrganizationId, te.UserId, te.Date });
    }
}
