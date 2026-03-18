using Microsoft.AspNetCore.Identity;

namespace ProjectManager.Api.Data.Entities;

public class User : IdentityUser<Guid>
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? AvatarUrl { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public bool IsActive { get; set; } = true;

    public ICollection<OrganizationUser> OrganizationUsers { get; set; } = [];
    public ICollection<TeamMember> TeamMembers { get; set; } = [];
    public ICollection<TimeEntry> TimeEntries { get; set; } = [];
    public ICollection<RefreshToken> RefreshTokens { get; set; } = [];
    public ICollection<ProjectTask> AssignedTasks { get; set; } = [];
}
