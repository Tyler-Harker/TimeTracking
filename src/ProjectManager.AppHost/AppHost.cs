var builder = DistributedApplication.CreateBuilder(args);

var postgres = builder.AddPostgres("postgres")
    .WithLifetime(ContainerLifetime.Persistent)
    .WithPgAdmin();

var db = postgres.AddDatabase("projectmanagerdb");

var migrator = builder.AddProject<Projects.ProjectManager_MigrationService>("migrator")
    .WithReference(db)
    .WaitFor(db);

var api = builder.AddProject<Projects.ProjectManager_Api>("api")
    .WithReference(db)
    .WaitFor(db)
    .WaitFor(migrator)
    // Dev-only admin credentials so e2e tests (and local exploration) can hit
    // /api/admin/* without each developer having to wire user-secrets. Production
    // containers inject real values via env vars and these are ignored.
    .WithEnvironment("Admin__Enabled", "true")
    .WithEnvironment("Admin__Username", "admin")
    .WithEnvironment("Admin__Password", "admin-dev-password");

// Next.js dev server. NEXT_PUBLIC_API_BASE_URL is read by the web client and inlined
// into the browser bundle, so it must be a URL the browser can resolve (not the
// internal service-discovery name). Use the API's http endpoint — present in both
// `http` and `https` launch profiles, whereas the `https` endpoint is only present
// when the https profile is selected (referring to a missing endpoint silently
// breaks resource startup).
builder.AddNpmApp("web", "../project-manager-web", "dev")
    .WithReference(api)
    .WaitFor(api)
    .WithEnvironment("NEXT_PUBLIC_API_BASE_URL", api.GetEndpoint("http"))
    // Pin the external proxy port to 3000 because OpenIddict's `pm-web` client has
    // http://localhost:3000/auth/callback as its registered redirect URI. Aspire
    // assigns a separate random target port for Next.js itself (set via PORT env)
    // so there's no listen-port collision.
    .WithHttpEndpoint(port: 3000, env: "PORT")
    .WithExternalHttpEndpoints();

builder.Build().Run();
