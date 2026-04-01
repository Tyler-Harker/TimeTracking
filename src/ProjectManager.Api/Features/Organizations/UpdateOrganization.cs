using Carter;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Organizations;

public static class UpdateOrganization
{
    public record Command(Guid Id, string Name, string? Description, decimal? DefaultBillableRate, string? BankAccountNumber, string? BankRoutingNumber) : IRequest<Response>;
    public record Response(Guid Id, string Name, string Slug, string? Description, decimal? DefaultBillableRate, string? BankAccountNumber, string? BankRoutingNumber);

    public class Validator : AbstractValidator<Command>
    {
        public Validator()
        {
            RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
            RuleFor(x => x.Description).MaximumLength(1000);
            RuleFor(x => x.DefaultBillableRate).GreaterThanOrEqualTo(0).When(x => x.DefaultBillableRate.HasValue);
        }
    }

    public class Handler(AppDbContext db) : IRequestHandler<Command, Response>
    {
        public async Task<Response> Handle(Command request, CancellationToken cancellationToken)
        {
            var org = await db.Organizations
                .FirstOrDefaultAsync(o => o.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Organization not found");

            org.Name = request.Name;
            org.Description = request.Description;
            org.DefaultBillableRate = request.DefaultBillableRate;
            org.BankAccountNumber = request.BankAccountNumber;
            org.BankRoutingNumber = request.BankRoutingNumber;

            await db.SaveChangesAsync(cancellationToken);

            return new Response(org.Id, org.Name, org.Slug, org.Description, org.DefaultBillableRate, org.BankAccountNumber, org.BankRoutingNumber);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPut("/api/organizations/{id:guid}", async (Guid id, UpdateRequest body, ISender sender) =>
            {
                var response = await sender.Send(new Command(id, body.Name, body.Description, body.DefaultBillableRate, body.BankAccountNumber, body.BankRoutingNumber));
                return Results.Ok(response);
            })
            .WithName("UpdateOrganization")
            .WithSummary("Update an organization")
            .WithDescription("Updates the name and description of an existing organization identified by its unique ID.")
            .Accepts<UpdateRequest>("application/json")
            .Produces<Response>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity)
            .WithTags("Organizations")
            .RequireAuthorization();
        }
    }

    public record UpdateRequest(string Name, string? Description, decimal? DefaultBillableRate, string? BankAccountNumber, string? BankRoutingNumber);
}
