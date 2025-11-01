using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Enums;
using Placeful.Api.Models.Exceptions;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class UserFriendshipEndpoints
{
    public static void MapUserFriendshipEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/user-friendship");
        group.MapGet("/active", ListActiveFriendships).WithName(nameof(ListActiveFriendships)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/requests", ListFriendRequests).WithName(nameof(ListFriendRequests)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/requests/count", GetCountForCurrentUserFriendRequests).WithName(nameof(GetCountForCurrentUserFriendRequests)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/{otherUserUid}", GetFriendship).WithName(nameof(GetFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("/request/{otherUserUid}", RequestFriendship).WithName(nameof(RequestFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPatch("/accept/{otherUserUid}", AcceptFriendship).WithName(nameof(AcceptFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("/remove/{otherUserUid}", DeleteFriendship).WithName(nameof(DeleteFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/mutual/{otherUserUid}", GetMutualFriends).WithName(nameof(GetMutualFriends)).RequireAuthorization(AuthPolicy.Authenticated);
    }

    private static async Task<IResult> ListActiveFriendships(IUserFriendshipService userFriendshipService)
    {
        var userFriendships = await userFriendshipService.ListCurrentUserActiveFriendships();

        var dtos = userFriendships.Select(f => new UserFriendshipDto
        {
            FriendshipInitiatorId = f.FriendshipInitiatorId,
            FriendshipReceiverId = f.FriendshipReceiverId,
            FriendshipAccepted = f.FriendshipAccepted,
            FriendshipInitiator = f.FriendshipInitiator,
            FriendshipReceiver = f.FriendshipReceiver
        });

        return Results.Ok(dtos);
    }


    private static async Task<IResult> ListFriendRequests(IUserFriendshipService userFriendshipService)
    {
        var userFriendships = await userFriendshipService.ListCurrentUserFriendRequests();

        var dtos = userFriendships.Select(f => new UserFriendshipDto
        {
            FriendshipInitiatorId = f.FriendshipInitiatorId,
            FriendshipReceiverId = f.FriendshipReceiverId,
            FriendshipAccepted = f.FriendshipAccepted,
            FriendshipInitiator = f.FriendshipInitiator,
            FriendshipReceiver = f.FriendshipReceiver
        });

        return Results.Ok(dtos);
    }

    private static async Task<IResult> GetCountForCurrentUserFriendRequests(IUserFriendshipService userFriendshipService)
    {
        var count = await userFriendshipService.GetCountForCurrentUserFriendRequests();
        return Results.Ok(count);
    }

    private static async Task<IResult> GetFriendship(
        string otherUserUid,
        IUserFriendshipService userFriendshipService
    )
    {
        var userFriendship = await userFriendshipService.GetFriendshipDetails(otherUserUid);

        var dto = new UserFriendshipDto
        {
            FriendshipInitiatorId = userFriendship.FriendshipInitiatorId,
            FriendshipReceiverId = userFriendship.FriendshipReceiverId,
            FriendshipAccepted = userFriendship.FriendshipAccepted,
            FriendshipInitiator = userFriendship.FriendshipInitiator,
            FriendshipReceiver = userFriendship.FriendshipReceiver
        };

        return Results.Ok(dto);
    }

    private static async Task<IResult> RequestFriendship(
        string otherUserUid,
        IUserFriendshipService userFriendshipService
    )
    {
        try
        {
            var dto = await userFriendshipService.RequestFriendship(otherUserUid);
            return Results.Ok(dto);
        }
        catch (DomainException ex)
        {
            return Results.Problem(
                title: "Friendship Request Error",
                detail: ex.Message,
                statusCode: ex.StatusCode
            );
        }
        catch (Exception ex)
        {
            return Results.Problem(
                title: "Unexpected Error",
                detail: ex.Message,
                statusCode: StatusCodes.Status500InternalServerError
            );
        }
    }

    private static async Task<IResult> AcceptFriendship(
        string otherUserUid,
        IUserFriendshipService userFriendshipService
    )
    {
        var userFriendship = await userFriendshipService.AcceptFriendship(otherUserUid);

        var dto = new UserFriendshipDto
        {
            FriendshipInitiatorId = userFriendship.FriendshipInitiatorId,
            FriendshipReceiverId = userFriendship.FriendshipReceiverId,
            FriendshipAccepted = userFriendship.FriendshipAccepted,
            FriendshipInitiator = userFriendship.FriendshipInitiator,
            FriendshipReceiver = userFriendship.FriendshipReceiver
        };

        return Results.Ok(dto);
    }


    private static async Task<IResult> DeleteFriendship(String otherUserUid, IUserFriendshipService userFriendshipService)
    {
        await userFriendshipService.DeleteFriendship(otherUserUid);
        return Results.Ok();
    }

    private static async Task<IResult> GetMutualFriends(
        string otherUserUid,
        IUserFriendshipService userFriendshipService
    )
    {
        var mutualFriends = await userFriendshipService.GetMutualFriends(otherUserUid);

        var mutualFriendsDto = mutualFriends.Select(u => new UserProfileDto
        {
            FirebaseUid = u.FirebaseUid,
            FullName = u.FullName,
            Email = u.Email,
            BirthDate = DateTime.SpecifyKind(u.BirthDate, DateTimeKind.Utc)
        }).ToList();

        return Results.Ok(mutualFriendsDto);
    }

}