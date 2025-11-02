using System.Security.Claims;
using FirebaseAdmin.Auth;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using Placeful.Api.Data;
using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Exceptions.UserProfileExceptions;
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

    private async Task<List<UserProfile>> ListFriendsForUser(string userUid)
    {
        var initiators = await context.UserFriendships
            .Include(f => f.FriendshipInitiator)
            .Where(f => f.FriendshipAccepted && f.FriendshipReceiverId == userUid)
            .Select(f => f.FriendshipInitiator!)
            .ToListAsync();

        var receivers = await context.UserFriendships
            .Include(f => f.FriendshipReceiver)
            .Where(f => f.FriendshipAccepted && f.FriendshipInitiatorId == userUid)
            .Select(f => f.FriendshipReceiver!)
            .ToListAsync();

        return initiators.Concat(receivers).Distinct().ToList();
    }

    public async Task<UserProfile> GetCurrentUserProfile()
    {
        var firebaseUid = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (firebaseUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");

        var userProfile = await context.UserProfiles
            .Where(u => u.FirebaseUid == firebaseUid)
            .Select(u => new UserProfile
            {
                Id = u.Id,
                FirebaseUid = u.FirebaseUid,
                Email = u.Email,
                FavoritesMemoriesList = u.FavoritesMemoriesList,
                FullName = u.FullName,
                BirthDate = u.BirthDate,
                SharedMemories = u.SharedMemories != null
                    ? u.SharedMemories.Select(s => new SharedMemory
                    {
                        Memory = s.Memory,
                        SharedFromUser = s.SharedFromUser == null
                            ? null
                            : new UserProfile
                            {
                                FirebaseUid = s.SharedFromUser.FirebaseUid,
                                Email = s.SharedFromUser.Email,
                                FullName = s.SharedFromUser.FullName
                            }
                    }).ToList()
                    : new List<SharedMemory>(),

                Friends = new List<UserProfile>()
            })
            .FirstOrDefaultAsync();

        if (userProfile is null)
            throw new UserProfileNotFoundException(firebaseUid);

        var friends = await ListFriendsForUser(firebaseUid);

        if (friends.Count > 0)
        {
            userProfile.Friends = friends;
        }

        return userProfile;
    }


    public async Task<UserProfile> GetUserProfile(string firebaseUid)
    {
        var userProfile = await context.UserProfiles
            .Include(u => u.FavoritesMemoriesList)
            .FirstOrDefaultAsync(c => c.FirebaseUid.Equals(firebaseUid));

        if (userProfile is null) throw new UserProfileNotFoundException(firebaseUid);

        return userProfile;
    }

    public async Task CreateUserProfile(UserProfileDto userProfileDto)
    {
        var strategy = context.Database.CreateExecutionStrategy();

        await strategy.ExecuteAsync(async () =>
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
                    SharedMemories = new List<SharedMemory>()
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
        });
    }


    public async Task UpdateUserProfile(UpdateUserProfileDto updateUserProfileDto)
    {
        var firebaseUid = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (firebaseUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");

        var userProfile = await UserProfileExists(firebaseUid);

        if (userProfile is null) throw new UserProfileNotFoundException(firebaseUid);

        if (updateUserProfileDto.FullName is not null)
        {
            userProfile.FullName = updateUserProfileDto.FullName!;
        }

        if (updateUserProfileDto.BirthDate is not null)
        {
            userProfile.BirthDate = updateUserProfileDto.BirthDate.Value.ToUniversalTime();
        }

        if (!string.IsNullOrWhiteSpace(updateUserProfileDto.Email) && updateUserProfileDto.Email != userProfile.Email)
        {
            await FirebaseAuth.DefaultInstance.UpdateUserAsync(new UserRecordArgs()
            {
                Uid = firebaseUid,
                Email = updateUserProfileDto.Email
            });

            userProfile.Email = updateUserProfileDto.Email;
        }

        context.UserProfiles.Update(userProfile);

        await SaveChanges();
    }

    private String GetCurrentUserFirebaseUid()
    {
        var currentUserUid = httpContextAccessor.HttpContext?.User
            .FindFirstValue(ClaimTypes.NameIdentifier);
        if (currentUserUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");

        return currentUserUid;
    }

    public async Task DeleteUserProfile()
    {
        var uid = GetCurrentUserFirebaseUid();
        var user = await context.UserProfiles
            .Include(u => u.FavoritesMemoriesList)
            .FirstOrDefaultAsync(u => u.FirebaseUid == uid);

        if (user == null)
            throw new UserProfileNotFoundException("");

        if (user.FavoritesMemoriesList != null)
        {
            context.FavoriteMemoriesLists.Remove(user.FavoritesMemoriesList);
        }

        var friendshipsInitiator = await context.UserFriendships
            .Where(f => f.FriendshipInitiatorId == user.FirebaseUid)
            .ToListAsync();
        context.UserFriendships.RemoveRange(friendshipsInitiator);

        var friendshipsReceiver = await context.UserFriendships
            .Where(f => f.FriendshipReceiverId == user.FirebaseUid)
            .ToListAsync();
        context.UserFriendships.RemoveRange(friendshipsReceiver);

        var sharedMemories = await context.SharedMemories
            .Where(sm => sm.SharedFromUserId == user.Id || sm.SharedWithUserId == user.Id)
            .ToListAsync();
        context.SharedMemories.RemoveRange(sharedMemories);

        var memories = await context.Memories
            .Where(m => m.UserProfileId == user.FirebaseUid)
            .ToListAsync();
        context.Memories.RemoveRange(memories);

        user.Friends = new List<UserProfile>();
        context.UserProfiles.Remove(user);

        await context.SaveChangesAsync();

        var auth = FirebaseAuth.DefaultInstance;
        await auth.DeleteUserAsync(user.FirebaseUid);
    }


    private async Task<bool> SaveChanges()
    {
        return await context.SaveChangesAsync() >= 0;
    }

    private async Task<UserProfile?> UserProfileExists(String firebaseUid)
    {
        return await context.UserProfiles.FirstOrDefaultAsync(c => c.FirebaseUid == firebaseUid);
    }
}