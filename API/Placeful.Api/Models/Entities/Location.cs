
namespace Placeful.Api.Models.Entities;
public class Location
{
    public Guid Id { get; init; }

    public double Latitude { get; init; }
    public double Longitude { get; init; }
    public IEnumerable<Memory>? Memories { get; set; }
}