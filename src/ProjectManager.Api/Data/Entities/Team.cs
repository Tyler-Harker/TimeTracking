namespace ProjectManager.Api.Data.Entities;

public class Team
{
    public Guid Id { get; set; }
    public Guid ProjectId { get; set; }
    public Project Project { get; set; } = null!;
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }

    public ICollection<TeamMember> TeamMembers { get; set; } = [];
}
