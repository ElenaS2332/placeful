using Placeful.Api.Models;

namespace Placeful.Models;

public class Memory
{
    public Guid Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public Location Location { get; set; } = new Location();
    public string ImageUrl { get; set; } = string.Empty;
}