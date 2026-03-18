using System.Security.Claims;
using Carter;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Users;

public static class GetCurrentUser
{
    public record Query : IRequest<Response>;

    public record Response(
        Guid Id,
        string Email,
        string FirstName,
        string LastName,
        string? AvatarUrl,
        IEnumerable<OrgMembership> Organizations);

    public record OrgMembership(Guid OrganizationId, string Name, string Role);

    public class Handler(
        UserManager<User> userManager,
        IHttpContextAccessor httpContextAccessor,
        AppDbContext db) : IRequestHandler<Query, Response>
    {
        public async Task<Response> Handle(Query request, CancellationToken cancellationToken)
        {
            var userId = Guid.Parse(httpContextAccessor.HttpContext!.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var user = await userManager.FindByIdAsync(userId.ToString())
                ?? throw new KeyNotFoundException("User not found");

            var memberships = await db.OrganizationUsers
                .Include(ou => ou.Organization)
                .Where(ou => ou.UserId == userId)
                .Select(ou => new OrgMembership(ou.OrganizationId, ou.Organization.Name, ou.Role.ToString()))
                .ToListAsync(cancellationToken);

            return new Response(user.Id, user.Email!, user.FirstName, user.LastName, user.AvatarUrl, memberships);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/users/me", async (ISender sender) =>
            {
                var response = await sender.Send(new Query());
                return Results.Ok(response);
            })
            .WithName("GetCurrentUser")
            .WithSummary("Get the current authenticated user")
            .WithDescription("Retrieves the profile of the currently authenticated user, including their personal details, avatar URL, and organization memberships.")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Users")
            .RequireAuthorization();
        }
    }
}
