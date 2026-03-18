using System.Security.Claims;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.TimeEntries;

public static class CreateTimeEntry
{
    public record Command(
        Guid ProjectId,
        DateOnly Date,
        decimal Hours,
        string? Description,
        decimal? BillableRate,
        bool IsBillable,
        Guid? TaskId) : IRequest<Response>;

    public record Response(Guid Id, Guid ProjectId, DateOnly Date, decimal Hours, string? Description, bool IsBillable, decimal? BillableRate, Guid? TaskId, string? TaskName);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.ProjectId).NotEmpty();
            RuleFor(x => x.Date).NotEmpty();
            RuleFor(x => x.Hours).GreaterThan(0).LessThanOrEqualTo(24);
            RuleFor(x => x.Description).MaximumLength(2000);
            RuleFor(x => x.BillableRate).GreaterThanOrEqualTo(0).When(x => x.BillableRate.HasValue);
        }
    }

    public class Handler(
        AppDbContext db,
        ICurrentOrganizationService orgService,
        IHttpContextAccessor httpContextAccessor) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;
            var userId = Guid.Parse(httpContextAccessor.HttpContext!.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            // Verify project belongs to org and resolve full rate chain
            var rateData = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.ProjectId)
                .Select(ocp => new {
                    Project = ocp.Project,
                    ClientRate = ocp.OrganizationClient.Client.DefaultBillableRate,
                    OrgRate = ocp.OrganizationClient.Organization.DefaultBillableRate
                })
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Project not found in this organization");
            var project = rateData.Project;

            var billableRate = request.BillableRate ?? project.DefaultBillableRate ?? rateData.ClientRate ?? rateData.OrgRate;

            string? taskName = null;
            if (request.TaskId.HasValue)
            {
                var task = await db.ProjectTasks
                    .FirstOrDefaultAsync(t => t.Id == request.TaskId.Value && t.ProjectId == request.ProjectId, cancellationToken)
                    ?? throw new KeyNotFoundException("Task not found or does not belong to the specified project");
                taskName = task.Name;
            }

            var timeEntry = new TimeEntry
            {
                UserId = userId,
                ProjectId = request.ProjectId,
                OrganizationId = orgId,
                Date = request.Date,
                Hours = request.Hours,
                Description = request.Description,
                BillableRate = billableRate,
                IsBillable = request.IsBillable,
                TaskId = request.TaskId
            };

            db.TimeEntries.Add(timeEntry);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(timeEntry.Id, timeEntry.ProjectId, timeEntry.Date, timeEntry.Hours,
                timeEntry.Description, timeEntry.IsBillable, timeEntry.BillableRate, timeEntry.TaskId, taskName);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/time-entries", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/time-entries/{response.Id}", response);
            })
            .WithName("CreateTimeEntry")
            .WithSummary("Create a new time entry")
            .WithDescription("Creates a new time entry for the authenticated user on a project within the current organization. If no billable rate is provided, the project's default billable rate is used. Requires the X-Organization-Id header.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("TimeEntries")
            .RequireAuthorization();
        }
    }
}
