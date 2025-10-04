using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class MemoryDto
{
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime? Date { get; init; } = DateTime.UtcNow;
    public Location? Location { get; set; } = new Location();
    public string? ImageUrl { get; set; }
}