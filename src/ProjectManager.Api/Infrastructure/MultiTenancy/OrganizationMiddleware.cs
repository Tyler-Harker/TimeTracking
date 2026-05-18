using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Infrastructure.MultiTenancy;

public class OrganizationMiddleware(RequestDelegate next)
{
    private static readonly HashSet<string> ExcludedPaths =
    [
        "/api/auth",
        "/api/organizations",
        "/health",
        "/alive",
        "/openapi"
    ];

    public async Task InvokeAsync(HttpContext context, AppDbContext db, ICurrentOrganizationService orgService)
    {
        var path = context.Request.Path.Value?.ToLowerInvariant() ?? "";

        // Skip for excluded paths
        if (IsExcludedPath(path))
        {
            await next(context);
            return;
        }

        // Require authentication first
        if (context.User.Identity?.IsAuthenticated != true)
        {
            await next(context);
            return;
        }

        if (!context.Request.Headers.TryGetValue("X-Organization-Id", out var orgIdHeader) ||
            !Guid.TryParse(orgIdHeader, out var organizationId))
        {
            context.Response.StatusCode = 400;
            await context.Response.WriteAsJsonAsync(new { error = "X-Organization-Id header is required" });
            return;
        }

        var userId = Guid.Parse(context.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

        var isMember = await db.OrganizationUsers
            .AnyAsync(ou => ou.OrganizationId == organizationId && ou.UserId == userId);

        if (!isMember)
        {
            context.Response.StatusCode = 403;
            await context.Response.WriteAsJsonAsync(new { error = "You are not a member of this organization" });
            return;
        }

        orgService.SetOrganizationId(organizationId);
        db.SetTenantId(organizationId);

        await next(context);
    }

    private static bool IsExcludedPath(string path)
    {
        // Exact match for org listing/creation (but not sub-routes like /api/organizations/{id}/...)
        // Auth paths are always excluded
        if (path.StartsWith("/api/auth")) return true;
        if (path.StartsWith("/api/admin")) return true;
        if (path.StartsWith("/health") || path.StartsWith("/alive")) return true;
        if (path.StartsWith("/openapi")) return true;
        if (path.StartsWith("/connect")) return true;
        if (path.StartsWith("/account")) return true;
        if (path.StartsWith("/.well-known")) return true;

        // Allow org creation (POST /api/organizations) and listing (GET /api/organizations) without header
        // But sub-routes need it - handled by checking if path is exactly /api/organizations
        if (path == "/api/organizations") return true;

        return false;
    }
}
