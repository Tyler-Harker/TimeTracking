using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Projects;

public static class CreateProject
{
    public record Command(
        Guid ClientId,
        string Name,
        string? Description,
        decimal? BudgetAmount,
        decimal? DefaultBillableRate,
        DateOnly? StartDate,
        DateOnly? EndDate) : IRequest<Response>;

    public record Response(Guid Id, string Name, string? Description, string Status, decimal? BudgetAmount, decimal? DefaultBillableRate, decimal? InheritedBillableRate);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.ClientId).NotEmpty();
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(2000);
            RuleFor(x => x.BudgetAmount).GreaterThanOrEqualTo(0).When(x => x.BudgetAmount.HasValue);
            RuleFor(x => x.DefaultBillableRate).GreaterThanOrEqualTo(0).When(x => x.DefaultBillableRate.HasValue);
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            // Verify client belongs to this org and fetch inherited rate
            var orgClient = await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgId && oc.ClientId == request.ClientId)
                .Select(oc => new { OrgRate = oc.Organization.DefaultBillableRate, ClientRate = oc.Client.DefaultBillableRate })
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Client not found in this organization");
            var inheritedRate = orgClient.ClientRate ?? orgClient.OrgRate;

            var project = new Project
            {
                Name = request.Name,
                Description = request.Description,
                BudgetAmount = request.BudgetAmount,
                DefaultBillableRate = request.DefaultBillableRate,
                StartDate = request.StartDate,
                EndDate = request.EndDate
            };

            db.Projects.Add(project);

            db.OrganizationClientProjects.Add(new OrganizationClientProject
            {
                OrganizationId = orgId,
                ClientId = request.ClientId,
                ProjectId = project.Id
            });

            await db.SaveChangesAsync(cancellationToken);

            return new Response(project.Id, project.Name, project.Description, project.Status.ToString(),
                project.BudgetAmount, project.DefaultBillableRate, inheritedRate);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/projects", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/projects/{response.Id}", response);
            })
            .WithName("CreateProject")
            .WithSummary("Create a new project")
            .WithDescription("Creates a new project under a specified client in the current organization. The client must already exist in the organization. Requires the X-Organization-Id header.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Projects")
            .RequireAuthorization();
        }
    }
}
