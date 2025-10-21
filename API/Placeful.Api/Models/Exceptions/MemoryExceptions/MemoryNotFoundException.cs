namespace Placeful.Api.Models.Exceptions.MemoryExceptions;

public class MemoryNotFoundException(Guid memoryId)
    : DomainException($"The memory with ID '{memoryId}' does not exist.", StatusCodes.Status404NotFound);