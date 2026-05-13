using Carter;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Admin;

public static class SetUserActive
{
    public record Command(Guid UserId, bool IsActive) : IRequest<Response>;

    public record Response(Guid UserId, string Email, bool IsActive);

    public class Handler(
        UserManager<User> userManager,
        AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var user = await userManager.FindByIdAsync(request.UserId.ToString())
                ?? throw new KeyNotFoundException("User not found");

            if (user.IsActive == request.IsActive)
                return new Response(user.Id, user.Email!, user.IsActive);

            user.IsActive = request.IsActive;
            user.UpdatedAt = DateTime.UtcNow;

            var result = await userManager.UpdateAsync(user);
            if (!result.Succeeded)
            {
                var message = string.Join("; ", result.Errors.Select(e => e.Description));
                throw new InvalidOperationException($"Failed to update user: {message}");
            }

            if (!request.IsActive)
            {
                var now = DateTime.UtcNow;
                await db.RefreshTokens
                    .Where(rt => rt.UserId == user.Id && rt.RevokedAt == null)
                    .ExecuteUpdateAsync(s => s.SetProperty(rt => rt.RevokedAt, now), cancellationToken);
            }

            return new Response(user.Id, user.Email!, user.IsActive);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/admin/users/{userId:guid}/active", async (
                Guid userId,
                Body body,
                ISender sender) =>
            {
                var response = await sender.Send(new Command(userId, body.IsActive));
                return Results.Ok(response);
            })
            .WithName("AdminSetUserActive")
            .WithSummary("Activate or deactivate a user")
            .WithDescription("Sets the target user's IsActive flag. Deactivating also revokes all of their active refresh tokens. Requires an admin-scoped token.")
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
