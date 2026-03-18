using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.TimeEntries;

public static class UpdateTimeEntry
{
    public record Command(
        Guid Id,
        DateOnly Date,
        decimal Hours,
        string? Description,
        decimal? BillableRate,
        bool IsBillable,
        Guid? TaskId) : IRequest<Response>;

    public record Response(Guid Id, DateOnly Date, decimal Hours, string? Description, decimal? BillableRate, bool IsBillable, decimal? InheritedBillableRate, Guid? TaskId, string? TaskName);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Date).NotEmpty();
            RuleFor(x => x.Hours).GreaterThan(0).LessThanOrEqualTo(24);
            RuleFor(x => x.Description).MaximumLength(2000);
            RuleFor(x => x.BillableRate).GreaterThanOrEqualTo(0).When(x => x.BillableRate.HasValue);
        }
    }

    public class Handler(AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var entry = await db.TimeEntries
                .FirstOrDefaultAsync(te => te.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Time entry not found");

            if (entry.IsInvoiced)
                throw new InvalidOperationException("Cannot modify an invoiced time entry");

            entry.Date = request.Date;
            entry.Hours = request.Hours;
            entry.Description = request.Description;
            entry.BillableRate = request.BillableRate;
            entry.IsBillable = request.IsBillable;
            entry.TaskId = request.TaskId;

            await db.SaveChangesAsync(cancellationToken);

            var inheritedRate = await db.OrganizationClientProjects
                .Where(ocp => ocp.ProjectId == entry.ProjectId)
                .Select(ocp => ocp.Project.DefaultBillableRate
                    ?? ocp.OrganizationClient.Client.DefaultBillableRate
                    ?? ocp.OrganizationClient.Organization.DefaultBillableRate)
                .FirstOrDefaultAsync(cancellationToken);

            string? taskName = null;
            if (entry.TaskId.HasValue)
            {
                var task = await db.ProjectTasks.FindAsync([entry.TaskId.Value], cancellationToken);
                taskName = task?.Name;
            }

            return new Response(entry.Id, entry.Date, entry.Hours, entry.Description, entry.BillableRate, entry.IsBillable, inheritedRate, entry.TaskId, taskName);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/time-entries/{id:guid}", async (Guid id, UpdateRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(id, body.Date, body.Hours, body.Description, body.BillableRate, body.IsBillable, body.TaskId));
                return Results.Ok(response);
            })
            .WithName("UpdateTimeEntry")
            .WithSummary("Update a time entry")
            .WithDescription("Updates an existing time entry by ID. Invoiced time entries cannot be modified. Requires the X-Organization-Id header.")
            .Accepts<UpdateRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("TimeEntries")
            .RequireAuthorization();
        }
    }

    public record UpdateRequest(DateOnly Date, decimal Hours, string? Description, decimal? BillableRate, bool IsBillable, Guid? TaskId);
}
