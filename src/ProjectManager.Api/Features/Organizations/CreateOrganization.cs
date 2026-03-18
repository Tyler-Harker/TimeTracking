using System.Security.Claims;
using System.Text.RegularExpressions;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Organizations;

public static class CreateOrganization
{
    public record Command(string Name, string? Description, decimal? DefaultBillableRate) : IRequest<Response>;
    public record Response(Guid Id, string Name, string Slug, string? Description, decimal? DefaultBillableRate);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(1000);
            RuleFor(x => x.DefaultBillableRate).GreaterThanOrEqualTo(0).When(x => x.DefaultBillableRate.HasValue);
        }
    }

    public class Handler(AppDbContext db, IHttpContextAccessor httpContextAccessor) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var userId = Guid.Parse(httpContextAccessor.HttpContext!.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var slug = GenerateSlug(request.Name);

            // Ensure unique slug
            var baseSlug = slug;
            var counter = 1;
            while (await db.Organizations.AnyAsync(o => o.Slug == slug, cancellationToken))
            {
                slug = $"{baseSlug}-{counter++}";
            }

            var organization = new Organization
            {
                Name = request.Name,
                Slug = slug,
                Description = request.Description,
                DefaultBillableRate = request.DefaultBillableRate
            };

            db.Organizations.Add(organization);

            // Creator becomes Owner
            db.OrganizationUsers.Add(new OrganizationUser
            {
                OrganizationId = organization.Id,
                UserId = userId,
                Role = OrganizationRole.Owner
            });

            await db.SaveChangesAsync(cancellationToken);

            return new Response(organization.Id, organization.Name, organization.Slug, organization.Description, organization.DefaultBillableRate);
        }

        private static string GenerateSlug(string name)
        {
            var slug = name.ToLowerInvariant();
            slug = Regex.Replace(slug, @"[^a-z0-9\s-]", "");
            slug = Regex.Replace(slug, @"\s+", "-");
            slug = Regex.Replace(slug, @"-+", "-");
            return slug.Trim('-');
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/api/organizations", async (Command command, ISender sender) =>
            {
                var response = await sender.Send(command);
                return Results.Created($"/api/organizations/{response.Id}", response);
            })
            .WithName("CreateOrganization")
            .WithSummary("Create a new organization")
            .WithDescription("Creates a new organization with the given name and description. The authenticated user automatically becomes the Owner of the organization.")
            .Accepts<Command>("application/json")
            .Produces<Response>(StatusCodes.Status201Created)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Organizations")
            .RequireAuthorization();
        }
    }
}
