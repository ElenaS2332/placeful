using Placeful.Api.Models;

namespace Placeful.Api.Services.Interface;

public interface IFavoriteMemoriesListService
{
    Task<IEnumerable<FavoriteMemoriesList>> GetFavoriteMemoriesLists();
    Task<FavoriteMemoriesList> GetFavoriteMemoriesList(Guid id);
    Task<FavoriteMemoriesList> GetFavoriteMemoriesListForUser(Guid userId);
    Task CreateFavoriteMemoriesList(FavoriteMemoriesList favoriteMemoriesList);
    Task UpdateFavoriteMemoriesList(FavoriteMemoriesList favoriteMemoriesList);
    Task DeleteFavoriteMemoriesList(Guid id);
}