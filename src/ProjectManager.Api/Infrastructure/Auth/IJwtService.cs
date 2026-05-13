using System.Security.Claims;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Infrastructure.Auth;

public interface IJwtService
{
    string GenerateToken(User user, IEnumerable<OrganizationUser> memberships);
    string GenerateAdminToken(string username, int expirationMinutes);
    string GenerateRefreshToken();
    ClaimsPrincipal? GetPrincipalFromExpiredToken(string token);
}
