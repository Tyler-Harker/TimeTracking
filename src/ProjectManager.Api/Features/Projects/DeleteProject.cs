using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Projects;

public static class DeleteProject
{
    public record Command(Guid Id) : IRequest;

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var project = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.Id)
                .Select(ocp => ocp.Project)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Project not found");

            project.Status = ProjectStatus.Cancelled;
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/projects/{id:guid}", async (Guid id, ISender sender) =>
            {
                await sender.Send(new Command(id));
                return Results.NoContent();
            })
            .WithName("DeleteProject")
            .WithSummary("Delete a project")
            .WithDescription("Cancels a project by setting its status to Cancelled. The project must belong to the current organization. Requires the X-Organization-Id header.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Projects")
            .RequireAuthorization();
        }
    }
}
