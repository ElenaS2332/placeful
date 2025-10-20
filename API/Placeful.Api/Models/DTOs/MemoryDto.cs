using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class MemoryDto
{
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime? Date { get; init; } = DateTime.UtcNow;

    public double? LocationLatitude { get; set; }
    public double? LocationLongitude { get; set; }
    public string? LocationName { get; set; }

    public string? ImageUrl { get; set; }
    public IFormFile? ImageFile { get; set; }
}