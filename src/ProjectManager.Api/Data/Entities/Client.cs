namespace ProjectManager.Api.Data.Entities;

public class Client
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Address { get; set; }
    public string? Website { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public bool IsActive { get; set; } = true;
    public decimal? DefaultBillableRate { get; set; }

    public ICollection<OrganizationClient> OrganizationClients { get; set; } = [];
    public ICollection<ClientContact> Contacts { get; set; } = [];
}
