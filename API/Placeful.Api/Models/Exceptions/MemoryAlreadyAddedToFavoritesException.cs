namespace Placeful.Api.Models.Exceptions;

public class MemoryAlreadyAddedToFavoritesException(Guid memoryId)
    : DomainException($"The memory with ID '{memoryId}' is already added to the favorites list.", StatusCodes.Status409Conflict);