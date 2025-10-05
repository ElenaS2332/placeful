using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Enums;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class FavoriteMemoriesListEndpoints
{
    public static void MapFavoriteMemoriesListEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/favorite-memories-list");
        group.MapGet("", GetFavoriteMemoriesLists).WithName(nameof(GetFavoriteMemoriesLists)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("{favoriteMemoriesListId:guid}", GetFavoriteMemoriesList).WithName(nameof(GetFavoriteMemoriesList)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("", CreateFavoriteMemoriesList).WithName(nameof(CreateFavoriteMemoriesList)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPut("", UpdateFavoriteMemoriesList).WithName(nameof(UpdateFavoriteMemoriesList)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{favoriteMemoriesListId:guid}", DeleteFavoriteMemoriesList).WithName(nameof(DeleteFavoriteMemoriesList)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetFavoriteMemoriesLists(IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        var favoriteMemoriesLists = await favoriteMemoriesListService.GetFavoriteMemoriesLists();
        return Results.Ok(favoriteMemoriesLists.Select(f => new FavoriteMemoriesListDto
        {
            UserProfileId = f.UserProfileId,
            MemoryId = f.MemoryId,
            UserProfile = f.UserProfile,
            Memory = f.Memory
        }));
    }
    
    private static async Task<IResult> GetFavoriteMemoriesList(
        Guid favoriteMemoriesListId,
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            var favoriteMemoriesList = await favoriteMemoriesListService.GetFavoriteMemoriesList(favoriteMemoriesListId);

            var dto = new FavoriteMemoriesListDto
            {
                UserProfileId = favoriteMemoriesList.UserProfileId,
                MemoryId = favoriteMemoriesList.MemoryId,
                UserProfile = favoriteMemoriesList.UserProfile,
                Memory = favoriteMemoriesList.Memory
            };

            return Results.Ok(dto);
        }
        catch (Exception)
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> CreateFavoriteMemoriesList(
        FavoriteMemoriesListDto favoriteMemoriesListDto,
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        var favoriteMemoriesList = new FavoriteMemoriesList
        {
            UserProfileId = favoriteMemoriesListDto.UserProfileId,
            MemoryId = favoriteMemoriesListDto.MemoryId,
            UserProfile = favoriteMemoriesListDto.UserProfile,
            Memory = favoriteMemoriesListDto.Memory
        };

        await favoriteMemoriesListService.CreateFavoriteMemoriesList(favoriteMemoriesList);
        return Results.Ok();
    }

    
    private static async Task<IResult> UpdateFavoriteMemoriesList(
        FavoriteMemoriesListToUpdateDto favoriteMemoriesListToUpdateDto,
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            var favoriteMemoriesList = new FavoriteMemoriesList
            {
                UserProfileId = favoriteMemoriesListToUpdateDto.UserProfileId,
                MemoryId = favoriteMemoriesListToUpdateDto.MemoryId,
                UserProfile = favoriteMemoriesListToUpdateDto.UserProfile,
                Memory = favoriteMemoriesListToUpdateDto.Memory
            };

            await favoriteMemoriesListService.UpdateFavoriteMemoriesList(favoriteMemoriesList);
            return Results.Ok();
        }
        catch (Exception ex) // TODO: handle more specific exceptions
        {
            return Results.NotFound();
        }
    }


    private static async Task<IResult> DeleteFavoriteMemoriesList(
        Guid favoriteMemoriesListId,
        IFavoriteMemoriesListService favoriteMemoriesListService)
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