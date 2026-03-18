namespace ProjectManager.Api.Data.Entities;

public enum InvoiceStatus
{
    Draft,
    Sent,
    Paid,
    Overdue,
    Cancelled
}

public class Invoice
{
    public Guid Id { get; set; }

    public Guid OrganizationId { get; set; }
    public Organization Organization { get; set; } = null!;

    public Guid? ClientId { get; set; }
    public Client? Client { get; set; }

    public Guid? ProjectId { get; set; }
    public Project? Project { get; set; }

    public string InvoiceNumber { get; set; } = string.Empty;
    public InvoiceStatus Status { get; set; } = InvoiceStatus.Draft;
    public decimal TotalAmount { get; set; }
    public decimal TaxRate { get; set; }
    public decimal TaxAmount { get; set; }
    public string? Notes { get; set; }
    public DateOnly IssuedDate { get; set; }
    public DateOnly DueDate { get; set; }
    public DateOnly? PaidDate { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<InvoiceLineItem> LineItems { get; set; } = [];
}
