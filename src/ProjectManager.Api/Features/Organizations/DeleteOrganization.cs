using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.Organizations;

public static class DeleteOrganization
{
    public record Command(Guid Id) : IRequest;

    public class Handler(AppDbContext db) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var org = await db.Organizations
                .FirstOrDefaultAsync(o => o.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Organization not found");

            org.IsActive = false;
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/organizations/{id:guid}", async (Guid id, ISender sender) =>
            {
                await sender.Send(new Command(id));
                return Results.NoContent();
            })
            .WithName("DeleteOrganization")
            .WithSummary("Delete an organization")
            .WithDescription("Soft-deletes an organization by marking it as inactive. The organization data is retained but it will no longer appear in listings.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Organizations")
            .RequireAuthorization();
        }
    }
}
