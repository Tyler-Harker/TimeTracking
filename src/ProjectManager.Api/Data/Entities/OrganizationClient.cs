namespace ProjectManager.Api.Data.Entities;

public class OrganizationClient
{
    public Guid OrganizationId { get; set; }
    public Organization Organization { get; set; } = null!;

    public Guid ClientId { get; set; }
    public Client Client { get; set; } = null!;

    public DateTime AssignedAt { get; set; }

    public ICollection<OrganizationClientProject> OrganizationClientProjects { get; set; } = [];
}
