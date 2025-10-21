using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IUserProfileService
{
    Task<IEnumerable<UserProfile>> GetUserProfiles(String? searchQuery);
    Task<UserProfile> GetCurrentUserProfile();
    Task<UserProfile> GetUserProfile(String firebaseUid);
    Task CreateUserProfile(UserProfileDto userProfileDto);
    Task UpdateUserProfile(UpdateUserProfileDto updateUserProfileDto);
    Task DeleteUserProfile(String firebaseUid);
}