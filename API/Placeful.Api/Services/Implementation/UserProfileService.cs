using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class UserProfileService(PlacefulDbContext context, IHttpContextAccessor httpContextAccessor) : IUserProfileService
{
    public async Task<IEnumerable<UserProfile>> GetUserProfiles(String? searchQuery)
    {
        var query = context.UserProfiles.AsQueryable();
        
        if (!string.IsNullOrWhiteSpace(searchQuery))
        {
            var lowerQuery = searchQuery.ToLower();
            query = query.Where(u => u.FullName.ToLower().Contains(lowerQuery));
        }
        
        return await query.ToListAsync();
    }

    public async Task<UserProfile> GetCurrentUserProfile()
    {
        var firebaseUid = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (firebaseUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");

        var userProfile = await context.UserProfiles
            .Include(u => u.Friends)
            .FirstOrDefaultAsync(c => c.FirebaseUid.Equals(firebaseUid));

        if (userProfile is null) throw new Exception(); // create specific exceptions

        return userProfile;
    }

    public async Task<UserProfile> GetUserProfile(string firebaseUid)
    {
        var userProfile = await context.UserProfiles
            .Include(u => u.FavoritesMemoriesList)
            .Include(u => u.Friends)
            .FirstOrDefaultAsync(c => c.FirebaseUid.Equals(firebaseUid));

        if (userProfile is null) throw new Exception(); // create specific exceptions

        return userProfile;
    }

    public async Task CreateUserProfile(UserProfileDto userProfileDto)
    {
        await using var transaction = await context.Database.BeginTransactionAsync();

        try
        {
            var newFavoriteMemoriesList = new FavoriteMemoriesList
            {
                UserProfileId = userProfileDto.FirebaseUid,
                Memories = new List<Memory>()
            };

            await context.FavoriteMemoriesLists.AddAsync(newFavoriteMemoriesList);
            await context.SaveChangesAsync();
            
            var newUserProfile = new UserProfile
            {
                FirebaseUid = userProfileDto.FirebaseUid,
                Email = userProfileDto.Email,
                FullName = userProfileDto.FullName,
                BirthDate = DateTime.SpecifyKind(userProfileDto.BirthDate, DateTimeKind.Utc),
                FavoritesMemoriesList = newFavoriteMemoriesList,
            };
        
            await context.UserProfiles.AddAsync(newUserProfile);
            await context.SaveChangesAsync();
            
            await transaction.CommitAsync();
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    public async Task UpdateUserProfile(UserProfile userProfile)
    {
        var userProfileExists = await UserProfileExists(userProfile.Id);

        if (!userProfileExists) throw new Exception();

        context.UserProfiles.Update(userProfile);

        await SaveChanges();
    }

    public async Task DeleteUserProfile(String firebaseUid)
    {
        var userProfileToBeDeleted = await GetCurrentUserProfile();

        context.UserProfiles.Remove(userProfileToBeDeleted);

        await SaveChanges();
    }
    
    private async Task<bool> SaveChanges()
    {
        return await context.SaveChangesAsync() >= 0;
    }
    
    private async Task<bool> UserProfileExists(Guid guid)
    {
        return await context.UserProfiles.AnyAsync(c => c.Id == guid);
    }
}