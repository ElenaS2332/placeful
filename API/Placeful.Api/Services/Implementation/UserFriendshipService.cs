using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Exceptions.UserFriendshipExceptions;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class UserFriendshipService(PlacefulDbContext context, IUserProfileService userProfileService, IHttpContextAccessor httpContextAccessor) : IUserFriendshipService
{
    public async Task<List<UserFriendship>> ListCurrentUserActiveFriendships()
    {
        var currentUserUid = GetCurrentUserFirebaseUid();

        return await context.UserFriendships
            .Include(f => f.FriendshipInitiator)
            .Include(f => f.FriendshipReceiver)
            .Where(f => f.FriendshipAccepted == true &&
                        (f.FriendshipInitiatorId.Equals(currentUserUid) ||
                         f.FriendshipReceiverId.Equals(currentUserUid)))
            .ToListAsync();
    }

    public async Task<List<UserFriendship>> ListActiveFriendshipsForUser(string userUid)
    {
        return await context.UserFriendships
            .Where(f => f.FriendshipAccepted == true &&
                        (f.FriendshipInitiatorId.Equals(userUid) ||
                         f.FriendshipReceiverId.Equals(userUid)))
            .ToListAsync();
    }

    public async Task<List<UserFriendship>> ListCurrentUserFriendRequests()
    {
        var currentUserUid = GetCurrentUserFirebaseUid();

        return await context.UserFriendships
            .Include(f => f.FriendshipInitiator)
            .Include(f => f.FriendshipReceiver)
            .Where(f => f.FriendshipAccepted == false &&
                        f.FriendshipReceiverId.Equals(currentUserUid))
            .ToListAsync();
    }
    
    public async Task<int> GetCountForCurrentUserFriendRequests()
    {
        var currentUserUid = GetCurrentUserFirebaseUid();

        return await context.UserFriendships
            .Where(f => f.FriendshipAccepted == false &&
                        f.FriendshipReceiverId.Equals(currentUserUid))
            .CountAsync();
    }

    public async Task<UserFriendship> GetFriendshipDetails(String otherUserUid)
    {
        var currentUserUid = GetCurrentUserFirebaseUid();
        var friendship = await GetFriendship(currentUserUid, otherUserUid);

        if (friendship == null)
        {
            throw new UserFriendshipNotFoundException(currentUserUid, otherUserUid);
        }

        return friendship;
    }

    private async Task<UserFriendship?> GetFriendship(string userAId, string userBId)
    {
        var friendship = await context.UserFriendships
            .Include(f => f.FriendshipInitiator)
            .ThenInclude(i => i!.FavoritesMemoriesList)
            .Include(f => f.FriendshipReceiver)
            .ThenInclude(r => r!.FavoritesMemoriesList)
            .FirstOrDefaultAsync(f =>
                (f.FriendshipInitiatorId == userAId && f.FriendshipReceiverId == userBId) ||
                (f.FriendshipInitiatorId == userBId && f.FriendshipReceiverId == userAId));
        return friendship;
    }


    public async Task<UserFriendship> RequestFriendship(String otherUserUid)
    {
        var currentUserUid = GetCurrentUserFirebaseUid();
        var friendship = await GetFriendship(currentUserUid, otherUserUid);

        if (friendship is not null && friendship.FriendshipAccepted) throw new UserFriendshipAlreadyExistsException(currentUserUid, otherUserUid);
        if (friendship is not null && !friendship.FriendshipAccepted)throw new UserFrienshipAlreadySentException(currentUserUid, otherUserUid);
        
        UserProfile initiator = await userProfileService.GetUserProfile(currentUserUid);
        UserProfile receiver = await userProfileService.GetUserProfile(otherUserUid);
        
        var newFriendship = new UserFriendship
        {
            FriendshipInitiatorId = initiator!.FirebaseUid,
            FriendshipReceiverId = receiver!.FirebaseUid,
            FriendshipAccepted = false,
            FriendshipInitiator = initiator,
            FriendshipReceiver = receiver,
        };
        await context.UserFriendships.AddAsync(newFriendship);
        await context.SaveChangesAsync();
        return newFriendship;
    }

    public async Task<UserFriendship> AcceptFriendship(String otherUserUid)
    {
        var currentUserUid = GetCurrentUserFirebaseUid();

        var friendship = await GetFriendship(currentUserUid, otherUserUid);

        if (friendship is null) throw new UserFriendshipNotFoundException(currentUserUid, otherUserUid);

        friendship.FriendshipAccepted = true;
        context.UserFriendships.Update(friendship);

        UserProfile currentUser = friendship.FriendshipReceiver!;
        UserProfile otherUser = friendship.FriendshipInitiator!;

        if (currentUser.Friends is null)
        {
            currentUser.Friends = new List<UserProfile>();
        }
        currentUser.Friends.Add(otherUser);

        if (otherUser.Friends is null)
        {
            otherUser.Friends = new List<UserProfile>();
        }
        otherUser.Friends.Add(currentUser);

        await context.SaveChangesAsync();

        return friendship;
    }

    public async Task DeleteFriendship(String otherUserUid)
    {
        var currentUserUid = GetCurrentUserFirebaseUid();

        var friendship = await GetFriendship(currentUserUid, otherUserUid);

        if (friendship is null) throw new UserFriendshipNotFoundException(currentUserUid, otherUserUid);

        UserProfile currentUser = await userProfileService.GetUserProfile(currentUserUid);
        UserProfile otherUser = await userProfileService.GetUserProfile(otherUserUid);

        if (currentUser.Friends is not null && currentUser.Friends.Contains(otherUser))
        {
            currentUser.Friends.Remove(otherUser);
        }

        if (otherUser.Friends is not null && otherUser.Friends.Contains(currentUser))
        {
            otherUser.Friends.Remove(currentUser);
        }
        context.UserFriendships.Remove(friendship);
        
        await context.SaveChangesAsync();
    }

    public async Task<List<UserProfile>> GetMutualFriends(string otherUserUid)
    {
        var currentUserUid = GetCurrentUserFirebaseUid();
        var requesterFriendships = await ListActiveFriendshipsForUser(currentUserUid);
        var receiverFriendships = await ListActiveFriendshipsForUser(otherUserUid);

        var requesterFriendIds = requesterFriendships
            .Select(f => GetOtherProfileId(f, currentUserUid))
            .ToHashSet();

        var receiverFriendIds = receiverFriendships
            .Select(f => GetOtherProfileId(f, otherUserUid))
            .ToHashSet();

        var mutualFriendIds = requesterFriendIds.Intersect(receiverFriendIds);

        var profiles = await Task.WhenAll(
            mutualFriendIds.Select(userProfileService.GetUserProfile)
        );

        return profiles.ToList();
    }

    private string GetOtherProfileId(UserFriendship friendship, string id)
    {
        return friendship.FriendshipInitiatorId == id
            ? friendship.FriendshipReceiverId
            : friendship.FriendshipInitiatorId;
    }

    private String GetCurrentUserFirebaseUid()
    {
        var currentUserUid = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (currentUserUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");

        return currentUserUid;
    }
}