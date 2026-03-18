using System.Security.Claims;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Tasks;

public static class CreateTask
{
    public record Command(
        Guid ProjectId,
        string Name,
        string? Description,
        TaskPriority Priority,
        Guid? AssigneeId,
        DateOnly? DueDate,
        decimal? EstimatedHours) : IRequest<Response>;

    public record Response(
        Guid Id,
        Guid ProjectId,
        string Name,
        string? Description,
        string Status,
        string Priority,
        Guid? AssigneeId,
        string? AssigneeName,
        DateOnly? DueDate,
        decimal? EstimatedHours,
        DateTime CreatedAt);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.ProjectId).NotEmpty();
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(2000);
            RuleFor(x => x.Priority).IsInEnum();
            RuleFor(x => x.EstimatedHours).GreaterThan(0).When(x => x.EstimatedHours.HasValue);
        }
    }

    public class Handler(
        AppDbContext db,
        ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            // Verify project belongs to org
            var projectExists = await db.OrganizationClientProjects
                .AnyAsync(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.ProjectId, cancellationToken);

            if (!projectExists)
                throw new KeyNotFoundException("Project not found in this organization");

            string? assigneeName = null;
            if (request.AssigneeId.HasValue)
            {
                var assignee = await db.Users.FindAsync([request.AssigneeId.Value], cancellationToken)
                    ?? throw new KeyNotFoundException("Assignee not found");
                assigneeName = $"{assignee.FirstName} {assignee.LastName}";
            }

            var task = new ProjectTask
            {
                ProjectId = request.ProjectId,
                AssigneeId = request.AssigneeId,
                Name = request.Name,
                Description = request.Description,
                Priority = request.Priority,
                DueDate = request.DueDate,
                EstimatedHours = request.EstimatedHours
            };

            db.ProjectTasks.Add(task);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(
                task.Id, task.ProjectId, task.Name, task.Description,
                task.Status.ToString(), task.Priority.ToString(),
                task.AssigneeId, assigneeName,
                task.DueDate, task.EstimatedHours, task.CreatedAt);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/tasks", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/tasks/{response.Id}", response);
            })
            .WithName("CreateTask")
            .WithSummary("Create a new task")
            .WithDescription("Creates a new task for a project within the current organization. Requires the X-Organization-Id header.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Tasks")
            .RequireAuthorization();
        }
    }
}
