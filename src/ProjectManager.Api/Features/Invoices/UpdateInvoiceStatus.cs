using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Invoices;

public static class UpdateInvoiceStatus
{
    public record Command(Guid Id, InvoiceStatus NewStatus) : IRequest<Response>;
    public record Response(Guid Id, string InvoiceNumber, string Status, DateOnly? PaidDate);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.NewStatus).IsInEnum();
        }
    }

    private static readonly Dictionary<InvoiceStatus, HashSet<InvoiceStatus>> ValidTransitions = new()
    {
        [InvoiceStatus.Draft] = [InvoiceStatus.Sent, InvoiceStatus.Cancelled],
        [InvoiceStatus.Sent] = [InvoiceStatus.Paid, InvoiceStatus.Overdue, InvoiceStatus.Cancelled],
        [InvoiceStatus.Overdue] = [InvoiceStatus.Paid, InvoiceStatus.Cancelled],
        [InvoiceStatus.Paid] = [],
        [InvoiceStatus.Cancelled] = []
    };

    public class Handler(AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var invoice = await db.Invoices
                .FirstOrDefaultAsync(i => i.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Invoice not found");

            if (!ValidTransitions.TryGetValue(invoice.Status, out var allowed) || !allowed.Contains(request.NewStatus))
                throw new InvalidOperationException(
                    $"Cannot transition from {invoice.Status} to {request.NewStatus}");

            invoice.Status = request.NewStatus;

            if (request.NewStatus == InvoiceStatus.Paid)
                invoice.PaidDate = DateOnly.FromDateTime(DateTime.UtcNow);

            if (request.NewStatus == InvoiceStatus.Cancelled)
            {
                var timeEntries = await db.TimeEntries
                    .Where(te => te.InvoiceLineItem != null && te.InvoiceLineItem.InvoiceId == request.Id)
                    .ToListAsync(cancellationToken);

                foreach (var entry in timeEntries)
                {
                    entry.IsInvoiced = false;
                    entry.InvoiceLineItemId = null;
                }
            }

            await db.SaveChangesAsync(cancellationToken);

            return new Response(invoice.Id, invoice.InvoiceNumber, invoice.Status.ToString(), invoice.PaidDate);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPatch("/api/invoices/{id:guid}/status", async (Guid id, StatusRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(id, body.Status));
                return Results.Ok(response);
            })
            .WithName("UpdateInvoiceStatus")
            .WithSummary("Update an invoice's status")
            .WithDescription("Transitions an invoice to a new status following valid state transitions: Draft to Sent or Cancelled, Sent to Paid, Overdue, or Cancelled, Overdue to Paid or Cancelled. Paid and Cancelled are terminal states. Requires the X-Organization-Id header.")
            .Accepts<StatusRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Invoices")
            .RequireAuthorization();
        }
    }

    public record StatusRequest(InvoiceStatus Status);
}
