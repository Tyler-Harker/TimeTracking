namespace ProjectManager.Api.Data.Entities;

public enum OrganizationRole
{
    Member,
    Admin,
    Owner
}

public class OrganizationUser
{
    public Guid OrganizationId { get; set; }
    public Organization Organization { get; set; } = null!;

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public OrganizationRole Role { get; set; } = OrganizationRole.Member;
    public DateTime JoinedAt { get; set; }
}
