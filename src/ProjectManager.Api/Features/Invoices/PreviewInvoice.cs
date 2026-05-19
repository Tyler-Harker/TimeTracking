using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Invoices;

public static class PreviewInvoice
{
    public record Query(Guid? ClientId, Guid? ProjectId) : IRequest<Response>;

    public record Response(
        int EntryCount,
        IReadOnlyList<LineItem> LineItems,
        decimal Subtotal);

    public record LineItem(
        Guid ProjectId,
        string ProjectName,
        string Description,
        decimal Quantity,
        decimal UnitPrice,
        decimal Amount);

    public class Validator : AbstractValidator<Query>
    {
        public Validator()
        {
            RuleFor(x => x).Must(x => x.ClientId.HasValue || x.ProjectId.HasValue)
                .WithMessage("Either ClientId or ProjectId must be provided");
        }
    }

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var query = db.TimeEntries.Where(te => te.IsBillable && !te.IsInvoiced);

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

            var lines = InvoiceLineItemBuilder.Build(timeEntries);
            var items = lines
                .Select(l => new LineItem(l.ProjectId, l.ProjectName, l.Description, l.Quantity, l.UnitPrice, l.Amount))
                .ToList();
            var subtotal = items.Sum(i => i.Amount);

            return new Response(timeEntries.Count, items, subtotal);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/invoices/preview", async (Query body, ISender sender) =>
            {
                var response = await sender.Send(body);
                return Results.Ok(response);
            })
            .WithName("PreviewInvoice")
            .WithSummary("Preview the line items that GenerateInvoice would produce")
            .WithDescription("Returns the line items and subtotal that GenerateInvoice would create for the given filters, without persisting anything. Requires either a ClientId or ProjectId. Requires the X-Organization-Id header.")
            .Accepts<Query>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Invoices")
            .RequireAuthorization();
        }
    }
}
