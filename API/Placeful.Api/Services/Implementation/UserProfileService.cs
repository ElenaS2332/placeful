using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models;
using Placeful.Api.Models.Entities;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class UserProfileService(PlacefulDbContext context) : IUserProfileService
{
    public async Task<IEnumerable<UserProfile>> GetUserProfiles()
    {
        return await context.UserProfiles
            .ToListAsync();
    }

    public async Task<UserProfile> GetUserProfile(String firebaseUid)
    {
        var userProfile = await context.UserProfiles.FirstOrDefaultAsync(c => c.FirebaseUid.Equals(firebaseUid));

        if (userProfile is null) throw new Exception(); // create specific exceptions

        return userProfile;
    }

    public async Task CreateUserProfile(UserProfile userProfile)
    {
        await context.UserProfiles.AddAsync(userProfile);
        await SaveChanges();
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
        var userProfileToBeDeleted = await GetUserProfile(firebaseUid);

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