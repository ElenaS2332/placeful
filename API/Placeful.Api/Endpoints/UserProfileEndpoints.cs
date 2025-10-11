using Microsoft.AspNetCore.Mvc;
using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Enums;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class UserProfileEndpoints
{
    public static void MapUserProfileEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/user-profile");
        group.MapGet("/all-users", GetUserProfiles).WithName(nameof(GetUserProfiles)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("", GetCurrentUserProfile).WithName(nameof(GetCurrentUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("/register", CreateUserProfile).WithName(nameof(CreateUserProfile));
        group.MapPut("", UpdateUserProfile).WithName(nameof(UpdateUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{userProfileId:guid}", DeleteUserProfile).WithName(nameof(DeleteUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetUserProfiles(
        [FromQuery(Name = "fullName")] string? searchQuery, 
        IUserProfileService userProfileService
    )
    {
        var userProfiles = await userProfileService.GetUserProfiles(searchQuery);

        var userProfilesDto = userProfiles.Select(u => new UserProfileDto
        {
            FirebaseUid = u.FirebaseUid,
            Email = u.Email,
            FullName = u.FullName,
            BirthDate = DateTime.SpecifyKind(u.BirthDate, DateTimeKind.Utc)
            
        }).ToList();

        return Results.Ok(userProfilesDto);
    }

    
    private static async Task<IResult> GetCurrentUserProfile(IUserProfileService userProfileService)
    {
        try
        {
            var currentUser = await userProfileService.GetCurrentUserProfile();

            var currentUserDto = new UserProfileDto
            {
                FirebaseUid = currentUser.FirebaseUid,
                Email = currentUser.Email,
                FullName = currentUser.FullName,
                BirthDate = DateTime.SpecifyKind(currentUser.BirthDate, DateTimeKind.Utc)
            };

            return Results.Ok(currentUserDto);
        }
        catch (Exception ex) // more specific exceptions can be used
        {
            return Results.NotFound();
        }
    }

    
    private static async Task<IResult> CreateUserProfile(UserProfileDto userProfileDto, IUserProfileService userProfileService)
    {
        await userProfileService.CreateUserProfile(userProfileDto);
        return Results.Ok();
    }
    
    

    private static async Task<IResult> UpdateUserProfile(
        UserProfileToUpdateDto userProfileToUpdateDto,
        IUserProfileService userProfileService)
    {
        try
        {
            var updatedProfile = new UserProfile
            {
                Email = userProfileToUpdateDto.Email,
                FullName = userProfileToUpdateDto.FullName,
                BirthDate = DateTime.SpecifyKind(userProfileToUpdateDto.BirthDate, DateTimeKind.Utc)
            };

            await userProfileService.UpdateUserProfile(updatedProfile);
            return Results.Ok();
        }
        catch (Exception ex) // more specific exceptions like UserProfileNotFound
        {
            return Results.NotFound();
        }
    }


    private static async Task<IResult> DeleteUserProfile(String firebaseUid, IUserProfileService userProfileService)
    {
        try
        {
            await userProfileService.DeleteUserProfile(firebaseUid);
            return Results.Ok();
        }
        catch (Exception ex)
        {
            return Results.NotFound();
        }
    }
}