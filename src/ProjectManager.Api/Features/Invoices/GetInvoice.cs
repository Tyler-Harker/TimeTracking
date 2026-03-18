using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Invoices;

public static class GetInvoice
{
    public record Query(Guid Id) : IRequest<Response>;

    public record Response(
        Guid Id,
        string InvoiceNumber,
        string Status,
        Guid? ClientId,
        Guid? ProjectId,
        decimal TotalAmount,
        decimal TaxRate,
        decimal TaxAmount,
        string? Notes,
        DateOnly IssuedDate,
        DateOnly DueDate,
        DateOnly? PaidDate,
        IEnumerable<LineItemInfo> LineItems);

    public record LineItemInfo(Guid Id, string Description, decimal Quantity, decimal UnitPrice, decimal Amount, string? ProjectName);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var invoice = await db.Invoices
                .Include(i => i.LineItems)
                    .ThenInclude(li => li.TimeEntries)
                        .ThenInclude(te => te.Project)
                .FirstOrDefaultAsync(i => i.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Invoice not found");

            return new Response(
                invoice.Id, invoice.InvoiceNumber, invoice.Status.ToString(),
                invoice.ClientId, invoice.ProjectId,
                invoice.TotalAmount, invoice.TaxRate, invoice.TaxAmount, invoice.Notes,
                invoice.IssuedDate, invoice.DueDate, invoice.PaidDate,
                invoice.LineItems.Select(li => new LineItemInfo(
                    li.Id, li.Description, li.Quantity, li.UnitPrice, li.Amount,
                    li.TimeEntries.FirstOrDefault()?.Project?.Name)));
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/invoices/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetInvoice")
            .WithSummary("Get an invoice by ID")
            .WithDescription("Retrieves an invoice by its unique identifier, including all associated line items. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Invoices")
            .RequireAuthorization();
        }
    }
}
