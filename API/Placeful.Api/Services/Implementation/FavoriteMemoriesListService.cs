using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models;
using Placeful.Api.Models.Entities;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class FavoriteMemoriesListService(PlacefulDbContext context) : IFavoriteMemoriesListService
{
    public async Task<IEnumerable<FavoriteMemoriesList>> GetFavoriteMemoriesLists()
    {
        return await context.FavoriteMemoriesLists
            .ToListAsync();
    }

    public async Task<FavoriteMemoriesList> GetFavoriteMemoriesList(Guid id)
    {
        var favoriteMemoriesList = await context.FavoriteMemoriesLists.FirstOrDefaultAsync(c => c.Id == id);

        if (favoriteMemoriesList is null) throw new Exception(); // create specific exceptions

        return favoriteMemoriesList;
    }

    public async Task<FavoriteMemoriesList> GetFavoriteMemoriesListForUser(Guid userId)
    {
        var favoriteMemoriesList = await context.FavoriteMemoriesLists.FirstOrDefaultAsync(c => c.UserProfileId == userId);

        if (favoriteMemoriesList is null) throw new Exception(); // create specific exceptions

        return favoriteMemoriesList;
    }

    public async Task CreateFavoriteMemoriesList(FavoriteMemoriesList favoriteMemoriesList)
    {
        await context.FavoriteMemoriesLists.AddAsync(favoriteMemoriesList);
        await SaveChanges();
    }

    public async Task UpdateFavoriteMemoriesList(FavoriteMemoriesList favoriteMemoriesList)
    {
        var favoriteMemoriesListExists = await FavoriteMemoriesListExists(favoriteMemoriesList.Id);

        if (!favoriteMemoriesListExists) throw new Exception();

        context.FavoriteMemoriesLists.Update(favoriteMemoriesList);

        await SaveChanges();
    }

    public async Task DeleteFavoriteMemoriesList(Guid id)
    {
        var favoriteMemoriesListToBeDeleted = await GetFavoriteMemoriesList(id);

        context.FavoriteMemoriesLists.Remove(favoriteMemoriesListToBeDeleted);

        await SaveChanges();
    }
    
    private async Task<bool> SaveChanges()
    {
        return await context.SaveChangesAsync() >= 0;
    }
    
    private async Task<bool> FavoriteMemoriesListExists(Guid guid)
    {
        return await context.FavoriteMemoriesLists.AnyAsync(c => c.Id == guid);
    }
}