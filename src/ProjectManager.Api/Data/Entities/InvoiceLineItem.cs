namespace ProjectManager.Api.Data.Entities;

public class InvoiceLineItem
{
    public Guid Id { get; set; }

    public Guid InvoiceId { get; set; }
    public Invoice Invoice { get; set; } = null!;

    public string Description { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal Amount { get; set; }
    public DateTime CreatedAt { get; set; }

    public ICollection<TimeEntry> TimeEntries { get; set; } = [];
}
