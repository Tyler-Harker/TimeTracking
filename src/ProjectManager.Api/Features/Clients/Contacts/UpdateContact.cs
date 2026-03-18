using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients.Contacts;

public static class UpdateContact
{
    public record Command(
        Guid ClientId,
        Guid ContactId,
        string Name,
        string? Email,
        string? Phone,
        bool IsStakeHolder,
        bool IsInvoicing) : IRequest<Response>;

    public record Response(
        Guid Id,
        string Name,
        string? Email,
        string? Phone,
        bool IsStakeHolder,
        bool IsInvoicing,
        DateTime CreatedAt);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Email).MaximumLength(200).EmailAddress().When(x => !string.IsNullOrEmpty(x.Email));
            RuleFor(x => x.Phone).MaximumLength(50);
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var clientExists = await db.OrganizationClients
                .AnyAsync(oc => oc.OrganizationId == orgId && oc.ClientId == request.ClientId, cancellationToken);
            if (!clientExists)
                throw new KeyNotFoundException("Client not found");

            var contact = await db.ClientContacts
                .FirstOrDefaultAsync(cc => cc.ClientId == request.ClientId && cc.Id == request.ContactId, cancellationToken)
                ?? throw new KeyNotFoundException("Contact not found");

            contact.Name = request.Name;
            contact.Email = request.Email;
            contact.Phone = request.Phone;
            contact.IsStakeHolder = request.IsStakeHolder;
            contact.IsInvoicing = request.IsInvoicing;

            await db.SaveChangesAsync(cancellationToken);

            return new Response(contact.Id, contact.Name, contact.Email, contact.Phone,
                contact.IsStakeHolder, contact.IsInvoicing, contact.CreatedAt);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/clients/{clientId:guid}/contacts/{contactId:guid}", async (Guid clientId, Guid contactId, UpdateContactRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(clientId, contactId, body.Name, body.Email, body.Phone, body.IsStakeHolder, body.IsInvoicing));
                return Results.Ok(response);
            })
            .WithName("UpdateClientContact")
            .WithSummary("Update a client contact")
            .WithDescription("Updates a contact for a client within the current organization. Requires the X-Organization-Id header.")
            .Accepts<UpdateContactRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Client Contacts")
            .RequireAuthorization();
        }
    }

    public record UpdateContactRequest(string Name, string? Email, string? Phone, bool IsStakeHolder, bool IsInvoicing);
}
