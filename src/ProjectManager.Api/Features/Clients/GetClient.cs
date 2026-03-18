using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients;

public static class GetClient
{
    public record Query(Guid Id) : IRequest<Response>;

    public record ContactDto(Guid Id, string Name, string? Email, string? Phone, bool IsStakeHolder, bool IsInvoicing, DateTime CreatedAt);

    public record Response(
        Guid Id,
        string Name,
        string? Address,
        string? Website,
        bool IsActive,
        DateTime CreatedAt,
        decimal? DefaultBillableRate,
        decimal? InheritedBillableRate,
        IEnumerable<ContactDto> Contacts);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var result = await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgService.OrganizationId!.Value && oc.ClientId == request.Id)
                .Select(oc => new Response(
                    oc.Client.Id, oc.Client.Name,
                    oc.Client.Address, oc.Client.Website, oc.Client.IsActive, oc.Client.CreatedAt,
                    oc.Client.DefaultBillableRate, oc.Organization.DefaultBillableRate,
                    oc.Client.Contacts.Select(c => new ContactDto(c.Id, c.Name, c.Email, c.Phone, c.IsStakeHolder, c.IsInvoicing, c.CreatedAt))))
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Client not found");

            return result;
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/clients/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetClient")
            .WithSummary("Get a client by ID")
            .WithDescription("Retrieves a client by ID within the current organization. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Clients")
            .RequireAuthorization();
        }
    }
}
