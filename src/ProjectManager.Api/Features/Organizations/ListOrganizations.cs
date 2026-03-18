using System.Security.Claims;
using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Organizations;

public static class ListOrganizations
{
    public record Query : IRequest<IEnumerable<Response>>;

    public record Response(Guid Id, string Name, string Slug, string? Description, string Role, decimal? DefaultBillableRate);

    public class Handler(AppDbContext db, IHttpContextAccessor httpContextAccessor) : IRequestHandler<Query, IEnumerable<Response>>
    {
        public async Task<IEnumerable<Response>> Handle(Query request, CancellationToken cancellationToken)
        {
            var userId = Guid.Parse(httpContextAccessor.HttpContext!.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            return await db.OrganizationUsers
                .Include(ou => ou.Organization)
                .Where(ou => ou.UserId == userId && ou.Organization.IsActive)
                .Select(ou => new Response(
                    ou.OrganizationId,
                    ou.Organization.Name,
                    ou.Organization.Slug,
                    ou.Organization.Description,
                    ou.Role.ToString(),
                    ou.Organization.DefaultBillableRate))
                .ToListAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/organizations", async (ISender sender) =>
            {
                var response = await sender.Send(new Query());
                return Results.Ok(response);
            })
            .WithName("ListOrganizations")
            .WithSummary("List organizations for the current user")
            .WithDescription("Lists all active organizations that the currently authenticated user belongs to, along with the user's role in each organization.")
            .Produces<IEnumerable<Response>>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .WithTags("Organizations")
            .RequireAuthorization();
        }
    }
}
