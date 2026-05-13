using Carter;
using FluentValidation;
using MediatR;
using Microsoft.Extensions.Options;
using ProjectManager.Api.Infrastructure.Auth;

namespace ProjectManager.Api.Features.Admin;

public static class AdminLogin
{
    public record Command(string Username, string Password) : IRequest<Response>;

    public record Response(string Token, DateTime ExpiresAt);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Username).NotEmpty();
            RuleFor(x => x.Password).NotEmpty();
        }
    }

    public class Handler(
        IJwtService jwtService,
        IOptions<AdminSettings> adminOptions) : IRequestHandler<Command, Response>
    {
        public Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var settings = adminOptions.Value;

            if (!settings.Enabled)
                throw new UnauthorizedAccessException("Admin login is not enabled");

            if (string.IsNullOrEmpty(settings.Username) || string.IsNullOrEmpty(settings.Password))
                throw new UnauthorizedAccessException("Admin login is not configured");

            var usernameMatches = CryptographicEquals(request.Username, settings.Username);
            var passwordMatches = CryptographicEquals(request.Password, settings.Password);

            if (!usernameMatches || !passwordMatches)
                throw new UnauthorizedAccessException("Invalid admin credentials");

            var expirationMinutes = settings.TokenExpirationMinutes <= 0 ? 30 : settings.TokenExpirationMinutes;
            var token = jwtService.GenerateAdminToken(settings.Username, expirationMinutes);
            var expiresAt = DateTime.UtcNow.AddMinutes(expirationMinutes);

            return Task.FromResult(new Response(token, expiresAt));
        }

        private static bool CryptographicEquals(string a, string b)
        {
            var aBytes = System.Text.Encoding.UTF8.GetBytes(a);
            var bBytes = System.Text.Encoding.UTF8.GetBytes(b);
            return System.Security.Cryptography.CryptographicOperations.FixedTimeEquals(aBytes, bBytes);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/admin/login", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Ok(response);
            })
            .WithName("AdminLogin")
            .WithSummary("Authenticate as the configured admin")
            .WithDescription("Authenticates against the username/password configured via the Admin:Username and Admin:Password settings (env vars). Requires Admin:Enabled to be true. Returns an admin-scoped JWT.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Admin")
            .AllowAnonymous();
        }
    }
}
