using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Admin;

public static class ListOrganizationMembers
{
    public record Query(Guid OrganizationId) : IRequest<Response>;

    public record Response(Guid OrganizationId, string OrganizationName, IEnumerable<Member> Members);

    public record Member(
        Guid UserId,
        string Email,
        string FirstName,
        string LastName,
        string Role,
        DateTime JoinedAt,
        bool IsActive);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var organization = await db.Organizations
                .AsNoTracking()
                .FirstOrDefaultAsync(o => o.Id == request.OrganizationId, cancellationToken)
                ?? throw new KeyNotFoundException("Organization not found");

            var members = await db.OrganizationUsers
                .AsNoTracking()
                .Include(ou => ou.User)
                .Where(ou => ou.OrganizationId == request.OrganizationId)
                .OrderBy(ou => ou.Role)
                .ThenBy(ou => ou.User.Email)
                .Select(ou => new Member(
                    ou.UserId,
                    ou.User.Email!,
                    ou.User.FirstName,
                    ou.User.LastName,
                    ou.Role.ToString(),
                    ou.JoinedAt,
                    ou.User.IsActive))
                .ToListAsync(cancellationToken);

            return new Response(organization.Id, organization.Name, members);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/admin/organizations/{organizationId:guid}/members", async (
                Guid organizationId,
                ISender sender) =>
            {
                var response = await sender.Send(new Query(organizationId));
                return Results.Ok(response);
            })
            .WithName("AdminListOrganizationMembers")
            .WithSummary("List members of an organization")
            .WithDescription("Returns every OrganizationUser row for the given organization with role and join date. Requires an admin-scoped token.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Admin")
            .RequireAuthorization("Admin");
        }
    }
}
