using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Invoices;

internal static class InvoiceLineItemBuilder
{
    internal record Line(
        Guid ProjectId,
        string ProjectName,
        string Description,
        decimal Quantity,
        decimal UnitPrice,
        decimal Amount);

    internal static List<Line> Build(IEnumerable<TimeEntry> entries)
    {
        return entries
            .GroupBy(te => te.ProjectId)
            .Select(g =>
            {
                var hours = g.Sum(te => te.Hours);
                var avgRate = g.Average(te => te.BillableRate ?? 0);
                var projectName = g.First().Project.Name;
                return new Line(
                    g.Key,
                    projectName,
                    $"{projectName} ({g.Count()} entries, {hours:F2} hours)",
                    hours,
                    avgRate,
                    hours * avgRate);
            })
            .ToList();
    }
}
