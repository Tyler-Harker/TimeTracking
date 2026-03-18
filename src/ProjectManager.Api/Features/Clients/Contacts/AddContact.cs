using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients.Contacts;

public static class AddContact
{
    public record Command(
        Guid ClientId,
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

            var contact = new ClientContact
            {
                ClientId = request.ClientId,
                Name = request.Name,
                Email = request.Email,
                Phone = request.Phone,
                IsStakeHolder = request.IsStakeHolder,
                IsInvoicing = request.IsInvoicing
            };

            db.ClientContacts.Add(contact);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(contact.Id, contact.Name, contact.Email, contact.Phone,
                contact.IsStakeHolder, contact.IsInvoicing, contact.CreatedAt);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/clients/{clientId:guid}/contacts", async (Guid clientId, AddContactRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(clientId, body.Name, body.Email, body.Phone, body.IsStakeHolder, body.IsInvoicing));
                return Results.Created($"/api/clients/{clientId}/contacts/{response.Id}", response);
            })
            .WithName("AddClientContact")
            .WithSummary("Add a contact to a client")
            .WithDescription("Adds a new contact to a client within the current organization. Requires the X-Organization-Id header.")
            .Accepts<AddContactRequest>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Client Contacts")
            .RequireAuthorization();
        }
    }

    public record AddContactRequest(string Name, string? Email, string? Phone, bool IsStakeHolder, bool IsInvoicing);
}
