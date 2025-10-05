using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IUserFriendshipService
{
    public Task<List<UserFriendship>> ListCurrentUserActiveFriendships();
    public Task<List<UserFriendship>> ListActiveFriendshipsForUser(string userUid);
    public Task<List<UserFriendship>> ListCurrentUserFriendRequests();
    public Task<UserFriendship> GetFriendshipDetails(String otherUserUid);
    public Task<UserFriendship> RequestFriendship(String otherUserUid);
    public Task<UserFriendship> AcceptFriendship(String otherUserUid);
    public Task DeleteFriendship(String otherUserUid);
    public Task<List<UserProfile>> GetMutualFriends(String otherUserUid);
}