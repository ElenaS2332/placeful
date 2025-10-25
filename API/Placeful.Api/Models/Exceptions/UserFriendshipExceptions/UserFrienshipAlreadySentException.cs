namespace Placeful.Api.Models.Exceptions.UserFriendshipExceptions;

public class UserFrienshipAlreadySentException(String currentUserId, String otherUserId)
    : DomainException($"Friend request has already been sent between from user with ID '{currentUserId}' to user with ID '{otherUserId}'.", 
        StatusCodes.Status409Conflict);