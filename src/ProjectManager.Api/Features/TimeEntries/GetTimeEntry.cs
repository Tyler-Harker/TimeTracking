using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.TimeEntries;

public static class GetTimeEntry
{
    public record Query(Guid Id) : IRequest<Response>;

    public record Response(
        Guid Id,
        Guid UserId,
        string UserName,
        Guid ProjectId,
        string ProjectName,
        DateOnly Date,
        decimal Hours,
        string? Description,
        decimal? BillableRate,
        bool IsBillable,
        bool IsInvoiced,
        DateTime CreatedAt,
        decimal? InheritedBillableRate,
        Guid? TaskId,
        string? TaskName);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var entry = await db.TimeEntries
                .Include(te => te.User)
                .Include(te => te.Project)
                .Include(te => te.Task)
                .FirstOrDefaultAsync(te => te.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Time entry not found");

            var inheritedRate = await db.OrganizationClientProjects
                .Where(ocp => ocp.ProjectId == entry.ProjectId)
                .Select(ocp => ocp.Project.DefaultBillableRate
                    ?? ocp.OrganizationClient.Client.DefaultBillableRate
                    ?? ocp.OrganizationClient.Organization.DefaultBillableRate)
                .FirstOrDefaultAsync(cancellationToken);

            return new Response(
                entry.Id, entry.UserId, $"{entry.User.FirstName} {entry.User.LastName}",
                entry.ProjectId, entry.Project.Name,
                entry.Date, entry.Hours, entry.Description, entry.BillableRate,
                entry.IsBillable, entry.IsInvoiced, entry.CreatedAt, inheritedRate,
                entry.TaskId, entry.Task?.Name);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/time-entries/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetTimeEntry")
            .WithSummary("Get a time entry by ID")
            .WithDescription("Retrieves a time entry by its unique identifier, including associated user and project details. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("TimeEntries")
            .RequireAuthorization();
        }
    }
}
