namespace Placeful.Api.Models.Exceptions;

public class MemoriesListForFavoriteListNotFoundException(Guid favoriteMemoriesListId)
    : DomainException($"Memories List for Favorite Memories List with ID '{favoriteMemoriesListId}' does not exist.",
        StatusCodes.Status404NotFound);
