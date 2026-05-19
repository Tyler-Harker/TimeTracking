using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.TimeEntries;

public static class ListTimeEntries
{
    public const int MaxPageSize = 500;

    public record Query(
        Guid? ProjectId,
        Guid? UserId,
        Guid? ClientId,
        DateOnly? FromDate,
        DateOnly? ToDate,
        Guid? TaskId,
        bool Unpaged = false,
        int Page = 1,
        int PageSize = 20) : IRequest<Response>;

    public record Response(IEnumerable<TimeEntryItem> Items, int TotalCount, int Page, int PageSize);

    public record TimeEntryItem(
        Guid Id,
        Guid UserId,
        string UserName,
        Guid ProjectId,
        string ProjectName,
        DateOnly Date,
        decimal Hours,
        string? Description,
        bool IsBillable,
        bool IsInvoiced,
        Guid? TaskId,
        string? TaskName);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var query = db.TimeEntries
                .Include(te => te.User)
                .Include(te => te.Project)
                .Include(te => te.Task)
                .AsQueryable();

            if (request.ProjectId.HasValue)
                query = query.Where(te => te.ProjectId == request.ProjectId.Value);

            if (request.UserId.HasValue)
                query = query.Where(te => te.UserId == request.UserId.Value);

            if (request.ClientId.HasValue)
            {
                var clientProjectIds = db.OrganizationClientProjects
                    .Where(ocp => ocp.ClientId == request.ClientId.Value)
                    .Select(ocp => ocp.ProjectId);
                query = query.Where(te => clientProjectIds.Contains(te.ProjectId));
            }

            if (request.FromDate.HasValue)
                query = query.Where(te => te.Date >= request.FromDate.Value);

            if (request.ToDate.HasValue)
                query = query.Where(te => te.Date <= request.ToDate.Value);

            if (request.TaskId.HasValue)
                query = query.Where(te => te.TaskId == request.TaskId.Value);

            var totalCount = await query.CountAsync(cancellationToken);

            var ordered = query
                .OrderByDescending(te => te.Date)
                .ThenByDescending(te => te.CreatedAt);

            var pageSize = Math.Clamp(request.PageSize, 1, MaxPageSize);
            var page = Math.Max(request.Page, 1);

            var projected = request.Unpaged
                ? (IQueryable<TimeEntry>)ordered
                : ordered.Skip((page - 1) * pageSize).Take(pageSize);

            var items = await projected
                .Select(te => new TimeEntryItem(
                    te.Id, te.UserId, te.User.FirstName + " " + te.User.LastName,
                    te.ProjectId, te.Project.Name,
                    te.Date, te.Hours, te.Description, te.IsBillable, te.IsInvoiced,
                    te.TaskId, te.Task != null ? te.Task.Name : null))
                .ToListAsync(cancellationToken);

            return new Response(items, totalCount, request.Unpaged ? 1 : page, request.Unpaged ? items.Count : pageSize);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/time-entries", async (
                Guid? projectId, Guid? userId, Guid? clientId, DateOnly? fromDate, DateOnly? toDate,
                Guid? taskId, bool? unpaged, int? page, int? pageSize, ISender sender) =>
            {
                var response = await sender.Send(new Query(
                    projectId, userId, clientId, fromDate, toDate, taskId,
                    unpaged ?? false, page ?? 1, pageSize ?? 20));
                return Results.Ok(response);
            })
            .WithName("ListTimeEntries")
            .WithSummary("List time entries")
            .WithDescription("Lists time entries with optional filters for project, user, client, task, and date range within the current organization. Paged by default (max page size 500); pass unpaged=true to skip paging — recommended only when fromDate/toDate are set. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .WithTags("TimeEntries")
            .RequireAuthorization();
        }
    }
}
