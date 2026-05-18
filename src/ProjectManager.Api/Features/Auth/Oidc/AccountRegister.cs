using System.Net;
using Carter;
using Microsoft.AspNetCore.Identity;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Features.Auth.Oidc;

/// <summary>
/// Interactive sign-up page served by the API as part of the OIDC flow. Mirrors
/// /account/login: GET renders an HTML form, POST creates the user, signs them in
/// (sets the Identity cookie), and redirects to the OIDC authorize URL captured in
/// returnUrl so the rest of the flow continues seamlessly.
/// </summary>
public class AccountRegister : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        app.MapGet("/account/register", (string? returnUrl) =>
        {
            var safeReturn = SafeReturnUrl(returnUrl);
            var html = RenderForm(safeReturn, fields: new FormFields(), error: null);
            return Results.Content(html, "text/html");
        })
        .AllowAnonymous()
        .ExcludeFromDescription();

        app.MapPost("/account/register", async (
            HttpContext http,
            UserManager<User> userManager,
            SignInManager<User> signInManager) =>
        {
            var form = await http.Request.ReadFormAsync();
            var fields = new FormFields
            {
                Email = form["email"].ToString().Trim(),
                FirstName = form["firstName"].ToString().Trim(),
                LastName = form["lastName"].ToString().Trim(),
            };
            var password = form["password"].ToString();
            var returnUrl = SafeReturnUrl(form["returnUrl"].ToString());

            if (string.IsNullOrWhiteSpace(fields.Email)
                || string.IsNullOrWhiteSpace(fields.FirstName)
                || string.IsNullOrWhiteSpace(fields.LastName)
                || string.IsNullOrEmpty(password))
            {
                return Results.Content(
                    RenderForm(returnUrl, fields, "All fields are required."),
                    "text/html");
            }

            var existing = await userManager.FindByEmailAsync(fields.Email);
            if (existing is not null)
            {
                return Results.Content(
                    RenderForm(returnUrl, fields, "An account with that email already exists."),
                    "text/html");
            }

            var user = new User
            {
                UserName = fields.Email,
                Email = fields.Email,
                FirstName = fields.FirstName,
                LastName = fields.LastName,
            };

            var result = await userManager.CreateAsync(user, password);
            if (!result.Succeeded)
            {
                var message = string.Join(" ", result.Errors.Select(e => e.Description));
                return Results.Content(RenderForm(returnUrl, fields, message), "text/html");
            }

            await signInManager.SignInAsync(user, isPersistent: true);
            return Results.Redirect(returnUrl);
        })
        .AllowAnonymous()
        .ExcludeFromDescription();
    }

    private record FormFields
    {
        public string Email { get; init; } = string.Empty;
        public string FirstName { get; init; } = string.Empty;
        public string LastName { get; init; } = string.Empty;
    }

    private static string SafeReturnUrl(string? returnUrl)
    {
        if (string.IsNullOrWhiteSpace(returnUrl)) return "/";
        // Only allow local redirects to prevent open-redirect via this endpoint.
        return returnUrl.StartsWith('/') && !returnUrl.StartsWith("//") ? returnUrl : "/";
    }

    private static string RenderForm(string returnUrl, FormFields fields, string? error)
    {
        var encodedReturn = WebUtility.HtmlEncode(returnUrl);
        var encodedEmail = WebUtility.HtmlEncode(fields.Email);
        var encodedFirst = WebUtility.HtmlEncode(fields.FirstName);
        var encodedLast = WebUtility.HtmlEncode(fields.LastName);
        var loginHref = "/account/login?returnUrl=" + WebUtility.UrlEncode(returnUrl);
        var errorBlock = string.IsNullOrEmpty(error)
            ? ""
            : $"<div style=\"color:#b00;margin-bottom:1rem;font-size:.9rem;\">{WebUtility.HtmlEncode(error)}</div>";

        return $$"""
            <!doctype html>
            <html><head><meta charset="utf-8"><title>Create account</title>
            <style>
              body{font-family:system-ui,sans-serif;background:#f7f7f8;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}
              form{background:#fff;padding:2rem;border-radius:.5rem;box-shadow:0 1px 3px rgba(0,0,0,.1);width:360px}
              h1{margin:0 0 1rem;font-size:1.25rem}
              label{display:block;font-size:.85rem;margin-bottom:.25rem;color:#555}
              input{width:100%;padding:.5rem;margin-bottom:1rem;border:1px solid #ccc;border-radius:.25rem;box-sizing:border-box}
              button{width:100%;padding:.6rem;background:#111;color:#fff;border:0;border-radius:.25rem;font-weight:600;cursor:pointer}
              .row{display:grid;grid-template-columns:1fr 1fr;gap:.75rem}
              .row > div{margin:0}
              .footer{margin-top:1rem;font-size:.85rem;color:#555;text-align:center}
              .footer a{color:#111;text-decoration:underline}
            </style></head>
            <body>
              <form method="post" action="/account/register">
                <h1>Create your account</h1>
                {{errorBlock}}
                <input type="hidden" name="returnUrl" value="{{encodedReturn}}" />
                <div class="row">
                  <div>
                    <label for="firstName">First name</label>
                    <input id="firstName" name="firstName" type="text" required value="{{encodedFirst}}" autofocus />
                  </div>
                  <div>
                    <label for="lastName">Last name</label>
                    <input id="lastName" name="lastName" type="text" required value="{{encodedLast}}" />
                  </div>
                </div>
                <label for="email">Email</label>
                <input id="email" name="email" type="email" required value="{{encodedEmail}}" />
                <label for="password">Password</label>
                <input id="password" name="password" type="password" required minlength="8" />
                <button type="submit">Create account</button>
                <div class="footer">Already have an account? <a href="{{loginHref}}">Sign in</a></div>
              </form>
            </body></html>
            """;
    }
}
