using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Projects;

public static class UpdateProject
{
    public record Command(
        Guid Id,
        string Name,
        string? Description,
        ProjectStatus Status,
        decimal? BudgetAmount,
        decimal? DefaultBillableRate,
        DateOnly? StartDate,
        DateOnly? EndDate) : IRequest<Response>;

    public record Response(Guid Id, string Name, string? Description, string Status, decimal? BudgetAmount, decimal? DefaultBillableRate, decimal? InheritedBillableRate);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(2000);
            RuleFor(x => x.Status).IsInEnum();
            RuleFor(x => x.BudgetAmount).GreaterThanOrEqualTo(0).When(x => x.BudgetAmount.HasValue);
            RuleFor(x => x.DefaultBillableRate).GreaterThanOrEqualTo(0).When(x => x.DefaultBillableRate.HasValue);
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var project = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.Id)
                .Select(ocp => ocp.Project)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Project not found");

            project.Name = request.Name;
            project.Description = request.Description;
            project.Status = request.Status;
            project.BudgetAmount = request.BudgetAmount;
            project.DefaultBillableRate = request.DefaultBillableRate;
            project.StartDate = request.StartDate;
            project.EndDate = request.EndDate;

            await db.SaveChangesAsync(cancellationToken);

            var inheritedRate = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.Id)
                .Select(ocp => ocp.OrganizationClient.Client.DefaultBillableRate ?? ocp.OrganizationClient.Organization.DefaultBillableRate)
                .FirstOrDefaultAsync(cancellationToken);

            return new Response(project.Id, project.Name, project.Description, project.Status.ToString(),
                project.BudgetAmount, project.DefaultBillableRate, inheritedRate);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/projects/{id:guid}", async (Guid id, UpdateRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(id, body.Name, body.Description, body.Status,
                    body.BudgetAmount, body.DefaultBillableRate, body.StartDate, body.EndDate));
                return Results.Ok(response);
            })
            .WithName("UpdateProject")
            .WithSummary("Update a project")
            .WithDescription("Updates a project's details including name, description, status, budget, billable rate, and dates. The project must belong to the current organization. Requires the X-Organization-Id header.")
            .Accepts<UpdateRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Projects")
            .RequireAuthorization();
        }
    }

    public record UpdateRequest(
        string Name,
        string? Description,
        ProjectStatus Status,
        decimal? BudgetAmount,
        decimal? DefaultBillableRate,
        DateOnly? StartDate,
        DateOnly? EndDate);
}
