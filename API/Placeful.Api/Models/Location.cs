
using Placeful.Models;

namespace Placeful.Api.Models;
public class Location
{
    public Guid Id { get; set; }

    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public IEnumerable<Memory> Memories { get; set; } = new List<Memory>();
}