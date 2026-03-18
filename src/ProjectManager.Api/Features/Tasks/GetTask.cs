using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Tasks;

public static class GetTask
{
    public record Query(Guid Id) : IRequest<Response>;

    public record Response(
        Guid Id,
        Guid ProjectId,
        string ProjectName,
        string Name,
        string? Description,
        string Status,
        string Priority,
        Guid? AssigneeId,
        string? AssigneeName,
        DateOnly? DueDate,
        decimal? EstimatedHours,
        decimal TotalHoursLogged,
        DateTime CreatedAt,
        DateTime UpdatedAt);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var task = await db.ProjectTasks
                .Include(t => t.Project)
                .Include(t => t.Assignee)
                .FirstOrDefaultAsync(t => t.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Task not found");

            var totalHoursLogged = await db.TimeEntries
                .Where(te => te.TaskId == request.Id)
                .SumAsync(te => te.Hours, cancellationToken);

            return new Response(
                task.Id, task.ProjectId, task.Project.Name,
                task.Name, task.Description,
                task.Status.ToString(), task.Priority.ToString(),
                task.AssigneeId,
                task.Assignee != null ? $"{task.Assignee.FirstName} {task.Assignee.LastName}" : null,
                task.DueDate, task.EstimatedHours, totalHoursLogged,
                task.CreatedAt, task.UpdatedAt);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/tasks/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetTask")
            .WithSummary("Get a task by ID")
            .WithDescription("Retrieves a task by its unique identifier, including project and assignee details. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Tasks")
            .RequireAuthorization();
        }
    }
}
