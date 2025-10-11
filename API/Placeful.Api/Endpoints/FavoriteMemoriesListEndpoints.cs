using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Enums;
using Placeful.Api.Models.Exceptions;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class FavoriteMemoriesListEndpoints
{
    public static void MapFavoriteMemoriesListEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/favorite-memories-list");
        group.MapGet("", GetFavoriteMemoriesListForCurrentUser).WithName(nameof(GetFavoriteMemoriesListForCurrentUser)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPut("{memoryId:guid}", AddMemoryToFavoriteMemoriesListForCurrentUser).WithName(nameof(AddMemoryToFavoriteMemoriesListForCurrentUser)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{memoryId:guid}", RemoveMemoryFromFavoriteMemoriesListForCurrentUser).WithName(nameof(RemoveMemoryFromFavoriteMemoriesListForCurrentUser)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("/all", ClearFavoriteMemoriesListForCurrentUser).WithName(nameof(ClearFavoriteMemoriesListForCurrentUser)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetFavoriteMemoriesListForCurrentUser(
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            var favoriteMemoriesListDto = await favoriteMemoriesListService.GetFavoriteMemoriesListForCurrentUser();
            
            return Results.Ok(favoriteMemoriesListDto);
        }
        catch (Exception)
        {
            return Results.NotFound();
        }
    }
    private static async Task<IResult> AddMemoryToFavoriteMemoriesListForCurrentUser(
        Guid memoryId,
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            await favoriteMemoriesListService.AddMemoryToFavoriteMemoriesListForCurrentUser(memoryId);
            return Results.Ok(new { message = "Memory successfully added to favorites." });
        }
        catch (DomainException ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: ex.StatusCode);
        }
        catch (Exception ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: 500);
        }
    }

    private static async Task<IResult> RemoveMemoryFromFavoriteMemoriesListForCurrentUser(
        Guid memoryId,
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            await favoriteMemoriesListService.RemoveMemoryFromFavoriteMemoriesListForCurrentUser(memoryId);
            return Results.Ok();
        }
        catch (DomainException ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: ex.StatusCode);
        }
        catch (Exception ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: 500);
        }
    }
    
    private static async Task<IResult> ClearFavoriteMemoriesListForCurrentUser(
        IFavoriteMemoriesListService favoriteMemoriesListService)
    {
        try
        {
            await favoriteMemoriesListService.ClearFavoriteMemoriesListForCurrentUser();
            return Results.Ok();
        }
        catch (DomainException ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: ex.StatusCode);
        }
        catch (Exception ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: 500);
        }
    }

}