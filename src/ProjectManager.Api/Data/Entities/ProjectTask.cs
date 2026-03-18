namespace ProjectManager.Api.Data.Entities;

public enum TaskStatus
{
    Open,
    InProgress,
    Completed
}

public enum TaskPriority
{
    Low,
    Medium,
    High,
    Urgent
}

public class ProjectTask
{
    public Guid Id { get; set; }

    public Guid ProjectId { get; set; }
    public Project Project { get; set; } = null!;

    public Guid? AssigneeId { get; set; }
    public User? Assignee { get; set; }

    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public TaskStatus Status { get; set; } = TaskStatus.Open;
    public TaskPriority Priority { get; set; } = TaskPriority.Medium;
    public DateOnly? DueDate { get; set; }
    public decimal? EstimatedHours { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<TimeEntry> TimeEntries { get; set; } = [];
}
