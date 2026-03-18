using System.Security.Claims;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Users;

public static class UpdateUser
{
    public record Command(string FirstName, string LastName, string? AvatarUrl) : IRequest<Response>;
    public record Response(Guid Id, string Email, string FirstName, string LastName, string? AvatarUrl);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.FirstName).NotEmpty().MaximumLength(100);
            RuleFor(x => x.LastName).NotEmpty().MaximumLength(100);
            RuleFor(x => x.AvatarUrl).MaximumLength(500);
        }
    }

    public class Handler(
        UserManager<User> userManager,
        IHttpContextAccessor httpContextAccessor) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var userId = Guid.Parse(httpContextAccessor.HttpContext!.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var user = await userManager.FindByIdAsync(userId.ToString())
                ?? throw new KeyNotFoundException("User not found");

            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            user.AvatarUrl = request.AvatarUrl;

            var result = await userManager.UpdateAsync(user);
            if (!result.Succeeded)
                throw new InvalidOperationException("Failed to update user");

            return new Response(user.Id, user.Email!, user.FirstName, user.LastName, user.AvatarUrl);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/users/me", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Ok(response);
            })
            .WithName("UpdateUser")
            .WithSummary("Update the current user's profile")
            .WithDescription("Updates the first name, last name, and avatar URL of the currently authenticated user. Returns the updated user profile.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Users")
            .RequireAuthorization();
        }
    }
}
