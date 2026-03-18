namespace ProjectManager.Api.Data.Entities;

public enum ProjectStatus
{
    Planned,
    Active,
    OnHold,
    Completed,
    Cancelled
}

public class Project
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public ProjectStatus Status { get; set; } = ProjectStatus.Planned;
    public decimal? BudgetAmount { get; set; }
    public decimal? DefaultBillableRate { get; set; }
    public DateOnly? StartDate { get; set; }
    public DateOnly? EndDate { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<OrganizationClientProject> OrganizationClientProjects { get; set; } = [];
    public ICollection<Team> Teams { get; set; } = [];
    public ICollection<TimeEntry> TimeEntries { get; set; } = [];
    public ICollection<Invoice> Invoices { get; set; } = [];
    public ICollection<ProjectTask> Tasks { get; set; } = [];
}
