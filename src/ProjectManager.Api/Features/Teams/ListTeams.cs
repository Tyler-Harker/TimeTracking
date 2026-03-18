using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Teams;

public static class ListTeams
{
    public record Query(Guid ProjectId) : IRequest<IEnumerable<Response>>;
    public record Response(Guid Id, string Name, string? Description, int MemberCount);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, IEnumerable<Response>>
    {
        public async Task<IEnumerable<Response>> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            // Verify project belongs to org
            var projectInOrg = await db.OrganizationClientProjects
                .AnyAsync(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.ProjectId, cancellationToken);
            if (!projectInOrg)
                throw new KeyNotFoundException("Project not found in this organization");

            return await db.Teams
                .Where(t => t.ProjectId == request.ProjectId)
                .Select(t => new Response(t.Id, t.Name, t.Description, t.TeamMembers.Count))
                .ToListAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/teams", async (Guid projectId, ISender sender) =>
            {
                var response = await sender.Send(new Query(projectId));
                return Results.Ok(response);
            })
            .WithName("ListTeams")
            .WithSummary("List teams for a project")
            .WithDescription("Lists all teams for a given project with member counts. The projectId query parameter is required. Requires the X-Organization-Id header.")
            .Produces<IEnumerable<Response>>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Teams")
            .RequireAuthorization();
        }
    }
}
