namespace ProjectManager.Api.Data.Entities;

public class TimeEntry
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public Guid ProjectId { get; set; }
    public Project Project { get; set; } = null!;

    public Guid OrganizationId { get; set; }
    public Organization Organization { get; set; } = null!;

    public DateOnly Date { get; set; }
    public decimal Hours { get; set; }
    public string? Description { get; set; }
    public decimal? BillableRate { get; set; }
    public bool IsBillable { get; set; }
    public bool IsInvoiced { get; set; }

    public Guid? InvoiceLineItemId { get; set; }
    public InvoiceLineItem? InvoiceLineItem { get; set; }

    public Guid? TaskId { get; set; }
    public ProjectTask? Task { get; set; }

    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
