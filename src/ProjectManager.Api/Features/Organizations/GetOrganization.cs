using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Organizations;

public static class GetOrganization
{
    public record Query(Guid Id) : IRequest<Response>;

    public record Response(
        Guid Id,
        string Name,
        string Slug,
        string? Description,
        bool IsActive,
        DateTime CreatedAt,
        decimal? DefaultBillableRate,
        string? BankAccountNumber,
        string? BankRoutingNumber,
        IEnumerable<MemberInfo> Members);

    public record MemberInfo(Guid UserId, string Email, string FirstName, string LastName, string Role);

    public class Handler(AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var org = await db.Organizations
                .Include(o => o.OrganizationUsers)
                    .ThenInclude(ou => ou.User)
                .FirstOrDefaultAsync(o => o.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Organization not found");

            return new Response(
                org.Id,
                org.Name,
                org.Slug,
                org.Description,
                org.IsActive,
                org.CreatedAt,
                org.DefaultBillableRate,
                org.BankAccountNumber,
                org.BankRoutingNumber,
                org.OrganizationUsers.Select(ou => new MemberInfo(
                    ou.UserId, ou.User.Email!, ou.User.FirstName, ou.User.LastName, ou.Role.ToString())));
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/organizations/{id:guid}", async (Guid id, ISender sender) =>
            {
                var response = await sender.Send(new Query(id));
                return Results.Ok(response);
            })
            .WithName("GetOrganization")
            .WithSummary("Get an organization by ID")
            .WithDescription("Retrieves a single organization by its unique identifier, including its list of members.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Organizations")
            .RequireAuthorization();
        }
    }
}
