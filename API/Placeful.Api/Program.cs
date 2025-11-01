using System.Text.Json.Serialization;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Authentication.Extensions;
using Placeful.Api.Data;
using Placeful.Api.Endpoints;
using Placeful.Api.Models.Enums;
using Placeful.Api.Services.Implementation;
using Placeful.Api.Services.Interface;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<PlacefulDbContext>(options =>
{
    options.UseNpgsql(connectionString)
        .EnableSensitiveDataLogging()  
        .LogTo(Console.WriteLine, Microsoft.Extensions.Logging.LogLevel.Information);
    
    options.UseNpgsql(connectionString, npgsqlOptions =>
    {
        npgsqlOptions.EnableRetryOnFailure(
            maxRetryCount: 3,
            maxRetryDelay: TimeSpan.FromSeconds(5),
            errorCodesToAdd: null
        );
    });

});

builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
});

builder.Services.AddScoped<IFavoriteMemoriesListService, FavoriteMemoriesListService>();
builder.Services.AddScoped<ILocationService, LocationService>();
builder.Services.AddScoped<IMemoryService, MemoryService>();
builder.Services.AddScoped<IUserProfileService, UserProfileService>();
builder.Services.AddScoped<IUserFriendshipService, UserFriendshipService>();
builder.Services.AddScoped<IBlobStorageService, BlobStorageService>();
builder.Services.AddSingleton<BlobStorageService>();
builder.Services.AddHttpContextAccessor();

var credentials = GoogleCredential.FromFile(builder.Configuration["Firebase:Credentials"]);
FirebaseApp.Create(new AppOptions
{
    Credential = credentials,
});

builder.Services.AddFirebaseAuthentication(builder.Configuration["Firebase:ProjectId"]!);
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy(AuthPolicy.Authenticated, policy =>
    {
        policy.RequireAuthenticatedUser();
    });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapFavoriteMemoriesListEndpoints();
app.MapLocationEndpoints();
app.MapMemoryEndpoints();
app.MapUserProfileEndpoints();
app.MapUserFriendshipEndpoints();
app.UseAuthentication();
app.UseAuthorization();
app.UseCors("AllowAll");

app.Run();