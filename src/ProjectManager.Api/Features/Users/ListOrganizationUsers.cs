using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Users;

public static class ListOrganizationUsers
{
    public record Query : IRequest<IEnumerable<Response>>;
    public record Response(Guid Id, string Name, string Email, string Role);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, IEnumerable<Response>>
    {
        public async Task<IEnumerable<Response>> Handle(Query request, CancellationToken cancellationToken)
        {
            return await db.OrganizationUsers
                .Where(ou => ou.OrganizationId == orgService.OrganizationId!.Value)
                .OrderBy(ou => ou.User.FirstName)
                .ThenBy(ou => ou.User.LastName)
                .Select(ou => new Response(
                    ou.UserId,
                    ou.User.FirstName + " " + ou.User.LastName,
                    ou.User.Email!,
                    ou.Role.ToString()))
                .ToListAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/users", async (ISender sender) =>
            {
                var response = await sender.Send(new Query());
                return Results.Ok(response);
            })
            .WithName("ListOrganizationUsers")
            .WithSummary("List users in the current organization")
            .WithDescription("Lists all users that belong to the current organization. Requires the X-Organization-Id header.")
            .Produces<IEnumerable<Response>>(StatusCodes.Status200OK)
            .WithTags("Users")
            .RequireAuthorization();
        }
    }
}
