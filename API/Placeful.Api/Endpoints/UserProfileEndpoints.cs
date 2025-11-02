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
        group.MapDelete("", DeleteUserProfile).WithName(nameof(DeleteUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
    }

    private static async Task<IResult> GetUserProfiles(
        [FromQuery(Name = "fullName")] string? searchQuery,
        IUserProfileService userProfileService
    )
    {
        var userProfiles = await userProfileService.GetUserProfiles(searchQuery);

        return Results.Ok(userProfiles);
    }


    private static async Task<IResult> GetCurrentUserProfile(IUserProfileService userProfileService)
    {
        try
        {
            var currentUser = await userProfileService.GetCurrentUserProfile();

            return Results.Ok(currentUser);
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
        UpdateUserProfileDto updateUserProfileDto,
        IUserProfileService userProfileService)
    {
        try
        {
            await userProfileService.UpdateUserProfile(updateUserProfileDto);
            return Results.Ok();
        }
        catch (Exception ex) // more specific exceptions like UserProfileNotFound
        {
            return Results.NotFound();
        }
    }


    private static async Task<IResult> DeleteUserProfile(IUserProfileService userProfileService)
    {
        try
        {
            await userProfileService.DeleteUserProfile();
            return Results.Ok();
        }
        catch (Exception ex)
        {
            return Results.NotFound();
        }
    }
}