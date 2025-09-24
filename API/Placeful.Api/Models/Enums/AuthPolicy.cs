namespace Placeful.Api.Models.Enums;

public class AuthPolicy
{
    public const string Authenticated = "authenticated";
    public const string Admin = "admin";
    public const string Maintainer = "maintainer";
    public const string AdminOrMaintainer = "adminOrMaintainer";
    public const string User = "user";
    public const string BearerOrApiKey = "bearerOrApiKey";
}
