using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Invoices;

public static class GenerateInvoice
{
    public record Command(
        Guid? ClientId,
        Guid? ProjectId,
        decimal TaxRate,
        string? Notes,
        DateOnly DueDate) : IRequest<Response>;

    public record Response(
        Guid Id,
        string InvoiceNumber,
        string Status,
        decimal TotalAmount,
        decimal TaxRate,
        decimal TaxAmount,
        int LineItemCount);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x).Must(x => x.ClientId.HasValue || x.ProjectId.HasValue)
                .WithMessage("Either ClientId or ProjectId must be provided");
            RuleFor(x => x.TaxRate).GreaterThanOrEqualTo(0).LessThanOrEqualTo(100);
            RuleFor(x => x.DueDate).NotEmpty();
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            // Find unbilled time entries
            var query = db.TimeEntries
                .Where(te => te.IsBillable && !te.IsInvoiced);

            if (request.ProjectId.HasValue)
                query = query.Where(te => te.ProjectId == request.ProjectId.Value);

            if (request.ClientId.HasValue)
            {
                var projectIds = await db.OrganizationClientProjects
                    .Where(ocp => ocp.OrganizationId == orgId && ocp.ClientId == request.ClientId.Value)
                    .Select(ocp => ocp.ProjectId)
                    .ToListAsync(cancellationToken);

                query = query.Where(te => projectIds.Contains(te.ProjectId));
            }

            var timeEntries = await query
                .Include(te => te.Project)
                .ToListAsync(cancellationToken);

            if (timeEntries.Count == 0)
                throw new InvalidOperationException("No unbilled time entries found");

            // Generate invoice number
            var count = await db.Invoices.IgnoreQueryFilters()
                .CountAsync(i => i.OrganizationId == orgId, cancellationToken);
            var invoiceNumber = $"INV-{count + 1:D5}";

            var invoice = new Invoice
            {
                OrganizationId = orgId,
                ClientId = request.ClientId,
                ProjectId = request.ProjectId,
                InvoiceNumber = invoiceNumber,
                TaxRate = request.TaxRate,
                Notes = request.Notes,
                IssuedDate = DateOnly.FromDateTime(DateTime.UtcNow),
                DueDate = request.DueDate
            };

            // Group time entries by project for line items
            var grouped = timeEntries.GroupBy(te => te.ProjectId);
            var lineItems = new List<InvoiceLineItem>();

            foreach (var group in grouped)
            {
                var totalHours = group.Sum(te => te.Hours);
                var avgRate = group.Average(te => te.BillableRate ?? 0);
                var amount = totalHours * avgRate;
                var projectName = group.First().Project.Name;

                var lineItem = new InvoiceLineItem
                {
                    InvoiceId = invoice.Id,
                    Description = $"{projectName} ({group.Count()} entries, {totalHours:F2} hours)",
                    Quantity = totalHours,
                    UnitPrice = avgRate,
                    Amount = amount
                };

                lineItems.Add(lineItem);

                foreach (var entry in group)
                {
                    entry.IsInvoiced = true;
                    entry.InvoiceLineItem = lineItem;
                }
            }

            var subtotal = lineItems.Sum(li => li.Amount);
            invoice.TaxAmount = subtotal * (request.TaxRate / 100m);
            invoice.TotalAmount = subtotal + invoice.TaxAmount;
            invoice.LineItems = lineItems;

            db.Invoices.Add(invoice);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(invoice.Id, invoice.InvoiceNumber, invoice.Status.ToString(),
                invoice.TotalAmount, invoice.TaxRate, invoice.TaxAmount, lineItems.Count);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/invoices/generate", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/invoices/{response.Id}", response);
            })
            .WithName("GenerateInvoice")
            .WithSummary("Generate an invoice from unbilled time entries")
            .WithDescription("Generates a new invoice from unbilled time entries, grouped by project. Requires either a ClientId or ProjectId filter. Line items are automatically created from time entry groups and totals are calculated with the specified tax rate. Requires the X-Organization-Id header.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Invoices")
            .RequireAuthorization();
        }
    }
}
