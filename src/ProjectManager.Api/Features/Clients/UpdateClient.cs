using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients;

public static class UpdateClient
{
    public record Command(
        Guid Id,
        string Name,
        string? Address,
        string? Website,
        decimal? DefaultBillableRate) : IRequest<Response>;

    public record ContactDto(Guid Id, string Name, string? Email, string? Phone, bool IsStakeHolder, bool IsInvoicing, DateTime CreatedAt);

    public record Response(Guid Id, string Name, string? Address, string? Website, bool IsActive, DateTime CreatedAt, decimal? DefaultBillableRate, decimal? InheritedBillableRate, IEnumerable<ContactDto> Contacts);

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
            var oc = await db.OrganizationClients
                .Include(oc => oc.Client).ThenInclude(c => c.Contacts)
                .Where(oc => oc.OrganizationId == orgService.OrganizationId!.Value && oc.ClientId == request.Id)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Client not found");

            var client = oc.Client;
            client.Name = request.Name;
            client.Address = request.Address;
            client.Website = request.Website;
            client.DefaultBillableRate = request.DefaultBillableRate;

            await db.SaveChangesAsync(cancellationToken);

            var orgRate = await db.Organizations
                .Where(o => o.Id == oc.OrganizationId)
                .Select(o => o.DefaultBillableRate)
                .FirstAsync(cancellationToken);

            return new Response(client.Id, client.Name, client.Address, client.Website, client.IsActive, client.CreatedAt, client.DefaultBillableRate, orgRate,
                client.Contacts.Select(c => new ContactDto(c.Id, c.Name, c.Email, c.Phone, c.IsStakeHolder, c.IsInvoicing, c.CreatedAt)));
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/clients/{id:guid}", async (Guid id, UpdateRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(id, body.Name, body.Address, body.Website, body.DefaultBillableRate));
                return Results.Ok(response);
            })
            .WithName("UpdateClient")
            .WithSummary("Update a client")
            .WithDescription("Updates a client's details within the current organization. Requires the X-Organization-Id header.")
            .Accepts<UpdateRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Clients")
            .RequireAuthorization();
        }
    }

    public record UpdateRequest(string Name, string? Address, string? Website, decimal? DefaultBillableRate);
}
