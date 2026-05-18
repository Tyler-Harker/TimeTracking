using ProjectManager.Api.Data;
using ProjectManager.MigrationService;

var builder = Host.CreateApplicationBuilder(args);

builder.AddServiceDefaults();

// In hosted environments, allow a single DATABASE_URL (postgres://user:pass@host:port/db?sslmode=...)
// to override the Aspire-provided connection string. Mirrors ProjectManager.Api so the same env var
// works for both deployables. Local AppHost runs are unaffected because DATABASE_URL is not set.
var databaseUrl = Environment.GetEnvironmentVariable("DATABASE_URL");
if (!string.IsNullOrWhiteSpace(databaseUrl))
{
    builder.Configuration["ConnectionStrings:projectmanagerdb"] = ConvertDatabaseUrl(databaseUrl);
}

builder.AddNpgsqlDbContext<AppDbContext>("projectmanagerdb");
builder.Services.AddHostedService<MigrationWorker>();

var host = builder.Build();
host.Run();

static string ConvertDatabaseUrl(string url)
{
    var uri = new Uri(url);
    var userInfo = uri.UserInfo.Split(':', 2);
    var csb = new Npgsql.NpgsqlConnectionStringBuilder
    {
        Host = uri.Host,
        Port = uri.IsDefaultPort ? 5432 : uri.Port,
        Username = Uri.UnescapeDataString(userInfo[0]),
        Password = userInfo.Length > 1 ? Uri.UnescapeDataString(userInfo[1]) : "",
        Database = uri.AbsolutePath.TrimStart('/'),
    };

    foreach (var pair in uri.Query.TrimStart('?').Split('&', StringSplitOptions.RemoveEmptyEntries))
    {
        var kv = pair.Split('=', 2);
        if (kv.Length != 2) continue;
        var key = Uri.UnescapeDataString(kv[0]);
        var value = Uri.UnescapeDataString(kv[1]);
        if (string.Equals(key, "sslmode", StringComparison.OrdinalIgnoreCase)
            && Enum.TryParse<Npgsql.SslMode>(value, ignoreCase: true, out var ssl))
        {
            csb.SslMode = ssl;
        }
    }

    return csb.ToString();
}
