using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Invoices;

public static class ListInvoices
{
    public record Query(Guid? ClientId, InvoiceStatus? Status, int Page = 1, int PageSize = 20) : IRequest<Response>;
    public record Response(IEnumerable<InvoiceItem> Items, int TotalCount, int Page, int PageSize);

    public record InvoiceItem(
        Guid Id,
        string InvoiceNumber,
        string Status,
        decimal TotalAmount,
        DateOnly IssuedDate,
        DateOnly DueDate);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var query = db.Invoices.AsQueryable();

            if (request.ClientId.HasValue)
                query = query.Where(i => i.ClientId == request.ClientId.Value);

            if (request.Status.HasValue)
                query = query.Where(i => i.Status == request.Status.Value);

            var totalCount = await query.CountAsync(cancellationToken);

            var items = await query
                .OrderByDescending(i => i.IssuedDate)
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .Select(i => new InvoiceItem(
                    i.Id, i.InvoiceNumber, i.Status.ToString(),
                    i.TotalAmount, i.IssuedDate, i.DueDate))
                .ToListAsync(cancellationToken);

            return new Response(items, totalCount, request.Page, request.PageSize);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/invoices", async (Guid? clientId, InvoiceStatus? status, int? page, int? pageSize, ISender sender) =>
            {
                var response = await sender.Send(new Query(clientId, status, page ?? 1, pageSize ?? 20));
                return Results.Ok(response);
            })
            .WithName("ListInvoices")
            .WithSummary("List invoices")
            .WithDescription("Lists invoices with pagination and optional filters for client and invoice status within the current organization. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .WithTags("Invoices")
            .RequireAuthorization();
        }
    }
}
