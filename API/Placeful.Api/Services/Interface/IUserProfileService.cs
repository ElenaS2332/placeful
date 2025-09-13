using Placeful.Api.Models;

namespace Placeful.Api.Services.Interface;

public interface IUserProfileService
{
    Task<IEnumerable<UserProfile>> GetUserProfiles();
    Task<UserProfile> GetUserProfile(Guid id);
    Task CreateUserProfile(UserProfile userProfile);
    Task UpdateUserProfile(UserProfile userProfile);
    Task DeleteUserProfile(Guid id);
}