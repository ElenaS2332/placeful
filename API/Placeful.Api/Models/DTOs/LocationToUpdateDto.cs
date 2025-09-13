using Placeful.Models;

namespace Placeful.Api.Models.DTOs;

public class LocationToUpdateDto
{
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public IEnumerable<Memory> Memories { get; set; } = new List<Memory>();
}