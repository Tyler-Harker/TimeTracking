using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.Exceptions;

namespace ProjectManager.Api.Features.Sync;

internal static class OwnerOnly
{
    public static async Task<Guid> EnsureOwnerAsync(
        AppDbContext db,
        IHttpContextAccessor http,
        Guid orgId,
        CancellationToken ct)
    {
        var userIdValue = http.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? throw new UnauthorizedAccessException("Not authenticated");
        var userId = Guid.Parse(userIdValue);

        var role = await db.OrganizationUsers
            .Where(ou => ou.OrganizationId == orgId && ou.UserId == userId)
            .Select(ou => (OrganizationRole?)ou.Role)
            .FirstOrDefaultAsync(ct);

        if (role != OrganizationRole.Owner)
            throw new ForbiddenException("Only organization owners can perform sync operations");

        return userId;
    }
}
