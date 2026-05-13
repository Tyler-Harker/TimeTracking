using System.Text;
using System.Text.Json.Serialization;
using Carter;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using ProjectManager.Api.Data;
using ProjectManager.Api.Data.Entities;
using ProjectManager.Api.Infrastructure.Auth;
using ProjectManager.Api.Infrastructure.Behaviors;
using ProjectManager.Api.Infrastructure.Exceptions;
using ProjectManager.Api.Infrastructure.MultiTenancy;

var builder = WebApplication.CreateBuilder(args);

// 1. Aspire service defaults
builder.AddServiceDefaults();

// 2. EF Core + PostgreSQL via Aspire
// In hosted environments, allow a single DATABASE_URL (postgres://user:pass@host:port/db?sslmode=...)
// to override the Aspire-provided connection string. Local AppHost runs ignore this.
var databaseUrl = Environment.GetEnvironmentVariable("DATABASE_URL");
if (!string.IsNullOrWhiteSpace(databaseUrl))
{
    builder.Configuration["ConnectionStrings:projectmanagerdb"] = ConvertDatabaseUrl(databaseUrl);
}
builder.AddNpgsqlDbContext<AppDbContext>("projectmanagerdb");

// 3. Identity
builder.Services.AddIdentity<User, IdentityRole<Guid>>(options =>
    {
        options.Password.RequireDigit = true;
        options.Password.RequireLowercase = true;
        options.Password.RequireUppercase = true;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequiredLength = 8;
        options.User.RequireUniqueEmail = true;
    })
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

// 4. JWT + Admin
var jwtSettings = builder.Configuration.GetSection(JwtSettings.SectionName).Get<JwtSettings>()!;
builder.Services.Configure<JwtSettings>(builder.Configuration.GetSection(JwtSettings.SectionName));
builder.Services.Configure<AdminSettings>(builder.Configuration.GetSection(AdminSettings.SectionName));

builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtSettings.Issuer,
            ValidAudience = jwtSettings.Audience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.Secret)),
            ClockSkew = TimeSpan.Zero
        };
    });

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("Admin", policy =>
        policy.RequireAuthenticatedUser()
              .RequireClaim("admin", "true"));
});

// 5. Multi-tenancy
builder.Services.AddScoped<ICurrentOrganizationService, CurrentOrganizationService>();

// 6. Services
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IJwtService, JwtService>();

// 7. MediatR + FluentValidation
builder.Services.AddMediatR(cfg =>
{
    cfg.RegisterServicesFromAssemblyContaining<Program>();
    cfg.AddOpenBehavior(typeof(ValidationBehavior<,>));
});
builder.Services.AddValidatorsFromAssemblyContaining<Program>();

// 8. JSON serialization
builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.Converters.Add(new JsonStringEnumConverter());
});

// 9. Carter
builder.Services.AddCarter();
builder.Services.AddCors();

// 9. Exception handler
builder.Services.AddScoped<GlobalExceptionHandler>();

// 10. OpenAPI + Swagger
builder.Services.AddOpenApi();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.OpenApiInfo
    {
        Title = "ProjectManager API",
        Version = "v1",
        Description = "Project management API with time tracking and invoicing"
    });

    options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = Microsoft.OpenApi.SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = Microsoft.OpenApi.ParameterLocation.Header,
        Description = "Enter your JWT token"
    });

    options.AddSecurityRequirement(_ =>
    {
        var requirement = new Microsoft.OpenApi.OpenApiSecurityRequirement();
        var schemeRef = new Microsoft.OpenApi.OpenApiSecuritySchemeReference("Bearer");
        requirement.Add(schemeRef, new List<string>());
        return requirement;
    });

    options.CustomSchemaIds(type =>
    {
        if (type.DeclaringType is null)
            return type.Name;
        var parentName = type.DeclaringType.Name;
        return $"{parentName}{type.Name}";
    });
});

var app = builder.Build();

// Middleware pipeline
app.MapDefaultEndpoints();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "ProjectManager API v1");
    });
}

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    dbContext.Database.Migrate();
}

app.UseMiddleware<GlobalExceptionHandler>();
app.UseCors(b => b
    .AllowAnyHeader()
    .AllowAnyMethod()
    .AllowCredentials()
    .WithOrigins("http://localhost:3000", "https://timetracking.harker.dev"));
app.UseAuthentication();
app.UseAuthorization();
app.UseMiddleware<OrganizationMiddleware>();
app.MapCarter();

app.Run();

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

public partial class Program;
