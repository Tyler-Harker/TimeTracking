using System.Text.Json;

namespace ProjectManager.Api.Infrastructure.Exceptions;

public class GlobalExceptionHandler(ILogger<GlobalExceptionHandler> logger) : IMiddleware
{
    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        try
        {
            await next(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        var (statusCode, response) = exception switch
        {
            ValidationException validationEx => (422, new
            {
                error = "Validation failed",
                errors = validationEx.Errors
            } as object),
            UnauthorizedAccessException => (401, new
            {
                error = exception.Message
            }),
            ForbiddenException => (403, new
            {
                error = exception.Message
            }),
            KeyNotFoundException => (404, new
            {
                error = exception.Message
            }),
            InvalidOperationException => (400, new
            {
                error = exception.Message
            }),
            _ => (500, new
            {
                error = "An unexpected error occurred"
            } as object)
        };

        if (statusCode == 500)
            logger.LogError(exception, "Unhandled exception");
        else
            logger.LogWarning(exception, "Handled exception: {StatusCode}", statusCode);

        context.Response.StatusCode = statusCode;
        context.Response.ContentType = "application/json";

        await context.Response.WriteAsync(JsonSerializer.Serialize(response, new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        }));
    }
}
