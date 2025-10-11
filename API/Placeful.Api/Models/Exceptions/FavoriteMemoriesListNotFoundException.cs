namespace Placeful.Api.Models.Exceptions;

public class FavoriteMemoriesListNotFoundException(String userId)
    : DomainException($"Favorite Memories List for user with id {userId} not found.", StatusCodes.Status404NotFound);