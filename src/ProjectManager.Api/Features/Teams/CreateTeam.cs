using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Teams;

public static class CreateTeam
{
    public record Command(Guid ProjectId, string Name, string? Description) : IRequest<Response>;
    public record Response(Guid Id, Guid ProjectId, string Name, string? Description);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.ProjectId).NotEmpty();
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(1000);
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            // Verify project belongs to this org
            var projectExists = await db.OrganizationClientProjects
                .AnyAsync(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == request.ProjectId, cancellationToken);
            if (!projectExists)
                throw new KeyNotFoundException("Project not found in this organization");

            // Check unique name per project
            var nameExists = await db.Teams
                .AnyAsync(t => t.ProjectId == request.ProjectId && t.Name == request.Name, cancellationToken);
            if (nameExists)
                throw new InvalidOperationException($"A team named '{request.Name}' already exists in this project");

            var team = new Team
            {
                ProjectId = request.ProjectId,
                Name = request.Name,
                Description = request.Description
            };

            db.Teams.Add(team);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(team.Id, team.ProjectId, team.Name, team.Description);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/teams", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/teams/{response.Id}", response);
            })
            .WithName("CreateTeam")
            .WithSummary("Create a new team")
            .WithDescription("Creates a new team for a project within the current organization. Team names must be unique within a project. Requires the X-Organization-Id header.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Teams")
            .RequireAuthorization();
        }
    }
}
