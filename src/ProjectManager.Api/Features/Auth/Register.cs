using Carter;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Auth;

public static class Register
{
    public record Command(string Email, string Password, string FirstName, string LastName) : IRequest<Response>;
    public record Response(Guid UserId, string Email);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Email).NotEmpty().EmailAddress();
            RuleFor(x => x.Password).NotEmpty().MinimumLength(8);
            RuleFor(x => x.FirstName).NotEmpty().MaximumLength(100);
            RuleFor(x => x.LastName).NotEmpty().MaximumLength(100);
        }
    }

    public class Handler(UserManager<User> userManager) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var user = new User
            {
                UserName = request.Email,
                Email = request.Email,
                FirstName = request.FirstName,
                LastName = request.LastName
            };

            var result = await userManager.CreateAsync(user, request.Password);

            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                throw new InvalidOperationException($"Failed to create user: {errors}");
            }

            return new Response(user.Id, user.Email);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/auth/register", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/users/{response.UserId}", response);
            })
            .WithName("Register")
            .WithSummary("Register a new user")
            .WithDescription("Creates a new user account with the provided email, password, first name, and last name. Returns the created user's ID and email.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Auth")
            .AllowAnonymous();
        }
    }
}
