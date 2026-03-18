var builder = DistributedApplication.CreateBuilder(args);

var postgres = builder.AddPostgres("postgres")
.WithLifetime(ContainerLifetime.Persistent)
    .WithPgAdmin();

var db = postgres.AddDatabase("projectmanagerdb");

var migrator = builder.AddProject<Projects.ProjectManager_MigrationService>("migrator")
    .WithReference(db)
    .WaitFor(db);

builder.AddProject<Projects.ProjectManager_Api>("api")
    .WithReference(db)
    .WaitFor(db)
    .WaitFor(migrator);

builder.Build().Run();
