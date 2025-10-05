using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Enums;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class LocationEndpoints
{
    public static void MapLocationEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/location");
        group.MapGet("", GetLocations).WithName(nameof(GetLocations)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("{locationId:guid}", GetLocation).WithName(nameof(GetLocation)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("", CreateLocation).WithName(nameof(CreateLocation)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{locationId:guid}", DeleteLocation).WithName(nameof(DeleteLocation)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetLocations(ILocationService locationService)
    {
        var locations = await locationService.GetLocations();

        var locationDtos = locations.Select(l => new LocationDto
        {
            Latitude = l.Latitude,
            Longitude = l.Longitude,
            Name = l.Name,
            Memories = l.Memories
        });

        return Results.Ok(locationDtos);
    }
    
    private static async Task<IResult> GetLocation(Guid locationId, ILocationService locationService)
    {
        try
        {
            var location = await locationService.GetLocation(locationId);

            var locationDto = new LocationDto
            {
                Name = location.Name,
                Latitude = location.Latitude,
                Longitude = location.Longitude,
                Memories = location.Memories
            };

            return Results.Ok(locationDto);
        }
        catch (Exception ex) 
        {
            return Results.NotFound();
        } 
    }
    
    private static async Task<IResult> CreateLocation(LocationDto locationDto, ILocationService locationService)
    {
        var location = new Location
        {
            Id = Guid.NewGuid(),
            Name = locationDto.Name,
            Latitude = locationDto.Latitude,
            Longitude = locationDto.Longitude,
            Memories = locationDto.Memories
        };

        var createdLocation = await locationService.CreateLocation(location);

        var createdLocationDto = new LocationDto
        {
            Name = createdLocation.Name,
            Latitude = createdLocation.Latitude,
            Longitude = createdLocation.Longitude,
            Memories = createdLocation.Memories
        };

        return Results.Ok(createdLocationDto);
    }
    
    private static async Task<IResult> DeleteLocation(Guid locationId, ILocationService locationService)
    {
        try
        {
            await locationService.DeleteLocation(locationId);
            return Results.Ok();
        }
        catch (Exception ex)
        {
            return Results.NotFound();
        }
    }
}