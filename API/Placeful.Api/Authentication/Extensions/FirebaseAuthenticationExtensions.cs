using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

namespace Placeful.Api.Authentication.Extensions;

public static class FirebaseAuthenticationExtensions
{
    public static AuthenticationBuilder AddFirebaseAuthentication(
        this IServiceCollection services,
        string projectId)
    {
        var authority = $"https://securetoken.google.com/{projectId}";

        return services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.Authority = authority;
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidIssuer = authority,
                    ValidateAudience = true,
                    ValidAudience = projectId,
                    ValidateLifetime = true
                };
            });
    }
}