using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Admin;

public static class SetOrganizationActive
{
    public record Command(Guid OrganizationId, bool IsActive) : IRequest<Response>;

    public record Response(Guid OrganizationId, string Name, bool IsActive);

    public class Handler(AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var org = await db.Organizations
                .FirstOrDefaultAsync(o => o.Id == request.OrganizationId, cancellationToken)
                ?? throw new KeyNotFoundException("Organization not found");

            if (org.IsActive != request.IsActive)
            {
                org.IsActive = request.IsActive;
                org.UpdatedAt = DateTime.UtcNow;
                await db.SaveChangesAsync(cancellationToken);
            }

            return new Response(org.Id, org.Name, org.IsActive);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/admin/organizations/{organizationId:guid}/active", async (
                Guid organizationId,
                Body body,
                ISender sender) =>
            {
                var response = await sender.Send(new Command(organizationId, body.IsActive));
                return Results.Ok(response);
            })
            .WithName("AdminSetOrganizationActive")
            .WithSummary("Activate or deactivate an organization")
            .WithDescription("Toggles Organization.IsActive. Deactivated orgs are hidden from regular users' org lists but data is preserved. Requires an admin-scoped token.")
            .Accepts<Body>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Admin")
            .RequireAuthorization("Admin");
        }
    }

    public record Body(bool IsActive);
}
