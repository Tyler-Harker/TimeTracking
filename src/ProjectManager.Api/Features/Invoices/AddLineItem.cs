using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Invoices;

public static class AddLineItem
{
    public record Command(
        Guid InvoiceId,
        string Description,
        decimal Quantity,
        decimal UnitPrice) : IRequest<Response>;

    public record Response(Guid Id, string Description, decimal Quantity, decimal UnitPrice, decimal Amount);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.InvoiceId).NotEmpty();
            RuleFor(x => x.Description).NotEmpty().MaximumLength(500);
            RuleFor(x => x.Quantity).GreaterThan(0);
            RuleFor(x => x.UnitPrice).GreaterThanOrEqualTo(0);
        }
    }

    public class Handler(AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var invoice = await db.Invoices
                .Include(i => i.LineItems)
                .FirstOrDefaultAsync(i => i.Id == request.InvoiceId, cancellationToken)
                ?? throw new KeyNotFoundException("Invoice not found");

            if (invoice.Status != InvoiceStatus.Draft)
                throw new InvalidOperationException("Can only add line items to draft invoices");

            var amount = request.Quantity * request.UnitPrice;

            var lineItem = new InvoiceLineItem
            {
                InvoiceId = invoice.Id,
                Description = request.Description,
                Quantity = request.Quantity,
                UnitPrice = request.UnitPrice,
                Amount = amount
            };

            invoice.LineItems.Add(lineItem);

            // Recalculate totals
            var subtotal = invoice.LineItems.Sum(li => li.Amount);
            invoice.TaxAmount = subtotal * (invoice.TaxRate / 100m);
            invoice.TotalAmount = subtotal + invoice.TaxAmount;

            await db.SaveChangesAsync(cancellationToken);

            return new Response(lineItem.Id, lineItem.Description, lineItem.Quantity, lineItem.UnitPrice, lineItem.Amount);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/invoices/{invoiceId:guid}/line-items", async (Guid invoiceId, AddLineItemRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(invoiceId, body.Description, body.Quantity, body.UnitPrice));
                return Results.Created($"/api/invoices/{invoiceId}", response);
            })
            .WithName("AddLineItem")
            .WithSummary("Add a line item to an invoice")
            .WithDescription("Adds a new line item to a draft invoice and recalculates the invoice totals including tax. Only invoices in Draft status can have line items added. Requires the X-Organization-Id header.")
            .Accepts<AddLineItemRequest>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Invoices")
            .RequireAuthorization();
        }
    }

    public record AddLineItemRequest(string Description, decimal Quantity, decimal UnitPrice);
}
