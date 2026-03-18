using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Teams;

public static class RemoveMember
{
    public record Command(Guid TeamId, Guid UserId) : IRequest;

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var team = await db.Teams.FindAsync([request.TeamId], cancellationToken)
                ?? throw new KeyNotFoundException("Team not found");

            // Verify team's project belongs to this org
            var projectInOrg = await db.OrganizationClientProjects
                .AnyAsync(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == team.ProjectId, cancellationToken);
            if (!projectInOrg)
                throw new KeyNotFoundException("Team not found");

            var member = await db.TeamMembers
                .FirstOrDefaultAsync(tm => tm.TeamId == request.TeamId && tm.UserId == request.UserId, cancellationToken)
                ?? throw new KeyNotFoundException("Member not found in team");

            db.TeamMembers.Remove(member);
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/teams/{teamId:guid}/members/{userId:guid}", async (Guid teamId, Guid userId, ISender sender) =>
            {
                await sender.Send(new Command(teamId, userId));
                return Results.NoContent();
            })
            .WithName("RemoveTeamMember")
            .WithSummary("Remove a member from a team")
            .WithDescription("Removes a user from a team. The team and member must both exist. Requires the X-Organization-Id header.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Teams")
            .RequireAuthorization();
        }
    }
}
