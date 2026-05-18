using Carter;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Admin;

public static class SetOrganizationOwner
{
    public record Command(Guid OrganizationId, Guid UserId) : IRequest<Response>;

    public record Response(
        Guid OrganizationId,
        Guid OwnerUserId,
        string OwnerEmail,
        IReadOnlyList<Guid> DemotedOwnerUserIds);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.OrganizationId).NotEmpty();
            RuleFor(x => x.UserId).NotEmpty();
        }
    }

    public class Handler(
        AppDbContext db,
        UserManager<User> userManager) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var org = await db.Organizations
                .FirstOrDefaultAsync(o => o.Id == request.OrganizationId, cancellationToken)
                ?? throw new KeyNotFoundException("Organization not found");

            var user = await userManager.FindByIdAsync(request.UserId.ToString())
                ?? throw new KeyNotFoundException("User not found");

            if (!user.IsActive)
                throw new InvalidOperationException("Cannot assign a deactivated user as owner.");

            var memberships = await db.OrganizationUsers
                .Where(ou => ou.OrganizationId == request.OrganizationId)
                .ToListAsync(cancellationToken);

            // Demote anyone currently Owner (other than the target user) to Admin so the
            // chosen user ends up as the sole Owner. Keeps them in the org with manage rights.
            var demoted = new List<Guid>();
            foreach (var membership in memberships)
            {
                if (membership.Role == OrganizationRole.Owner && membership.UserId != user.Id)
                {
                    membership.Role = OrganizationRole.Admin;
                    demoted.Add(membership.UserId);
                }
            }

            var target = memberships.FirstOrDefault(ou => ou.UserId == user.Id);
            if (target is null)
            {
                db.OrganizationUsers.Add(new OrganizationUser
                {
                    OrganizationId = org.Id,
                    UserId = user.Id,
                    Role = OrganizationRole.Owner,
                });
            }
            else
            {
                target.Role = OrganizationRole.Owner;
            }

            org.UpdatedAt = DateTime.UtcNow;

            await db.SaveChangesAsync(cancellationToken);

            return new Response(org.Id, user.Id, user.Email!, demoted);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/admin/organizations/{organizationId:guid}/owner", async (
                Guid organizationId,
                Body body,
                ISender sender) =>
            {
                var response = await sender.Send(new Command(organizationId, body.UserId));
                return Results.Ok(response);
            })
            .WithName("AdminSetOrganizationOwner")
            .WithSummary("Transfer ownership of an organization")
            .WithDescription("Sets the target user as the sole Owner. Any existing Owner(s) are demoted to Admin (kept in the org). If the target user isn't already a member, they're added as Owner. Requires an admin-scoped token.")
            .Accepts<Body>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Admin")
            .RequireAuthorization("Admin");
        }
    }

    public record Body(Guid UserId);
}
