namespace Placeful.Api.Models.Exceptions;

public class UserProfileNotFoundException(string userId)
    : DomainException($"User profile with ID '{userId}' not found.", StatusCodes.Status404NotFound);