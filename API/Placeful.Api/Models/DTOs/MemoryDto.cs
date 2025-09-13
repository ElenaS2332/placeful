namespace Placeful.Api.Models.DTOs;

public class MemoryDto
{
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public Location Location { get; set; } = new Location();
    public string ImageUrl { get; set; } = string.Empty;
}