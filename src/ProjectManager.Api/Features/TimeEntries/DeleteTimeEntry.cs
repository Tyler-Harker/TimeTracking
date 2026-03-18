using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.Api.Features.TimeEntries;

public static class DeleteTimeEntry
{
    public record Command(Guid Id) : IRequest;

    public class Handler(AppDbContext db) : IRequestHandler<Command>
    {
        public async Task Handle(Command request, CancellationToken cancellationToken)
        {
            var entry = await db.TimeEntries
                .FirstOrDefaultAsync(te => te.Id == request.Id, cancellationToken)
                ?? throw new KeyNotFoundException("Time entry not found");

            if (entry.IsInvoiced)
                throw new InvalidOperationException("Cannot delete an invoiced time entry");

            db.TimeEntries.Remove(entry);
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapDelete("/api/time-entries/{id:guid}", async (Guid id, ISender sender) =>
            {
                await sender.Send(new Command(id));
                return Results.NoContent();
            })
            .WithName("DeleteTimeEntry")
            .WithSummary("Delete a time entry")
            .WithDescription("Deletes a time entry by ID. Invoiced time entries cannot be deleted. Requires the X-Organization-Id header.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .WithTags("TimeEntries")
            .RequireAuthorization();
        }
    }
}
