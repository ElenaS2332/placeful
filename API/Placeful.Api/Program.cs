using System.Text.Json.Serialization;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Endpoints;
using Placeful.Api.Services.Implementation;
using Placeful.Api.Services.Interface;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<PlacefulDbContext>(options => { options.UseNpgsql(connectionString); });

builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
});

builder.Services.AddScoped<IFavoriteMemoriesListService, FavoriteMemoriesListService>();
builder.Services.AddScoped<ILocationService, LocationService>();
builder.Services.AddScoped<IMemoryService, MemoryService>();
builder.Services.AddScoped<IUserProfileService, UserProfileService>();
builder.Services.AddAutoMapper(cfg => { }, AppDomain.CurrentDomain.GetAssemblies());

var credentials = GoogleCredential.FromFile(builder.Configuration["Firebase:Credentials"]);
FirebaseApp.Create(new AppOptions
{
    Credential = credentials,
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

app.Run();