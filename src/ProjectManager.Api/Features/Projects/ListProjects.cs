using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Projects;

public static class ListProjects
{
    public record Query(Guid? ClientId) : IRequest<IEnumerable<Response>>;
    public record Response(Guid Id, string Name, string Status, Guid ClientId, string ClientName, decimal? BudgetAmount);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, IEnumerable<Response>>
    {
        public async Task<IEnumerable<Response>> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var query = db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId);

            if (request.ClientId.HasValue)
                query = query.Where(ocp => ocp.ClientId == request.ClientId.Value);

            return await query
                .Select(ocp => new Response(
                    ocp.Project.Id,
                    ocp.Project.Name,
                    ocp.Project.Status.ToString(),
                    ocp.ClientId,
                    ocp.OrganizationClient.Client.Name,
                    ocp.Project.BudgetAmount))
                .ToListAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/projects", async (Guid? clientId, ISender sender) =>
            {
                var response = await sender.Send(new Query(clientId));
                return Results.Ok(response);
            })
            .WithName("ListProjects")
            .WithSummary("List all projects")
            .WithDescription("Lists all projects in the current organization. Optionally filter by client using the clientId query parameter. Requires the X-Organization-Id header.")
            .Produces<IEnumerable<Response>>(StatusCodes.Status200OK)
            .WithTags("Projects")
            .RequireAuthorization();
        }
    }
}
