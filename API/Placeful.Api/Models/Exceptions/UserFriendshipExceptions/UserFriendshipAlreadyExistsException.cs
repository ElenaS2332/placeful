namespace Placeful.Api.Models.Exceptions.UserFriendshipExceptions;

public class UserFriendshipAlreadyExistsException(String currentUserId, String otherUserId)
    : DomainException($"Friendship between user with ID '{currentUserId}' and '{otherUserId}' already exists.", 
        StatusCodes.Status422UnprocessableEntity);