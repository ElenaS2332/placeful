using AutoMapper;
using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class FavoriteMemoriesListEndpoints
{
    public static void MapFavoriteMemoriesListEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/favorite-memories-list");
        group.MapGet("", GetFavoriteMemoriesLists).WithName(nameof(GetFavoriteMemoriesLists));
        group.MapGet("{favoriteMemoriesListId:guid}", GetFavoriteMemoriesList).WithName(nameof(GetFavoriteMemoriesList));
        group.MapPost("", CreateFavoriteMemoriesList).WithName(nameof(CreateFavoriteMemoriesList));
        group.MapPut("", UpdateFavoriteMemoriesList).WithName(nameof(UpdateFavoriteMemoriesList));
        group.MapDelete("{favoriteMemoriesListId:guid}", DeleteFavoriteMemoriesList).WithName(nameof(DeleteFavoriteMemoriesList));
    }
    
    private static async Task<IResult> GetFavoriteMemoriesLists(IFavoriteMemoriesListService favoriteMemoriesListService, IMapper mapper)
    {
        var favoriteMemoriesLists = await favoriteMemoriesListService.GetFavoriteMemoriesLists();
        return Results.Ok(mapper.Map<IEnumerable<MemoryDto>>(favoriteMemoriesLists));
    }
    
    private static async Task<IResult> GetFavoriteMemoriesList(Guid favoriteMemoriesListId, IFavoriteMemoriesListService favoriteMemoriesListService, IMapper mapper)
    {
        try
        {
            return Results.Ok(mapper.Map<MemoryDto>(await favoriteMemoriesListService.GetFavoriteMemoriesList(favoriteMemoriesListId)));
        }
        catch (Exception ex) // more specific
        {
            return Results.NotFound();
        } 
    }
    
    private static async Task<IResult> CreateFavoriteMemoriesList(FavoriteMemoriesListDto favoriteMemoriesListDto, IFavoriteMemoriesListService favoriteMemoriesListService,
        IMapper mapper)
    {
        var mappedFavoriteMemoriesList = mapper.Map<FavoriteMemoriesList>(favoriteMemoriesListDto);
        await favoriteMemoriesListService.CreateFavoriteMemoriesList(mappedFavoriteMemoriesList);
        return Results.Ok();
    }
    
    private static async Task<IResult> UpdateFavoriteMemoriesList(FavoriteMemoriesListToUpdateDto favoriteMemoriesListToUpdateDto,
        IFavoriteMemoriesListService favoriteMemoriesListService, IMapper mapper)
    {
        try
        {
            await favoriteMemoriesListService.UpdateFavoriteMemoriesList(mapper.Map<FavoriteMemoriesListToUpdateDto, FavoriteMemoriesList>(favoriteMemoriesListToUpdateDto));
            return Results.Ok();
        }
        catch (Exception ex) // more specific exceptions like UserProfileNotFound
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> DeleteFavoriteMemoriesList(Guid favoriteMemoriesListId, IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            await favoriteMemoriesListService.DeleteFavoriteMemoriesList(favoriteMemoriesListId);
            return Results.Ok();
        }
        catch (Exception ex)
        {
            return Results.NotFound();
        }
    }
}