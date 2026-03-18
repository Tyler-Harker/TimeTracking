using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.Auth;

namespace ProjectManager.Api.Features.Auth;

public static class RefreshToken
{
    public record Command(string Token, string RefreshToken) : IRequest<Response>;
    public record Response(string Token, string RefreshToken, DateTime ExpiresAt);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Token).NotEmpty();
            RuleFor(x => x.RefreshToken).NotEmpty();
        }
    }

    public class Handler(
        AppDbContext db,
        IJwtService jwtService,
        IHttpContextAccessor httpContextAccessor,
        Microsoft.Extensions.Options.IOptions<JwtSettings> jwtOptions) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var principal = jwtService.GetPrincipalFromExpiredToken(request.Token)
                ?? throw new UnauthorizedAccessException("Invalid token");

            var userId = Guid.Parse(principal.FindFirstValue(JwtRegisteredClaimNames.Sub)
                ?? principal.FindFirstValue(ClaimTypes.NameIdentifier)
                ?? throw new UnauthorizedAccessException("Invalid token"));

            var storedToken = await db.RefreshTokens
                .Include(rt => rt.User)
                .FirstOrDefaultAsync(rt => rt.Token == request.RefreshToken && rt.UserId == userId, cancellationToken)
                ?? throw new UnauthorizedAccessException("Invalid refresh token");

            if (!storedToken.IsActive)
                throw new UnauthorizedAccessException("Refresh token is no longer active");

            // Revoke old token
            storedToken.RevokedAt = DateTime.UtcNow;

            // Generate new tokens
            var memberships = await db.OrganizationUsers
                .Where(ou => ou.UserId == userId)
                .ToListAsync(cancellationToken);

            var newToken = jwtService.GenerateToken(storedToken.User, memberships);
            var newRefreshTokenValue = jwtService.GenerateRefreshToken();

            storedToken.ReplacedByToken = newRefreshTokenValue;

            var settings = jwtOptions.Value;
            var newRefreshToken = new Data.Entities.RefreshToken
            {
                UserId = userId,
                Token = newRefreshTokenValue,
                ExpiresAt = DateTime.UtcNow.AddDays(settings.RefreshTokenExpirationDays),
                CreatedByIp = httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString()
            };

            db.RefreshTokens.Add(newRefreshToken);
            await db.SaveChangesAsync(cancellationToken);

            return new Response(
                newToken,
                newRefreshTokenValue,
                DateTime.UtcNow.AddMinutes(settings.ExpirationMinutes));
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/auth/refresh-token", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Ok(response);
            })
            .WithName("RefreshToken")
            .WithSummary("Refresh an authentication token")
            .WithDescription("Exchanges an expired JWT token and a valid refresh token for a new JWT token and refresh token pair. The old refresh token is revoked upon successful exchange.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Auth")
            .AllowAnonymous();
        }
    }
}
