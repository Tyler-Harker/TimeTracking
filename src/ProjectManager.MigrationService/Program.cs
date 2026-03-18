using ProjectManager.Api.Data;
using ProjectManager.MigrationService;

var builder = Host.CreateApplicationBuilder(args);

builder.AddServiceDefaults();
builder.AddNpgsqlDbContext<AppDbContext>("projectmanagerdb");
builder.Services.AddHostedService<MigrationWorker>();

var host = builder.Build();
host.Run();
