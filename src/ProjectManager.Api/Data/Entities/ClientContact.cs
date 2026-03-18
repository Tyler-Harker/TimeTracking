namespace ProjectManager.Api.Data.Entities;

public class ClientContact
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }
    public Client Client { get; set; } = null!;
    public string Name { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public bool IsStakeHolder { get; set; }
    public bool IsInvoicing { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
