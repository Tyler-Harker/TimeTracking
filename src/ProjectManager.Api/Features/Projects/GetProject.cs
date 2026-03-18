using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Projects;

public static class GetProject
{
    public record Query(Guid Id) : IRequest<Response>;

    public record Response(
        Guid Id,
        string Name,
        string? Description,
        string Status,
        decimal? BudgetAmount,
        decimal? DefaultBillableRate,
        DateOnly? StartDate,
        DateOnly? EndDate,
        DateTime CreatedAt,
        Guid ClientId,
        string ClientName,
        decimal? InheritedBillableRate);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var result = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.Id)
                .Select(ocp => new Response(
                    ocp.Project.Id,
                    ocp.Project.Name,
                    ocp.Project.Description,
                    ocp.Project.Status.ToString(),
                    ocp.Project.BudgetAmount,
                    ocp.Project.DefaultBillableRate,
                    ocp.Project.StartDate,
                    ocp.Project.EndDate,
                    ocp.Project.CreatedAt,
                    ocp.ClientId,
                    ocp.OrganizationClient.Client.Name,
                    ocp.OrganizationClient.Client.DefaultBillableRate ?? ocp.OrganizationClient.Organization.DefaultBillableRate))
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Project not found");

            return result;
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/projects/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetProject")
            .WithSummary("Get a project by ID")
            .WithDescription("Retrieves a project by its unique identifier, including its associated client information. The project must belong to the current organization. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Projects")
            .RequireAuthorization();
        }
    }
}
