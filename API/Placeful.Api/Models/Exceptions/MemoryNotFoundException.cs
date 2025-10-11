namespace Placeful.Api.Models.Exceptions;

public class MemoryNotFoundException(Guid memoryId)
    : DomainException($"The memory with ID '{memoryId}' does not exist.", StatusCodes.Status404NotFound);