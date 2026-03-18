using Carter;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.Auth;

namespace ProjectManager.Api.Features.Auth;

public static class Login
{
    public record Command(string Email, string Password) : IRequest<Response>;

    public record Response(
        string Token,
        string RefreshToken,
        DateTime ExpiresAt,
        IEnumerable<OrgMembership> Organizations);

    public record OrgMembership(Guid OrganizationId, string Name, string Role);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Email).NotEmpty().EmailAddress();
            RuleFor(x => x.Password).NotEmpty();
        }
    }

    public class Handler(
        UserManager<User> userManager,
        AppDbContext db,
        IJwtService jwtService,
        IHttpContextAccessor httpContextAccessor,
        Microsoft.Extensions.Options.IOptions<JwtSettings> jwtOptions) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var user = await userManager.FindByEmailAsync(request.Email)
                ?? throw new UnauthorizedAccessException("Invalid credentials");

            if (!user.IsActive)
                throw new UnauthorizedAccessException("Account is deactivated");

            var validPassword = await userManager.CheckPasswordAsync(user, request.Password);
            if (!validPassword)
                throw new UnauthorizedAccessException("Invalid credentials");

            var memberships = await db.OrganizationUsers
                .Include(ou => ou.Organization)
                .Where(ou => ou.UserId == user.Id)
                .ToListAsync(cancellationToken);

            var token = jwtService.GenerateToken(user, memberships);
            var refreshTokenValue = jwtService.GenerateRefreshToken();

            var settings = jwtOptions.Value;
            var refreshToken = new Data.Entities.RefreshToken
            {
                UserId = user.Id,
                Token = refreshTokenValue,
                ExpiresAt = DateTime.UtcNow.AddDays(settings.RefreshTokenExpirationDays),
                CreatedByIp = httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString()
            };

            db.RefreshTokens.Add(refreshToken);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(
                token,
                refreshTokenValue,
                DateTime.UtcNow.AddMinutes(settings.ExpirationMinutes),
                memberships.Select(m => new OrgMembership(
                    m.OrganizationId,
                    m.Organization.Name,
                    m.Role.ToString())));
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/auth/login", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Ok(response);
            })
            .WithName("Login")
            .WithSummary("Authenticate a user")
            .WithDescription("Authenticates a user with their email and password. Returns a JWT token, refresh token, expiration time, and the user's organization memberships.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Auth")
            .AllowAnonymous();
        }
    }
}
