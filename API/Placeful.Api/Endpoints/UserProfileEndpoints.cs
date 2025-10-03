using AutoMapper;
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
        group.MapGet("", GetUserProfiles).WithName(nameof(GetUserProfiles)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("{userProfileId:guid}", GetUserProfile).WithName(nameof(GetUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("/register", CreateUserProfile).WithName(nameof(CreateUserProfile));
        group.MapPut("", UpdateUserProfile).WithName(nameof(UpdateUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{userProfileId:guid}", DeleteUserProfile).WithName(nameof(DeleteUserProfile)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetUserProfiles(IUserProfileService userProfileService, IMapper mapper)
    {
        var userProfiles = await userProfileService.GetUserProfiles();
        return Results.Ok(mapper.Map<IEnumerable<UserProfileDto>>(userProfiles));
    }
    
    private static async Task<IResult> GetUserProfile(Guid userProfileId, IUserProfileService userProfileService, IMapper mapper)
    {
        try
        {
            return Results.Ok(mapper.Map<UserProfileDto>(await userProfileService.GetUserProfile(userProfileId)));
        }
        catch (Exception ex) // more specific
        {
            return Results.NotFound();
        } 
    }
    
    private static async Task<IResult> CreateUserProfile(UserProfileDto userProfileDto, IUserProfileService userProfileService,
        IMapper mapper)
    {
        var mappedUserProfile = mapper.Map<UserProfile>(userProfileDto);
        await userProfileService.CreateUserProfile(mappedUserProfile);
        return Results.Ok();
    }
    
    private static async Task<IResult> UpdateUserProfile(UserProfileToUpdateDto userProfileToUpdateDto,
        IUserProfileService userProfileService, IMapper mapper)
    {
        try
        {
            await userProfileService.UpdateUserProfile(mapper.Map<UserProfileToUpdateDto, UserProfile>(userProfileToUpdateDto));
            return Results.Ok();
        }
        catch (Exception ex) // more specific exceptions like UserProfileNotFound
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> DeleteUserProfile(Guid userProfileId, IUserProfileService userProfileService)
    {
        try
        {
            await userProfileService.DeleteUserProfile(userProfileId);
            return Results.Ok();
        }
        catch (Exception ex)
        {
            return Results.NotFound();
        }
    }
}