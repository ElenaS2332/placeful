using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class LocationDto
{
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public IEnumerable<Memory>? Memories { get; set; } = new List<Memory>();
}