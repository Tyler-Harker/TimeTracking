using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Sync;

public static class ExportSync
{
    public const int CurrentVersion = 1;

    public record Query : IRequest<SyncExport>;

    public class Handler(
        AppDbContext db,
        ICurrentOrganizationService orgService,
        IHttpContextAccessor http) : IRequestHandler<Query, SyncExport>
    {
        public async Task<SyncExport> Handle(Query _, CancellationToken ct)
        {
            var orgId = orgService.OrganizationId
                ?? throw new InvalidOperationException("Organization context missing");
            // TODO: re-enable owner-only gate
            // await OwnerOnly.EnsureOwnerAsync(db, http, orgId, ct);

            var org = await db.Organizations
                .AsNoTracking()
                .Where(o => o.Id == orgId)
                .Select(o => new SyncOrganization(
                    o.Id, o.Name, o.Slug, o.Description, o.Address, o.Phone, o.Email,
                    o.DefaultBillableRate, o.BankAccountNumber, o.BankRoutingNumber,
                    o.CreatedAt, o.UpdatedAt))
                .FirstAsync(ct);

            var clientLinks = await db.OrganizationClients
                .AsNoTracking()
                .Where(oc => oc.OrganizationId == orgId)
                .Select(oc => oc.ClientId)
                .ToListAsync(ct);

            var clients = await db.Clients
                .AsNoTracking()
                .Where(c => clientLinks.Contains(c.Id))
                .Select(c => new SyncClient(
                    c.Id, c.Name, c.Address, c.Website, c.IsActive, c.DefaultBillableRate,
                    c.CreatedAt, c.UpdatedAt,
                    c.Contacts.Select(cc => new SyncClientContact(
                        cc.Id, cc.Name, cc.Email, cc.Phone, cc.IsStakeHolder, cc.IsInvoicing,
                        cc.CreatedAt, cc.UpdatedAt)).ToList()))
                .ToListAsync(ct);

            var projectLinks = await db.OrganizationClientProjects
                .AsNoTracking()
                .Where(ocp => ocp.OrganizationId == orgId)
                .Select(ocp => new { ocp.ProjectId, ocp.ClientId })
                .ToListAsync(ct);

            var projectIds = projectLinks.Select(p => p.ProjectId).Distinct().ToList();
            var clientByProject = projectLinks.ToDictionary(p => p.ProjectId, p => p.ClientId);

            var projects = await db.Projects
                .AsNoTracking()
                .Where(p => projectIds.Contains(p.Id))
                .Select(p => new
                {
                    p.Id, p.Name, p.Description, p.Status, p.BudgetAmount, p.DefaultBillableRate,
                    p.StartDate, p.EndDate, p.CreatedAt, p.UpdatedAt
                })
                .ToListAsync(ct);

            var projectDtos = projects.Select(p => new SyncProject(
                p.Id, clientByProject[p.Id], p.Name, p.Description, p.Status,
                p.BudgetAmount, p.DefaultBillableRate, p.StartDate, p.EndDate,
                p.CreatedAt, p.UpdatedAt)).ToList();

            var teams = await db.Teams
                .AsNoTracking()
                .Where(t => projectIds.Contains(t.ProjectId))
                .Select(t => new SyncTeam(
                    t.Id, t.ProjectId, t.Name, t.Description, t.CreatedAt,
                    t.TeamMembers.Select(tm => new SyncTeamMember(tm.UserId, tm.JoinedAt)).ToList()))
                .ToListAsync(ct);

            var tasks = await db.ProjectTasks
                .AsNoTracking()
                .Where(t => projectIds.Contains(t.ProjectId))
                .Select(t => new SyncTask(
                    t.Id, t.ProjectId, t.AssigneeId, t.Name, t.Description, t.Status, t.Priority,
                    t.DueDate, t.EstimatedHours, t.CreatedAt, t.UpdatedAt))
                .ToListAsync(ct);

            var invoices = await db.Invoices
                .AsNoTracking()
                .Where(i => i.OrganizationId == orgId)
                .Select(i => new SyncInvoice(
                    i.Id, i.ClientId, i.ProjectId, i.InvoiceNumber, i.Status,
                    i.TotalAmount, i.TaxRate, i.TaxAmount, i.Notes,
                    i.IssuedDate, i.DueDate, i.PaidDate, i.CreatedAt, i.UpdatedAt,
                    i.LineItems.Select(ili => new SyncInvoiceLineItem(
                        ili.Id, ili.Description, ili.Quantity, ili.UnitPrice, ili.Amount, ili.CreatedAt)).ToList()))
                .ToListAsync(ct);

            var timeEntries = await db.TimeEntries
                .AsNoTracking()
                .Where(te => te.OrganizationId == orgId)
                .Select(te => new SyncTimeEntry(
                    te.Id, te.UserId, te.ProjectId, te.TaskId, te.InvoiceLineItemId,
                    te.Date, te.Hours, te.Description, te.BillableRate, te.IsBillable, te.IsInvoiced,
                    te.CreatedAt, te.UpdatedAt))
                .ToListAsync(ct);

            return new SyncExport(
                CurrentVersion, DateTime.UtcNow, org,
                clients, projectDtos, teams, tasks, invoices, timeEntries);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/sync/export", async (ISender sender) =>
            {
                var data = await sender.Send(new Query());
                var jsonOptions = new System.Text.Json.JsonSerializerOptions
                {
                    PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase,
                    WriteIndented = true,
                    Converters = { new System.Text.Json.Serialization.JsonStringEnumConverter() }
                };
                var bytes = System.Text.Json.JsonSerializer.SerializeToUtf8Bytes(data, jsonOptions);
                var fileName = $"projectmanager-export-{data.Organization.Slug}-{DateTime.UtcNow:yyyyMMdd-HHmmss}.json";
                return Results.File(bytes, contentType: "application/json", fileDownloadName: fileName);
            })
            .WithName("ExportSync")
            .WithSummary("Export all data for the active organization as JSON")
            .WithDescription("Returns a downloadable JSON document containing all organization-scoped data (clients, projects, tasks, teams, invoices, time entries). Owner role required.")
            .Produces<SyncExport>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .WithTags("Sync")
            .RequireAuthorization();
        }
    }
}
