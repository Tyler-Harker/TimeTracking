using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Sync;

public record SyncExport(
    int Version,
    DateTime ExportedAt,
    SyncOrganization Organization,
    IReadOnlyList<SyncClient> Clients,
    IReadOnlyList<SyncProject> Projects,
    IReadOnlyList<SyncTeam> Teams,
    IReadOnlyList<SyncTask> Tasks,
    IReadOnlyList<SyncInvoice> Invoices,
    IReadOnlyList<SyncTimeEntry> TimeEntries);

public record SyncOrganization(
    Guid Id,
    string Name,
    string Slug,
    string? Description,
    string? Address,
    string? Phone,
    string? Email,
    decimal? DefaultBillableRate,
    string? BankAccountNumber,
    string? BankRoutingNumber,
    DateTime CreatedAt,
    DateTime UpdatedAt);

public record SyncClient(
    Guid Id,
    string Name,
    string? Address,
    string? Website,
    bool IsActive,
    decimal? DefaultBillableRate,
    DateTime CreatedAt,
    DateTime UpdatedAt,
    IReadOnlyList<SyncClientContact> Contacts);

public record SyncClientContact(
    Guid Id,
    string Name,
    string? Email,
    string? Phone,
    bool IsStakeHolder,
    bool IsInvoicing,
    DateTime CreatedAt,
    DateTime UpdatedAt);

public record SyncProject(
    Guid Id,
    Guid ClientId,
    string Name,
    string? Description,
    ProjectStatus Status,
    decimal? BudgetAmount,
    decimal? DefaultBillableRate,
    DateOnly? StartDate,
    DateOnly? EndDate,
    DateTime CreatedAt,
    DateTime UpdatedAt);

public record SyncTeam(
    Guid Id,
    Guid ProjectId,
    string Name,
    string? Description,
    DateTime CreatedAt,
    IReadOnlyList<SyncTeamMember> Members);

public record SyncTeamMember(Guid UserId, DateTime JoinedAt);

public record SyncTask(
    Guid Id,
    Guid ProjectId,
    Guid? AssigneeId,
    string Name,
    string? Description,
    Data.Entities.TaskStatus Status,
    TaskPriority Priority,
    DateOnly? DueDate,
    decimal? EstimatedHours,
    DateTime CreatedAt,
    DateTime UpdatedAt);

public record SyncInvoice(
    Guid Id,
    Guid? ClientId,
    Guid? ProjectId,
    string InvoiceNumber,
    InvoiceStatus Status,
    decimal TotalAmount,
    decimal TaxRate,
    decimal TaxAmount,
    string? Notes,
    DateOnly IssuedDate,
    DateOnly DueDate,
    DateOnly? PaidDate,
    DateTime CreatedAt,
    DateTime UpdatedAt,
    IReadOnlyList<SyncInvoiceLineItem> LineItems);

public record SyncInvoiceLineItem(
    Guid Id,
    string Description,
    decimal Quantity,
    decimal UnitPrice,
    decimal Amount,
    DateTime CreatedAt);

public record SyncTimeEntry(
    Guid Id,
    Guid UserId,
    Guid ProjectId,
    Guid? TaskId,
    Guid? InvoiceLineItemId,
    DateOnly Date,
    decimal Hours,
    string? Description,
    decimal? BillableRate,
    bool IsBillable,
    bool IsInvoiced,
    DateTime CreatedAt,
    DateTime UpdatedAt);

public record SyncImportSummary(
    int Clients,
    int Contacts,
    int Projects,
    int Teams,
    int TeamMembers,
    int Tasks,
    int Invoices,
    int InvoiceLineItems,
    int TimeEntries);
