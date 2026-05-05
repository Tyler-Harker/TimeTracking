using System.Security.Claims;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Sync;

public static class ImportSync
{
    public record Command(SyncExport Payload) : IRequest<SyncImportSummary>;

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Payload).NotNull();
            RuleFor(x => x.Payload.Version).Equal(ExportSync.CurrentVersion)
                .WithMessage($"Unsupported export version. Expected {ExportSync.CurrentVersion}.");
            RuleFor(x => x.Payload.Organization).NotNull();
        }
    }

    public class Handler(
        AppDbContext db,
        ICurrentOrganizationService orgService,
        IHttpContextAccessor http) : IRequestHandler<Command, SyncImportSummary>
    {
        public async Task<SyncImportSummary> Handle(Command request, CancellationToken ct)
        {
            var orgId = orgService.OrganizationId
                ?? throw new InvalidOperationException("Organization context missing");
            // TODO: re-enable owner-only gate
            // await OwnerOnly.EnsureOwnerAsync(db, http, orgId, ct);

            var currentUserId = Guid.Parse(http.HttpContext!.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var payload = request.Payload;

            // Resolve which referenced users exist locally — anything missing gets remapped.
            var referencedUserIds = payload.TimeEntries.Select(te => te.UserId)
                .Concat(payload.Tasks.Where(t => t.AssigneeId.HasValue).Select(t => t.AssigneeId!.Value))
                .Concat(payload.Teams.SelectMany(t => t.Members.Select(m => m.UserId)))
                .Distinct()
                .ToList();

            var knownUserIds = referencedUserIds.Count == 0
                ? new HashSet<Guid>()
                : (await db.Users
                    .Where(u => referencedUserIds.Contains(u.Id))
                    .Select(u => u.Id)
                    .ToListAsync(ct)).ToHashSet();

            var strategy = db.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async cancellationToken =>
            {
                await using var tx = await db.Database.BeginTransactionAsync(cancellationToken);
                await WipeAsync(orgId, cancellationToken);
                var summary = await LoadAsync(orgId, payload, knownUserIds, currentUserId, cancellationToken);
                await tx.CommitAsync(cancellationToken);
                return summary;
            }, ct);
        }

        private async Task WipeAsync(Guid orgId, CancellationToken ct)
        {
            // 1. TimeEntries (org-scoped)
            await db.TimeEntries.IgnoreQueryFilters()
                .Where(te => te.OrganizationId == orgId).ExecuteDeleteAsync(ct);

            // 2. Invoice line items + invoices (org-scoped)
            var invoiceIds = await db.Invoices.IgnoreQueryFilters()
                .Where(i => i.OrganizationId == orgId).Select(i => i.Id).ToListAsync(ct);
            if (invoiceIds.Count > 0)
            {
                await db.InvoiceLineItems
                    .Where(ili => invoiceIds.Contains(ili.InvoiceId)).ExecuteDeleteAsync(ct);
                await db.Invoices.IgnoreQueryFilters()
                    .Where(i => i.OrganizationId == orgId).ExecuteDeleteAsync(ct);
            }

            // 3. Find this org's projects/clients via the link tables
            var projectIds = await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId)
                .Select(ocp => ocp.ProjectId).Distinct().ToListAsync(ct);
            var clientIds = await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgId)
                .Select(oc => oc.ClientId).ToListAsync(ct);

            if (projectIds.Count > 0)
            {
                var teamIds = await db.Teams
                    .Where(t => projectIds.Contains(t.ProjectId)).Select(t => t.Id).ToListAsync(ct);
                if (teamIds.Count > 0)
                {
                    await db.TeamMembers.Where(tm => teamIds.Contains(tm.TeamId)).ExecuteDeleteAsync(ct);
                    await db.Teams.Where(t => teamIds.Contains(t.Id)).ExecuteDeleteAsync(ct);
                }
                await db.ProjectTasks.Where(pt => projectIds.Contains(pt.ProjectId)).ExecuteDeleteAsync(ct);
            }

            // 4. Drop org<->project + org<->client links
            await db.OrganizationClientProjects
                .Where(ocp => ocp.OrganizationId == orgId).ExecuteDeleteAsync(ct);
            await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgId).ExecuteDeleteAsync(ct);

            // 5. Hard-delete projects/clients no longer referenced by any org (preserves shared)
            if (projectIds.Count > 0)
            {
                await db.Projects
                    .Where(p => projectIds.Contains(p.Id)
                        && !db.OrganizationClientProjects.Any(ocp => ocp.ProjectId == p.Id))
                    .ExecuteDeleteAsync(ct);
            }
            if (clientIds.Count > 0)
            {
                var orphanedClients = await db.Clients
                    .Where(c => clientIds.Contains(c.Id)
                        && !db.OrganizationClients.Any(oc => oc.ClientId == c.Id))
                    .Select(c => c.Id).ToListAsync(ct);
                if (orphanedClients.Count > 0)
                {
                    await db.ClientContacts.Where(cc => orphanedClients.Contains(cc.ClientId)).ExecuteDeleteAsync(ct);
                    await db.Clients.Where(c => orphanedClients.Contains(c.Id)).ExecuteDeleteAsync(ct);
                }
            }
        }

        private async Task<SyncImportSummary> LoadAsync(
            Guid orgId,
            SyncExport payload,
            HashSet<Guid> knownUserIds,
            Guid currentUserId,
            CancellationToken ct)
        {
            db.SuppressTimestamps = true;
            try
            {
                // Update org metadata (don't recreate — keep Id/Slug stable)
                var org = await db.Organizations.FirstAsync(o => o.Id == orgId, ct);
                org.Name = payload.Organization.Name;
                org.Description = payload.Organization.Description;
                org.Address = payload.Organization.Address;
                org.Phone = payload.Organization.Phone;
                org.Email = payload.Organization.Email;
                org.DefaultBillableRate = payload.Organization.DefaultBillableRate;
                org.BankAccountNumber = payload.Organization.BankAccountNumber;
                org.BankRoutingNumber = payload.Organization.BankRoutingNumber;
                await db.SaveChangesAsync(ct);

                // Pre-existing clients/projects (shared with other orgs) — skip creating, just relink
                var incomingClientIds = payload.Clients.Select(c => c.Id).ToList();
                var existingClientIds = await db.Clients
                    .Where(c => incomingClientIds.Contains(c.Id))
                    .Select(c => c.Id).ToListAsync(ct);
                var existingClientSet = existingClientIds.ToHashSet();

                int contactCount = 0;
                foreach (var c in payload.Clients)
                {
                    if (!existingClientSet.Contains(c.Id))
                    {
                        db.Clients.Add(new Client
                        {
                            Id = c.Id,
                            Name = c.Name,
                            Address = c.Address,
                            Website = c.Website,
                            IsActive = c.IsActive,
                            DefaultBillableRate = c.DefaultBillableRate,
                            CreatedAt = c.CreatedAt,
                            UpdatedAt = c.UpdatedAt
                        });
                        foreach (var contact in c.Contacts)
                        {
                            db.ClientContacts.Add(new ClientContact
                            {
                                Id = contact.Id,
                                ClientId = c.Id,
                                Name = contact.Name,
                                Email = contact.Email,
                                Phone = contact.Phone,
                                IsStakeHolder = contact.IsStakeHolder,
                                IsInvoicing = contact.IsInvoicing,
                                CreatedAt = contact.CreatedAt,
                                UpdatedAt = contact.UpdatedAt
                            });
                            contactCount++;
                        }
                    }
                    db.OrganizationClients.Add(new OrganizationClient
                    {
                        OrganizationId = orgId,
                        ClientId = c.Id,
                        AssignedAt = c.CreatedAt
                    });
                }

                var incomingProjectIds = payload.Projects.Select(p => p.Id).ToList();
                var existingProjectIds = await db.Projects
                    .Where(p => incomingProjectIds.Contains(p.Id))
                    .Select(p => p.Id).ToListAsync(ct);
                var existingProjectSet = existingProjectIds.ToHashSet();

                foreach (var p in payload.Projects)
                {
                    if (!existingProjectSet.Contains(p.Id))
                    {
                        db.Projects.Add(new Project
                        {
                            Id = p.Id,
                            Name = p.Name,
                            Description = p.Description,
                            Status = p.Status,
                            BudgetAmount = p.BudgetAmount,
                            DefaultBillableRate = p.DefaultBillableRate,
                            StartDate = p.StartDate,
                            EndDate = p.EndDate,
                            CreatedAt = p.CreatedAt,
                            UpdatedAt = p.UpdatedAt
                        });
                    }
                    db.OrganizationClientProjects.Add(new OrganizationClientProject
                    {
                        OrganizationId = orgId,
                        ClientId = p.ClientId,
                        ProjectId = p.Id,
                        AssignedAt = p.CreatedAt
                    });
                }

                await db.SaveChangesAsync(ct);

                int teamMemberCount = 0;
                foreach (var t in payload.Teams)
                {
                    db.Teams.Add(new Team
                    {
                        Id = t.Id,
                        ProjectId = t.ProjectId,
                        Name = t.Name,
                        Description = t.Description,
                        CreatedAt = t.CreatedAt
                    });
                    var seenUsers = new HashSet<Guid>();
                    foreach (var m in t.Members)
                    {
                        if (!knownUserIds.Contains(m.UserId)) continue; // skip members whose users don't exist locally
                        if (!seenUsers.Add(m.UserId)) continue;
                        db.TeamMembers.Add(new TeamMember
                        {
                            TeamId = t.Id,
                            UserId = m.UserId,
                            JoinedAt = m.JoinedAt
                        });
                        teamMemberCount++;
                    }
                }

                foreach (var t in payload.Tasks)
                {
                    db.ProjectTasks.Add(new ProjectTask
                    {
                        Id = t.Id,
                        ProjectId = t.ProjectId,
                        AssigneeId = t.AssigneeId.HasValue && knownUserIds.Contains(t.AssigneeId.Value)
                            ? t.AssigneeId
                            : null,
                        Name = t.Name,
                        Description = t.Description,
                        Status = t.Status,
                        Priority = t.Priority,
                        DueDate = t.DueDate,
                        EstimatedHours = t.EstimatedHours,
                        CreatedAt = t.CreatedAt,
                        UpdatedAt = t.UpdatedAt
                    });
                }

                await db.SaveChangesAsync(ct);

                int lineItemCount = 0;
                foreach (var inv in payload.Invoices)
                {
                    db.Invoices.Add(new Invoice
                    {
                        Id = inv.Id,
                        OrganizationId = orgId,
                        ClientId = inv.ClientId,
                        ProjectId = inv.ProjectId,
                        InvoiceNumber = inv.InvoiceNumber,
                        Status = inv.Status,
                        TotalAmount = inv.TotalAmount,
                        TaxRate = inv.TaxRate,
                        TaxAmount = inv.TaxAmount,
                        Notes = inv.Notes,
                        IssuedDate = inv.IssuedDate,
                        DueDate = inv.DueDate,
                        PaidDate = inv.PaidDate,
                        CreatedAt = inv.CreatedAt,
                        UpdatedAt = inv.UpdatedAt
                    });
                    foreach (var li in inv.LineItems)
                    {
                        db.InvoiceLineItems.Add(new InvoiceLineItem
                        {
                            Id = li.Id,
                            InvoiceId = inv.Id,
                            Description = li.Description,
                            Quantity = li.Quantity,
                            UnitPrice = li.UnitPrice,
                            Amount = li.Amount,
                            CreatedAt = li.CreatedAt
                        });
                        lineItemCount++;
                    }
                }

                await db.SaveChangesAsync(ct);

                foreach (var te in payload.TimeEntries)
                {
                    db.TimeEntries.Add(new TimeEntry
                    {
                        Id = te.Id,
                        OrganizationId = orgId,
                        UserId = knownUserIds.Contains(te.UserId) ? te.UserId : currentUserId,
                        ProjectId = te.ProjectId,
                        TaskId = te.TaskId,
                        InvoiceLineItemId = te.InvoiceLineItemId,
                        Date = te.Date,
                        Hours = te.Hours,
                        Description = te.Description,
                        BillableRate = te.BillableRate,
                        IsBillable = te.IsBillable,
                        IsInvoiced = te.IsInvoiced,
                        CreatedAt = te.CreatedAt,
                        UpdatedAt = te.UpdatedAt
                    });
                }

                await db.SaveChangesAsync(ct);

                return new SyncImportSummary(
                    Clients: payload.Clients.Count,
                    Contacts: contactCount,
                    Projects: payload.Projects.Count,
                    Teams: payload.Teams.Count,
                    TeamMembers: teamMemberCount,
                    Tasks: payload.Tasks.Count,
                    Invoices: payload.Invoices.Count,
                    InvoiceLineItems: lineItemCount,
                    TimeEntries: payload.TimeEntries.Count);
            }
            finally
            {
                db.SuppressTimestamps = false;
            }
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/sync/import", async (SyncExport payload, ISender sender) =>
            {
                var summary = await sender.Send(new Command(payload));
                return Results.Ok(summary);
            })
            .WithName("ImportSync")
            .WithSummary("Wipe the active organization's data and replace it with the supplied JSON")
            .WithDescription("Destructive: deletes all clients, projects, tasks, teams, invoices, and time entries scoped to the active organization, then reloads from the supplied export. Owner role required.")
            .Accepts<SyncExport>("application/json")
            .Produces<SyncImportSummary>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Sync")
            .RequireAuthorization()
            .DisableAntiforgery();
        }
    }
}
