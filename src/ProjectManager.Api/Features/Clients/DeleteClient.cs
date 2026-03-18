using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients;

public static class DeleteClient
{
    public record Command(Guid Id) : IRequest;

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var client = await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgService.OrganizationId!.Value && oc.ClientId == request.Id)
                .Select(oc => oc.Client)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new KeyNotFoundException("Client not found");

            client.IsActive = false;
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/clients/{id:guid}", async (Guid id, ISender sender) =>
            {
                await sender.Send(new Command(id));
                return Results.NoContent();
            })
            .WithName("DeleteClient")
            .WithSummary("Delete a client")
            .WithDescription("Soft-deletes a client by marking it inactive within the current organization. Requires the X-Organization-Id header.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("Clients")
            .RequireAuthorization();
        }
    }
}
