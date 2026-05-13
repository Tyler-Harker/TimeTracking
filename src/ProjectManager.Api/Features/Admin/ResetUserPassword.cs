using Carter;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Admin;

public static class ResetUserPassword
{
    public record Command(Guid UserId, string NewPassword) : IRequest<Response>;

    public record Response(Guid UserId, string Email);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.UserId).NotEmpty();
            RuleFor(x => x.NewPassword)
                .NotEmpty()
                .MinimumLength(8)
                .Matches("[A-Z]").WithMessage("Password must contain an uppercase letter.")
                .Matches("[a-z]").WithMessage("Password must contain a lowercase letter.")
                .Matches("[0-9]").WithMessage("Password must contain a digit.");
        }
    }

    public class Handler(
        UserManager<User> userManager,
        AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var user = await userManager.FindByIdAsync(request.UserId.ToString())
                ?? throw new KeyNotFoundException("User not found");

            var resetToken = await userManager.GeneratePasswordResetTokenAsync(user);
            var result = await userManager.ResetPasswordAsync(user, resetToken, request.NewPassword);

            if (!result.Succeeded)
            {
                var message = string.Join("; ", result.Errors.Select(e => e.Description));
                throw new InvalidOperationException($"Failed to reset password: {message}");
            }

            user.UpdatedAt = DateTime.UtcNow;
            await userManager.UpdateAsync(user);

            var now = DateTime.UtcNow;
            await db.RefreshTokens
                .Where(rt => rt.UserId == user.Id && rt.RevokedAt == null)
                .ExecuteUpdateAsync(s => s.SetProperty(rt => rt.RevokedAt, now), cancellationToken);

            return new Response(user.Id, user.Email!);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/admin/users/{userId:guid}/password", async (
                Guid userId,
                Body body,
                ISender sender) =>
            {
                var response = await sender.Send(new Command(userId, body.NewPassword));
                return Results.Ok(response);
            })
            .WithName("AdminResetUserPassword")
            .WithSummary("Reset a user's password")
            .WithDescription("Directly sets the target user's password to the supplied value and revokes all of their active refresh tokens. Requires an admin-scoped token.")
            .Accepts<Body>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Admin")
            .RequireAuthorization("Admin");
        }
    }

    public record Body(string NewPassword);
}
