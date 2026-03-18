using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options)
    : IdentityDbContext<User, IdentityRole<Guid>, Guid>(options)
{
    private Guid? _tenantId;

    public void SetTenantId(Guid organizationId) => _tenantId = organizationId;

    public DbSet<Organization> Organizations => Set<Organization>();
    public DbSet<OrganizationUser> OrganizationUsers => Set<OrganizationUser>();
    public DbSet<Client> Clients => Set<Client>();
    public DbSet<OrganizationClient> OrganizationClients => Set<OrganizationClient>();
    public DbSet<Project> Projects => Set<Project>();
    public DbSet<OrganizationClientProject> OrganizationClientProjects => Set<OrganizationClientProject>();
    public DbSet<Team> Teams => Set<Team>();
    public DbSet<TeamMember> TeamMembers => Set<TeamMember>();
    public DbSet<TimeEntry> TimeEntries => Set<TimeEntry>();
    public DbSet<Invoice> Invoices => Set<Invoice>();
    public DbSet<InvoiceLineItem> InvoiceLineItems => Set<InvoiceLineItem>();
    public DbSet<ClientContact> ClientContacts => Set<ClientContact>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<ProjectTask> ProjectTasks => Set<ProjectTask>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);

        // Global query filters for multi-tenancy
        // EF Core re-evaluates _tenantId per query via the captured 'this' reference
        builder.Entity<TimeEntry>().HasQueryFilter(te => _tenantId == null || te.OrganizationId == _tenantId);
        builder.Entity<Invoice>().HasQueryFilter(i => _tenantId == null || i.OrganizationId == _tenantId);
    }

    public override int SaveChanges()
    {
        SetTimestamps();
        return base.SaveChanges();
    }

    public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        SetTimestamps();
        return base.SaveChangesAsync(cancellationToken);
    }

    private void SetTimestamps()
    {
        var now = DateTime.UtcNow;
        foreach (var entry in ChangeTracker.Entries())
        {
            if (entry.State == EntityState.Added)
            {
                if (entry.Entity is Organization org) { org.CreatedAt = now; org.UpdatedAt = now; }
                else if (entry.Entity is User user) { user.CreatedAt = now; user.UpdatedAt = now; }
                else if (entry.Entity is Client client) { client.CreatedAt = now; client.UpdatedAt = now; }
                else if (entry.Entity is Project project) { project.CreatedAt = now; project.UpdatedAt = now; }
                else if (entry.Entity is TimeEntry te) { te.CreatedAt = now; te.UpdatedAt = now; }
                else if (entry.Entity is ProjectTask pt) { pt.CreatedAt = now; pt.UpdatedAt = now; }
                else if (entry.Entity is Invoice inv) { inv.CreatedAt = now; inv.UpdatedAt = now; }
                else if (entry.Entity is InvoiceLineItem ili) { ili.CreatedAt = now; }
                else if (entry.Entity is Team team) { team.CreatedAt = now; }
                else if (entry.Entity is RefreshToken rt) { rt.CreatedAt = now; }
                else if (entry.Entity is OrganizationUser ou) { ou.JoinedAt = now; }
                else if (entry.Entity is OrganizationClient oc) { oc.AssignedAt = now; }
                else if (entry.Entity is OrganizationClientProject ocp) { ocp.AssignedAt = now; }
                else if (entry.Entity is TeamMember tm) { tm.JoinedAt = now; }
                else if (entry.Entity is ClientContact cc) { cc.CreatedAt = now; cc.UpdatedAt = now; }
            }
            else if (entry.State == EntityState.Modified)
            {
                if (entry.Entity is Organization org) org.UpdatedAt = now;
                else if (entry.Entity is User user) user.UpdatedAt = now;
                else if (entry.Entity is Client client) client.UpdatedAt = now;
                else if (entry.Entity is Project project) project.UpdatedAt = now;
                else if (entry.Entity is TimeEntry te) te.UpdatedAt = now;
                else if (entry.Entity is ProjectTask pt) pt.UpdatedAt = now;
                else if (entry.Entity is Invoice inv) inv.UpdatedAt = now;
                else if (entry.Entity is ClientContact cc) cc.UpdatedAt = now;
            }
        }
    }
}
