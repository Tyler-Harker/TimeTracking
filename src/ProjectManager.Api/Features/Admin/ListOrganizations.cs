using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Admin;

public static class ListOrganizations
{
    public record Query(string? Search, int Page, int PageSize) : IRequest<Response>;

    public record Response(IEnumerable<OrganizationItem> Items, int Total, int Page, int PageSize);

    public record OwnerInfo(Guid UserId, string Email, string FirstName, string LastName);

    public record OrganizationItem(
        Guid Id,
        string Name,
        string Slug,
        string? Description,
        bool IsActive,
        DateTime CreatedAt,
        int MemberCount,
        IReadOnlyList<OwnerInfo> Owners);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var page = request.Page < 1 ? 1 : request.Page;
            var pageSize = request.PageSize is < 1 or > 200 ? 50 : request.PageSize;

            var query = db.Organizations.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(request.Search))
            {
                var term = $"%{request.Search.Trim()}%";
                query = query.Where(o =>
                    EF.Functions.ILike(o.Name, term) ||
                    EF.Functions.ILike(o.Slug, term));
            }

            var total = await query.CountAsync(cancellationToken);

            var page1 = await query
                .OrderBy(o => o.Name)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(o => new
                {
                    o.Id,
                    o.Name,
                    o.Slug,
                    o.Description,
                    o.IsActive,
                    o.CreatedAt,
                    MemberCount = o.OrganizationUsers.Count,
                    Owners = o.OrganizationUsers
                        .Where(ou => ou.Role == OrganizationRole.Owner)
                        .Select(ou => new OwnerInfo(ou.UserId, ou.User.Email!, ou.User.FirstName, ou.User.LastName))
                        .ToList(),
                })
                .ToListAsync(cancellationToken);

            var items = page1
                .Select(o => new OrganizationItem(o.Id, o.Name, o.Slug, o.Description, o.IsActive, o.CreatedAt, o.MemberCount, o.Owners))
                .ToList();

            return new Response(items, total, page, pageSize);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/admin/organizations", async (
                string? search,
                int? page,
                int? pageSize,
                ISender sender) =>
            {
                var response = await sender.Send(new Query(search, page ?? 1, pageSize ?? 50));
                return Results.Ok(response);
            })
            .WithName("AdminListOrganizations")
            .WithSummary("List all organizations")
            .WithDescription("Returns a paginated list of every organization in the system, including current owner(s) and member count. Requires an admin-scoped token.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .WithTags("Admin")
            .RequireAuthorization("Admin");
        }
    }
}
