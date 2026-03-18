using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Teams;

public static class AddMember
{
    public record Command(Guid TeamId, Guid UserId) : IRequest<Response>;
    public record Response(Guid TeamId, Guid UserId, DateTime JoinedAt);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.TeamId).NotEmpty();
            RuleFor(x => x.UserId).NotEmpty();
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var team = await db.Teams.FindAsync([request.TeamId], cancellationToken)
                ?? throw new KeyNotFoundException("Team not found");

            // Verify team's project belongs to this org
            var projectInOrg = await db.OrganizationClientProjects
                .AnyAsync(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == team.ProjectId, cancellationToken);
            if (!projectInOrg)
                throw new KeyNotFoundException("Team not found");

            // Verify user is a member of this org
            var userInOrg = await db.OrganizationUsers
                .AnyAsync(ou => ou.OrganizationId == orgId && ou.UserId == request.UserId, cancellationToken);
            if (!userInOrg)
                throw new InvalidOperationException("User is not a member of this organization");

            var alreadyMember = await db.TeamMembers
                .AnyAsync(tm => tm.TeamId == request.TeamId && tm.UserId == request.UserId, cancellationToken);
            if (alreadyMember)
                throw new InvalidOperationException("User is already a member of this team");

            var member = new TeamMember
            {
                TeamId = request.TeamId,
                UserId = request.UserId
            };

            db.TeamMembers.Add(member);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(member.TeamId, member.UserId, member.JoinedAt);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/teams/{teamId:guid}/members", async (Guid teamId, AddMemberRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(teamId, body.UserId));
                return Results.Created($"/api/teams/{teamId}", response);
            })
            .WithName("AddTeamMember")
            .WithSummary("Add a member to a team")
            .WithDescription("Adds a user to a team. The user must be a member of the current organization. A user cannot be added to the same team twice. Requires the X-Organization-Id header.")
            .Accepts<AddMemberRequest>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Teams")
            .RequireAuthorization();
        }
    }

    public record AddMemberRequest(Guid UserId);
}
