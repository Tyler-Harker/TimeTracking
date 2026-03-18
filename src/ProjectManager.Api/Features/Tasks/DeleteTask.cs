using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Tasks;

public static class DeleteTask
{
    public record Command(Guid Id) : IRequest;

    public class Handler(AppDbContext db) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var task = await db.ProjectTasks
                .FirstOrDefaultAsync(t => t.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Task not found");

            // Nullify TaskId on linked time entries
            await db.TimeEntries
                .Where(te => te.TaskId == request.Id)
                .ExecuteUpdateAsync(s => s.SetProperty(te => te.TaskId, (Guid?)null), cancellationToken);

            db.ProjectTasks.Remove(task);
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/tasks/{id:guid}", async (Guid id, ISender sender) =>
            {
                await sender.Send(new Command(id));
                return Results.NoContent();
            })
            .WithName("DeleteTask")
            .WithSummary("Delete a task")
            .WithDescription("Deletes a task by ID. Time entries linked to this task will have their task reference cleared. Requires the X-Organization-Id header.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Tasks")
            .RequireAuthorization();
        }
    }
}
