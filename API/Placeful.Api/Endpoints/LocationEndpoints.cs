using AutoMapper;
using Placeful.Api.Models;
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
    
    private static async Task<IResult> GetLocations(ILocationService locationService, IMapper mapper)
    {
        var locations = await locationService.GetLocations();
        return Results.Ok(mapper.Map<IEnumerable<LocationDto>>(locations));
    }
    
    private static async Task<IResult> GetLocation(Guid locationId, ILocationService locationService, IMapper mapper)
    {
        try
        {
            return Results.Ok(mapper.Map<MemoryDto>(await locationService.GetLocation(locationId)));
        }
        catch (Exception ex) // more specific
        {
            return Results.NotFound();
        } 
    }
    
    private static async Task<IResult> CreateLocation(LocationDto locationDto, ILocationService locationService,
        IMapper mapper)
    {
        var mappedLocation = mapper.Map<Location>(locationDto);
        var createdLocation = await locationService.CreateLocation(mappedLocation);
        return Results.Ok(mapper.Map<MemoryDto>(createdLocation));
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