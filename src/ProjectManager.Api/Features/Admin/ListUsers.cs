using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Admin;

public static class ListUsers
{
    public record Query(string? Search, int Page, int PageSize) : IRequest<Response>;

    public record Response(IEnumerable<UserItem> Items, int Total, int Page, int PageSize);

    public record UserItem(
        Guid Id,
        string Email,
        string FirstName,
        string LastName,
        bool IsActive,
        DateTime CreatedAt,
        DateTime UpdatedAt);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var page = request.Page < 1 ? 1 : request.Page;
            var pageSize = request.PageSize is < 1 or > 200 ? 50 : request.PageSize;

            var query = db.Users.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(request.Search))
            {
                var term = $"%{request.Search.Trim()}%";
                query = query.Where(u =>
                    EF.Functions.ILike(u.Email!, term) ||
                    EF.Functions.ILike(u.FirstName, term) ||
                    EF.Functions.ILike(u.LastName, term));
            }

            var total = await query.CountAsync(cancellationToken);

            var items = await query
                .OrderBy(u => u.Email)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(u => new UserItem(
                    u.Id,
                    u.Email!,
                    u.FirstName,
                    u.LastName,
                    u.IsActive,
                    u.CreatedAt,
                    u.UpdatedAt))
                .ToListAsync(cancellationToken);

            return new Response(items, total, page, pageSize);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/admin/users", async (
                string? search,
                int? page,
                int? pageSize,
                ISender sender) =>
            {
                var response = await sender.Send(new Query(search, page ?? 1, pageSize ?? 50));
                return Results.Ok(response);
            })
            .WithName("AdminListUsers")
            .WithSummary("List all users")
            .WithDescription("Returns a paginated list of every user in the system. Requires an admin-scoped token.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .WithTags("Admin")
            .RequireAuthorization("Admin");
        }
    }
}
