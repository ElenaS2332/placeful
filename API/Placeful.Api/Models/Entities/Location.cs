
using System.ComponentModel.DataAnnotations;

namespace Placeful.Api.Models.Entities;
public class Location
{
    public Guid Id { get; init; }
    [MaxLength(1000)]
    public string Name { get; init; } = string.Empty;
    public double Latitude { get; init; }
    public double Longitude { get; init; }
    public IEnumerable<Memory>? Memories { get; set; }
}