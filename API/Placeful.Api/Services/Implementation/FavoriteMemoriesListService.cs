using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Exceptions;
using Placeful.Api.Models.Exceptions.FavoriteMemoriesListExceptions;
using Placeful.Api.Models.Exceptions.MemoryExceptions;
using Placeful.Api.Models.Exceptions.UserProfileExceptions;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class FavoriteMemoriesListService(PlacefulDbContext context, IHttpContextAccessor httpContextAccessor) : IFavoriteMemoriesListService
{
    public async Task<FavoriteMemoriesList?> GetFavoriteMemoriesListForCurrentUser()
    {
        var userId = GetCurrentUserFirebaseUid();

        var favoriteList = await context.UserProfiles
            .Where(u => u.FirebaseUid == userId)
            .Select(u => new FavoriteMemoriesList
            {
                Id = u.FavoritesMemoriesList!.Id,
                Memories = u.FavoritesMemoriesList.Memories != null
                    ? u.FavoritesMemoriesList.Memories
                        .Select(m => new Memory
                        {
                            Id = m.Id,
                            Title = m.Title,
                            Description = m.Description,
                            ImageUrl = m.ImageUrl,
                            Location = m.Location != null
                                ? new Location
                                {
                                    Id = m.Location.Id,
                                    Latitude = m.Location.Latitude,
                                    Longitude = m.Location.Longitude
                                }
                                : null
                        }).ToList()
                    : new List<Memory>()
            })
            .FirstOrDefaultAsync();

        return favoriteList;
    }

    public async Task AddMemoryToFavoriteMemoriesListForCurrentUser(Guid memoryId)
    {
        var userId = GetCurrentUserFirebaseUid();
        
        var userProfile = await context.UserProfiles
            .Include(u => u.FavoritesMemoriesList)
            .ThenInclude(m => m!.Memories)
            .FirstOrDefaultAsync(u => u.FirebaseUid == userId);
        
        if (userProfile is null) throw new UserProfileNotFoundException(userId);

        var favoriteMemoriesList = userProfile.FavoritesMemoriesList;
        
        if (favoriteMemoriesList is null) throw new FavoriteMemoriesListNotFoundException(userId);
        
        if(favoriteMemoriesList.Memories is null) throw new MemoriesListForFavoriteListNotFoundException(favoriteMemoriesList.Id);

        var memoryFromDb = await context.Memories
            .Include(m => m.Location)
            .FirstOrDefaultAsync(m => m.Id == memoryId);
        
        if (memoryFromDb is null) throw new MemoryNotFoundException(memoryId);
        
        if (favoriteMemoriesList.Memories.Any(m => m.Id == memoryId)) throw new MemoryAlreadyAddedToFavoritesException(memoryId);
        
        userProfile!.FavoritesMemoriesList!.Memories!.Add(memoryFromDb);
        
        await context.SaveChangesAsync();
    }

    public async Task RemoveMemoryFromFavoriteMemoriesListForCurrentUser(Guid memoryId)
    {
        var userId = GetCurrentUserFirebaseUid();
        
        var userProfile = await context.UserProfiles
            .Include(u => u.FavoritesMemoriesList)
            .ThenInclude(m => m!.Memories)
            .FirstOrDefaultAsync(u => u.FirebaseUid == userId);
        
        if (userProfile is null) throw new UserProfileNotFoundException(userId);

        var favoriteMemoriesList = userProfile.FavoritesMemoriesList;
        
        if (favoriteMemoriesList is null) throw new FavoriteMemoriesListNotFoundException(userId);
        
        if(favoriteMemoriesList.Memories is null) throw new MemoriesListForFavoriteListNotFoundException(favoriteMemoriesList.Id);

        var memoryFromDb = await context.Memories
            .Include(m => m.Location)
            .FirstOrDefaultAsync(m => m.Id == memoryId);
        
        if (memoryFromDb is null) throw new MemoryNotFoundException(memoryId);

        if (favoriteMemoriesList.Memories.Contains(memoryFromDb))
        {
            favoriteMemoriesList.Memories.Remove(memoryFromDb);
        }
        else throw new MemoryNotFoundException(memoryId);
        
        await context.SaveChangesAsync();
    }

    public async Task ClearFavoriteMemoriesListForCurrentUser()
    {
        var userId = GetCurrentUserFirebaseUid();

        var userProfile = await context.UserProfiles
            .Include(u => u.FavoritesMemoriesList)
            .ThenInclude(f => f!.Memories)
            .FirstOrDefaultAsync(u => u.FirebaseUid == userId);
        
        if (userProfile is null) throw new UserProfileNotFoundException(userId);
        
        var favoriteMemoriesList = userProfile.FavoritesMemoriesList;
        if (favoriteMemoriesList is null) throw new FavoriteMemoriesListNotFoundException(userId);
        
        userProfile.FavoritesMemoriesList = new FavoriteMemoriesList();
        await context.SaveChangesAsync();
        
        context.FavoriteMemoriesLists.Remove(favoriteMemoriesList);
        await context.SaveChangesAsync();
    }
    
    private String GetCurrentUserFirebaseUid()
    {
        var currentUserUid = httpContextAccessor.HttpContext?.User
            .FindFirstValue(ClaimTypes.NameIdentifier);
        if (currentUserUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");
        
        return currentUserUid;
    }
}