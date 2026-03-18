using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Tasks;

public static class UpdateTask
{
    public record Command(
        Guid Id,
        string Name,
        string? Description,
        Data.Entities.TaskStatus Status,
        TaskPriority Priority,
        Guid? AssigneeId,
        DateOnly? DueDate,
        decimal? EstimatedHours) : IRequest<Response>;

    public record Response(
        Guid Id,
        string Name,
        string? Description,
        string Status,
        string Priority,
        Guid? AssigneeId,
        string? AssigneeName,
        DateOnly? DueDate,
        decimal? EstimatedHours);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(2000);
            RuleFor(x => x.Status).IsInEnum();
            RuleFor(x => x.Priority).IsInEnum();
            RuleFor(x => x.EstimatedHours).GreaterThan(0).When(x => x.EstimatedHours.HasValue);
        }
    }

    public class Handler(AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var task = await db.ProjectTasks
                .Include(t => t.Assignee)
                .FirstOrDefaultAsync(t => t.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Task not found");

            string? assigneeName = null;
            if (request.AssigneeId.HasValue)
            {
                if (request.AssigneeId != task.AssigneeId)
                {
                    var assignee = await db.Users.FindAsync([request.AssigneeId.Value], cancellationToken)
                        ?? throw new KeyNotFoundException("Assignee not found");
                    assigneeName = $"{assignee.FirstName} {assignee.LastName}";
                }
                else if (task.Assignee != null)
                {
                    assigneeName = $"{task.Assignee.FirstName} {task.Assignee.LastName}";
                }
            }

            task.Name = request.Name;
            task.Description = request.Description;
            task.Status = request.Status;
            task.Priority = request.Priority;
            task.AssigneeId = request.AssigneeId;
            task.DueDate = request.DueDate;
            task.EstimatedHours = request.EstimatedHours;

            await db.SaveChangesAsync(cancellationToken);

            return new Response(
                task.Id, task.Name, task.Description,
                task.Status.ToString(), task.Priority.ToString(),
                task.AssigneeId, assigneeName,
                task.DueDate, task.EstimatedHours);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/tasks/{id:guid}", async (Guid id, UpdateRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(
                    id, body.Name, body.Description, body.Status, body.Priority,
                    body.AssigneeId, body.DueDate, body.EstimatedHours));
                return Results.Ok(response);
            })
            .WithName("UpdateTask")
            .WithSummary("Update a task")
            .WithDescription("Updates an existing task by ID. Requires the X-Organization-Id header.")
            .Accepts<UpdateRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Tasks")
            .RequireAuthorization();
        }
    }

    public record UpdateRequest(
        string Name,
        string? Description,
        Data.Entities.TaskStatus Status,
        TaskPriority Priority,
        Guid? AssigneeId,
        DateOnly? DueDate,
        decimal? EstimatedHours);
}
