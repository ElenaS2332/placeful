namespace Placeful.Api.Models.Exceptions.MemoryExceptions;

public class MemoryAlreadySharedException(Guid memoryId, Guid userId)
    : DomainException($"The memory with ID '{memoryId}' is already shared with user '{userId}'.", StatusCodes.Status409Conflict);