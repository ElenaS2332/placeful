namespace Placeful.Api.Models.Exceptions.LocationExceptions;

public class LocationNotFoundException(Guid locationId)
    : DomainException($"Location with ID '{locationId}' not found.", StatusCodes.Status404NotFound);