using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class MemoryToUpdateDto
{
    public Guid Id { get; set; }
    public string? Title { get; set; }
    public string? Description { get; set; }
    public DateTime? Date { get; set; }
    public Location? Location { get; set; }
    public IFormFile? ImageFile { get; set; }
    public string? ImageUrl { get; set; }
}
