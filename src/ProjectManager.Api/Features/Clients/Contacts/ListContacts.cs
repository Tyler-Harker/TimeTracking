using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients.Contacts;

public static class ListContacts
{
    public record Query(Guid ClientId) : IRequest<IEnumerable<Response>>;

    public record Response(
        Guid Id,
        string Name,
        string? Email,
        string? Phone,
        bool IsStakeHolder,
        bool IsInvoicing,
        DateTime CreatedAt);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, IEnumerable<Response>>
    {
        public async Task<IEnumerable<Response>> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var clientExists = await db.OrganizationClients
                .AnyAsync(oc => oc.OrganizationId == orgId && oc.ClientId == request.ClientId, cancellationToken);
            if (!clientExists)
                throw new KeyNotFoundException("Client not found");

            return await db.ClientContacts
                .Where(cc => cc.ClientId == request.ClientId)
                .Select(cc => new Response(cc.Id, cc.Name, cc.Email, cc.Phone, cc.IsStakeHolder, cc.IsInvoicing, cc.CreatedAt))
                .ToListAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/clients/{clientId:guid}/contacts", async (Guid clientId, ISender sender) =>
            {
                var response = await sender.Send(new Query(clientId));
                return Results.Ok(response);
            })
            .WithName("ListClientContacts")
            .WithSummary("List contacts for a client")
            .WithDescription("Lists all contacts for a client within the current organization. Requires the X-Organization-Id header.")
            .Produces<IEnumerable<Response>>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Client Contacts")
            .RequireAuthorization();
        }
    }
}
