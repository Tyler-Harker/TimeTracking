namespace ProjectManager.Api.Infrastructure.Auth;

public class AdminSettings
{
    public const string SectionName = "Admin";

    public bool Enabled { get; set; }
    public string Username { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public int TokenExpirationMinutes { get; set; } = 30;
}
