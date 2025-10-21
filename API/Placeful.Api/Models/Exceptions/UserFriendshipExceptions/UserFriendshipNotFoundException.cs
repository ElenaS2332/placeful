namespace Placeful.Api.Models.Exceptions.UserFriendshipExceptions;

public class UserFriendshipNotFoundException(String currentUserId, String otherUserId)
    : DomainException($"Friendship between user with ID '{currentUserId}' and '{otherUserId}' does not exist.", 
        StatusCodes.Status404NotFound);