namespace ProjectManager.Api.Data.Entities;

public class OrganizationClientProject
{
    public Guid OrganizationId { get; set; }
    public Guid ClientId { get; set; }
    public OrganizationClient OrganizationClient { get; set; } = null!;

    public Guid ProjectId { get; set; }
    public Project Project { get; set; } = null!;

    public DateTime AssignedAt { get; set; }
}
