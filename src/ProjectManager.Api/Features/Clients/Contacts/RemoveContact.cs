using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients.Contacts;

public static class RemoveContact
{
    public record Command(Guid ClientId, Guid ContactId) : IRequest;

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var clientExists = await db.OrganizationClients
                .AnyAsync(oc => oc.OrganizationId == orgId && oc.ClientId == request.ClientId, cancellationToken);
            if (!clientExists)
                throw new KeyNotFoundException("Client not found");

            var contact = await db.ClientContacts
                .FirstOrDefaultAsync(cc => cc.ClientId == request.ClientId && cc.Id == request.ContactId, cancellationToken)
                ?? throw new KeyNotFoundException("Contact not found");

            db.ClientContacts.Remove(contact);
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/clients/{clientId:guid}/contacts/{contactId:guid}", async (Guid clientId, Guid contactId, ISender sender) =>
            {
                await sender.Send(new Command(clientId, contactId));
                return Results.NoContent();
            })
            .WithName("RemoveClientContact")
            .WithSummary("Remove a client contact")
            .WithDescription("Removes a contact from a client within the current organization. Requires the X-Organization-Id header.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Client Contacts")
            .RequireAuthorization();
        }
    }
}
