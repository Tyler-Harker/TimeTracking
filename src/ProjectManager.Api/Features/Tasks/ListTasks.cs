using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Tasks;

public static class ListTasks
{
    public record Query(
        Guid? ProjectId,
        Guid? AssigneeId,
        Data.Entities.TaskStatus? Status,
        int Page = 1,
        int PageSize = 20) : IRequest<Response>;

    public record Response(IEnumerable<TaskItem> Items, int TotalCount, int Page, int PageSize);

    public record TaskItem(
        Guid Id,
        Guid ProjectId,
        string ProjectName,
        string Name,
        string Status,
        string Priority,
        Guid? AssigneeId,
        string? AssigneeName,
        DateOnly? DueDate,
        decimal? EstimatedHours,
        DateTime LastActivity);

    public class Handler(
        AppDbContext db,
        ICurrentOrganizationService orgService) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var orgId = orgService.OrganizationId!.Value;

            var query = db.ProjectTasks
                .Include(t => t.Project)
                .Include(t => t.Assignee)
                .Where(t => db.OrganizationClientProjects
                    .Any(ocp => ocp.OrganizationId == orgId && ocp.ProjectId == t.ProjectId))
                .AsQueryable();

            if (request.ProjectId.HasValue)
                query = query.Where(t => t.ProjectId == request.ProjectId.Value);

            if (request.AssigneeId.HasValue)
                query = query.Where(t => t.AssigneeId == request.AssigneeId.Value);

            if (request.Status.HasValue)
                query = query.Where(t => t.Status == request.Status.Value);

            var totalCount = await query.CountAsync(cancellationToken);

            var items = await query
                .OrderBy(t => t.Status == Data.Entities.TaskStatus.Completed ? 1 : 0)
                .ThenByDescending(t =>
                    t.TimeEntries.Any()
                        ? (t.TimeEntries.Max(te => te.CreatedAt) > t.UpdatedAt
                            ? t.TimeEntries.Max(te => te.CreatedAt)
                            : t.UpdatedAt)
                        : t.UpdatedAt)
                .ThenByDescending(t => t.Priority)
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .Select(t => new TaskItem(
                    t.Id, t.ProjectId, t.Project.Name,
                    t.Name, t.Status.ToString(), t.Priority.ToString(),
                    t.AssigneeId,
                    t.Assignee != null ? t.Assignee.FirstName + " " + t.Assignee.LastName : null,
                    t.DueDate, t.EstimatedHours,
                    t.TimeEntries.Any()
                        ? (t.TimeEntries.Max(te => te.CreatedAt) > t.UpdatedAt
                            ? t.TimeEntries.Max(te => te.CreatedAt)
                            : t.UpdatedAt)
                        : t.UpdatedAt))
                .ToListAsync(cancellationToken);

            return new Response(items, totalCount, request.Page, request.PageSize);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/tasks", async (
                Guid? projectId, Guid? assigneeId, Data.Entities.TaskStatus? status,
                int? page, int? pageSize, ISender sender) =>
            {
                var response = await sender.Send(new Query(projectId, assigneeId, status, page ?? 1, pageSize ?? 20));
                return Results.Ok(response);
            })
            .WithName("ListTasks")
            .WithSummary("List tasks")
            .WithDescription("Lists tasks with pagination and optional filters for project, assignee, and status. Requires the X-Organization-Id header.")
            .Produces<Response>(StatusCodes.Status200OK)
            .WithTags("Tasks")
            .RequireAuthorization();
        }
    }
}
