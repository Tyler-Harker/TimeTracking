using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Teams;

public static class GetTeam
{
    public record Query(Guid Id) : IRequest<Response>;

    public record Response(
        Guid Id,
        Guid ProjectId,
        string Name,
        string? Description,
        DateTime CreatedAt,
        IEnumerable<MemberInfo> Members);

    public record MemberInfo(Guid UserId, string Email, string FirstName, string LastName, DateTime JoinedAt);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var team = await db.Teams
                .Include(t => t.TeamMembers).ThenInclude(tm => tm.User)
                .Where(t => t.Id == request.Id)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Team not found");

            // Verify team's project belongs to this org
            var projectInOrg = await db.OrganizationClientProjects
                .AnyAsync(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == team.ProjectId, cancellationToken);
            if (!projectInOrg)
                throw new KeyNotFoundException("Team not found");

            return new Response(
                team.Id, team.ProjectId, team.Name, team.Description, team.CreatedAt,
                team.TeamMembers.Select(tm => new MemberInfo(
                    tm.UserId, tm.User.Email!, tm.User.FirstName, tm.User.LastName, tm.JoinedAt)));
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/teams/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetTeam")
            .WithSummary("Get a team by ID")
            .WithDescription("Retrieves a team by its unique identifier, including its members. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Teams")
            .RequireAuthorization();
        }
    }
}
