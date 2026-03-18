using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients;

public static class CreateClient
{
    public record Command(
        string Name,
        string? Address,
        string? Website,
        decimal? DefaultBillableRate) : IRequest<Response>;

    public record Response(Guid Id, string Name, string? Address, string? Website, bool IsActive, DateTime CreatedAt, decimal? DefaultBillableRate, decimal? InheritedBillableRate);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Address).MaximumLength(500);
            RuleFor(x => x.Website).MaximumLength(500);
            RuleFor(x => x.DefaultBillableRate).GreaterThanOrEqualTo(0).When(x => x.DefaultBillableRate.HasValue);
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var client = new Client
            {
                Name = request.Name,
                Address = request.Address,
                Website = request.Website,
                DefaultBillableRate = request.DefaultBillableRate
            };

            db.Clients.Add(client);

            var orgId = orgService.OrganizationId!.Value;
            db.OrganizationClients.Add(new OrganizationClient
            {
                OrganizationId = orgId,
                ClientId = client.Id
            });

            await db.SaveChangesAsync(cancellationToken);

            var orgRate = await db.Organizations
                .Where(o => o.Id == orgId)
                .Select(o => o.DefaultBillableRate)
                .FirstAsync(cancellationToken);

            return new Response(client.Id, client.Name, client.Address, client.Website, client.IsActive, client.CreatedAt, client.DefaultBillableRate, orgRate);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/clients", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/clients/{response.Id}", response);
            })
            .WithName("CreateClient")
            .WithSummary("Create a new client")
            .WithDescription("Creates a new client and associates it with the current organization. Requires the X-Organization-Id header.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Clients")
            .RequireAuthorization();
        }
    }
}
