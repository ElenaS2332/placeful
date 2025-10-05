using AutoMapper;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Enums;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class UserFriendshipEndpoints
{
    public static void MapUserFriendshipEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/user-friendship");
        group.MapGet("/active", ListActiveFriendships).WithName(nameof(ListActiveFriendships)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/requests", ListFriendRequests).WithName(nameof(ListFriendRequests)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/{otherUserUid}", GetFriendship).WithName(nameof(GetFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("/request/{otherUserUid}", RequestFriendship).WithName(nameof(RequestFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPatch("/accept/{otherUserUid}", AcceptFriendship).WithName(nameof(AcceptFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("/remove/{otherUserUid}", DeleteFriendship).WithName(nameof(DeleteFriendship)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("/mutual/{otherUserUid}", GetMutualFriends).WithName(nameof(GetMutualFriends)).RequireAuthorization(AuthPolicy.Authenticated);
    }

    private static async Task<IResult> ListActiveFriendships(IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        var userFriendships = await userFriendshipService.ListCurrentUserActiveFriendships();
        return Results.Ok(mapper.Map<IEnumerable<UserFriendshipDto>>(userFriendships));
    }

    private static async Task<IResult> ListFriendRequests(IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        var userFriendships = await userFriendshipService.ListCurrentUserFriendRequests();
        return Results.Ok(mapper.Map<IEnumerable<UserFriendshipDto>>(userFriendships));
    }

    private static async Task<IResult> GetFriendship(String otherUserUid, IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        var userFriendships = await userFriendshipService.GetFriendshipDetails(otherUserUid);
        return Results.Ok(mapper.Map<IEnumerable<UserFriendshipDto>>(userFriendships));
    }

    private static async Task<IResult> RequestFriendship(String otherUserUid, IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        var userFriendships = await userFriendshipService.RequestFriendship(otherUserUid);
        return Results.Ok(mapper.Map<IEnumerable<UserFriendshipDto>>(userFriendships));
    }

    private static async Task<IResult> AcceptFriendship(String otherUserUid, IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        var userFriendships = await userFriendshipService.AcceptFriendship(otherUserUid);
        return Results.Ok(mapper.Map<IEnumerable<UserFriendshipDto>>(userFriendships));
    }

    private static async Task<IResult> DeleteFriendship(String otherUserUid, IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        await userFriendshipService.DeleteFriendship(otherUserUid);
        return Results.Ok();
    }

    private static async Task<IResult> GetMutualFriends(String otherUserUid, IUserFriendshipService userFriendshipService, IMapper mapper)
    {
        var userFriendships = await userFriendshipService.GetMutualFriends(otherUserUid);
        return Results.Ok(mapper.Map<IEnumerable<UserFriendshipDto>>(userFriendships));
    }
}