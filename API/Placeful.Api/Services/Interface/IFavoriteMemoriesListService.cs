using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IFavoriteMemoriesListService
{
    Task<FavoriteMemoriesList?> GetFavoriteMemoriesListForCurrentUser();
    Task AddMemoryToFavoriteMemoriesListForCurrentUser(Guid memoryId);
    Task RemoveMemoryFromFavoriteMemoriesListForCurrentUser(Guid memoryId);

    Task ClearFavoriteMemoriesListForCurrentUser();
}