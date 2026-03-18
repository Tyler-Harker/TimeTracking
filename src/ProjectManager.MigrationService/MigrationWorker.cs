using Microsoft.EntityFrameworkCore;
using ProjectManager.Api.Data;

namespace ProjectManager.MigrationService;

public class MigrationWorker(
    IServiceProvider serviceProvider,
    IHostApplicationLifetime hostApplicationLifetime,
    ILogger<MigrationWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        try
        {
            using var scope = serviceProvider.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            var pending = await db.Database.GetPendingMigrationsAsync(stoppingToken);
            var pendingList = pending.ToList();

            if (pendingList.Count == 0)
            {
                logger.LogInformation("No pending migrations");
            }
            else
            {
                logger.LogInformation("Applying {Count} pending migration(s)...", pendingList.Count);

                foreach (var migration in pendingList)
                {
                    logger.LogInformation("Applying migration: {Migration}", migration);
                }

                await db.Database.MigrateAsync(stoppingToken);

                logger.LogInformation("All migrations applied successfully");
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred while applying migrations");
            throw;
        }

        hostApplicationLifetime.StopApplication();
    }
}
