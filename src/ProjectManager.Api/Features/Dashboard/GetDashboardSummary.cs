using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Dashboard;

public static class GetDashboardSummary
{
    public record Query : IRequest<Response>;

    public record Response(
        int ClientCount,
        int ProjectCount,
        int ActiveProjectCount,
        decimal TotalHoursYtd,
        decimal TotalInvoicedYtd,
        decimal TotalUninvoicedHours,
        decimal TotalUninvoicedAmount);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;
            var yearStart = new DateOnly(DateTime.UtcNow.Year, 1, 1);

            var clientCount = await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgId)
                .CountAsync(cancellationToken);

            var projectCounts = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId)
                .GroupBy(_ => 1)
                .Select(g => new
                {
                    Total = g.Count(),
                    Active = g.Count(ocp => ocp.Project.Status == ProjectStatus.Active)
                })
                .FirstOrDefaultAsync(cancellationToken);

            var totalHoursYtd = await db.TimeEntries
                .Where(te => te.OrganizationId == orgId && te.Date >= yearStart)
                .SumAsync(te => (decimal?)te.Hours, cancellationToken) ?? 0;

            var totalInvoicedYtd = await db.Invoices
                .Where(i => i.OrganizationId == orgId && i.IssuedDate >= yearStart
                    && i.Status != InvoiceStatus.Cancelled)
                .SumAsync(i => (decimal?)i.TotalAmount, cancellationToken) ?? 0;

            var uninvoiced = await db.TimeEntries
                .Where(te => te.OrganizationId == orgId && te.IsBillable && !te.IsInvoiced)
                .GroupBy(_ => 1)
                .Select(g => new
                {
                    Hours = g.Sum(te => (decimal?)te.Hours) ?? 0,
                    Amount = g.Sum(te => (decimal?)(te.Hours * (te.BillableRate ?? 0))) ?? 0
                })
                .FirstOrDefaultAsync(cancellationToken);

            return new Response(
                clientCount,
                projectCounts?.Total ?? 0,
                projectCounts?.Active ?? 0,
                totalHoursYtd,
                totalInvoicedYtd,
                uninvoiced?.Hours ?? 0,
                uninvoiced?.Amount ?? 0);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/dashboard/summary", async (ISender sender) =>
            {
                var response = await sender.Send(new Query());
                return Results.Ok(response);
            })
            .WithName("GetDashboardSummary")
            .WithSummary("Get dashboard summary")
            .WithDescription("Returns aggregated dashboard metrics for the current organization including YTD hours, YTD invoiced, and uninvoiced totals. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .WithTags("Dashboard")
            .RequireAuthorization();
        }
    }
}
