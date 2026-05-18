using System.Net;
using Carter;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Auth.Oidc;

/// <summary>
/// Minimal interactive sign-in page that the OIDC authorize endpoint redirects to
/// when no Identity cookie is present. Existing /api/auth/login JSON endpoint is unaffected.
/// </summary>
public class AccountLogin : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        app.MapGet("/account/login", (string? returnUrl, HttpContext http) =>
        {
            var safeReturn = SafeReturnUrl(returnUrl);
            var html = RenderForm(safeReturn, error: null);
            return Results.Content(html, "text/html");
        })
        .AllowAnonymous()
        .ExcludeFromDescription();

        app.MapPost("/account/login", async (
            HttpContext http,
            UserManager<User> userManager,
            SignInManager<User> signInManager) =>
        {
            var form = await http.Request.ReadFormAsync();
            var email = form["email"].ToString();
            var password = form["password"].ToString();
            var returnUrl = SafeReturnUrl(form["returnUrl"].ToString());

            var user = await userManager.FindByEmailAsync(email);
            if (user is null || !user.IsActive)
                return Results.Content(RenderForm(returnUrl, "Invalid credentials"), "text/html");

            var result = await signInManager.PasswordSignInAsync(user, password, isPersistent: true, lockoutOnFailure: false);
            if (!result.Succeeded)
                return Results.Content(RenderForm(returnUrl, "Invalid credentials"), "text/html");

            return Results.Redirect(returnUrl);
        })
        .AllowAnonymous()
        .ExcludeFromDescription();

        app.MapPost("/account/logout", async (HttpContext http, SignInManager<User> signInManager) =>
        {
            await signInManager.SignOutAsync();
            await http.SignOutAsync();
            return Results.Redirect("/");
        })
        .ExcludeFromDescription();
    }

    private static string SafeReturnUrl(string? returnUrl)
    {
        if (string.IsNullOrWhiteSpace(returnUrl)) return "/";
        // Only allow local redirects to prevent open-redirect via this endpoint.
        return returnUrl.StartsWith('/') && !returnUrl.StartsWith("//") ? returnUrl : "/";
    }

    private static string RenderForm(string returnUrl, string? error)
    {
        var encodedReturn = WebUtility.HtmlEncode(returnUrl);
        var errorBlock = string.IsNullOrEmpty(error)
            ? ""
            : $"<div style=\"color:#b00;margin-bottom:1rem;\">{WebUtility.HtmlEncode(error)}</div>";

        return $$"""
            <!doctype html>
            <html><head><meta charset="utf-8"><title>Sign in</title>
            <style>
              body{font-family:system-ui,sans-serif;background:#f7f7f8;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}
              form{background:#fff;padding:2rem;border-radius:.5rem;box-shadow:0 1px 3px rgba(0,0,0,.1);width:320px}
              h1{margin:0 0 1rem;font-size:1.25rem}
              label{display:block;font-size:.85rem;margin-bottom:.25rem;color:#555}
              input{width:100%;padding:.5rem;margin-bottom:1rem;border:1px solid #ccc;border-radius:.25rem;box-sizing:border-box}
              button{width:100%;padding:.6rem;background:#111;color:#fff;border:0;border-radius:.25rem;font-weight:600;cursor:pointer}
            </style></head>
            <body>
              <form method="post" action="/account/login">
                <h1>Sign in</h1>
                {{errorBlock}}
                <input type="hidden" name="returnUrl" value="{{encodedReturn}}" />
                <label for="email">Email</label>
                <input id="email" name="email" type="email" required autofocus />
                <label for="password">Password</label>
                <input id="password" name="password" type="password" required />
                <button type="submit">Sign in</button>
              </form>
            </body></html>
            """;
    }
}
