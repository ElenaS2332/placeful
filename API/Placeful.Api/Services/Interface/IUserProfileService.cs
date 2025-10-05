using Placeful.Api.Models;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IUserProfileService
{
    Task<IEnumerable<UserProfile>> GetUserProfiles();
    Task<UserProfile> GetCurrentUserProfile();
    Task<UserProfile> GetUserProfile(String firebaseUid);
    Task CreateUserProfile(UserProfile userProfile);
    Task UpdateUserProfile(UserProfile userProfile);
    Task DeleteUserProfile(String firebaseUid);
}