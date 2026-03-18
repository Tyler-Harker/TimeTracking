using Carter;
using MediatR;
using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;
using ProjectManager.Api.Infrastructure.MultiTenancy;

namespace ProjectManager.Api.Features.Clients;

public static class ListClients
{
    public record Query : IRequest<IEnumerable<Response>>;
    public record Response(Guid Id, string Name, int ContactCount, bool IsActive, decimal? DefaultBillableRate);

    public class Handler(AppDbContext db, ICurrentOrganizationService orgService) : IRequestHandler<Query, IEnumerable<Response>>
    {
        public async Task<IEnumerable<Response>> Handle(Query request, CancellationToken cancellationToken)
        {
            return await db.OrganizationClients
                .Where(oc => oc.OrganizationId == orgService.OrganizationId!.Value)
                .Select(oc => new Response(oc.Client.Id, oc.Client.Name, oc.Client.Contacts.Count, oc.Client.IsActive, oc.Client.DefaultBillableRate))
                .ToListAsync(cancellationToken);
        }
    }

    public class Endpoint : ICarterModule
    {
        public void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/api/clients", async (ISender sender) =>
            {
                var response = await sender.Send(new Query());
                return Results.Ok(response);
            })
            .WithName("ListClients")
            .WithSummary("List all clients")
            .WithDescription("Lists all clients in the current organization. Requires the X-Organization-Id header.")
            .Produces<IEnumerable<Response>>(StatusCodes.Status200OK)
            .WithTags("Clients")
            .RequireAuthorization();
        }
    }
}
