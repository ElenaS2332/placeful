namespace Placeful.Api.Models.Exceptions;

public abstract class DomainException(string message, int statusCode) : Exception(message)
{
    public int StatusCode { get; } = statusCode;
}
