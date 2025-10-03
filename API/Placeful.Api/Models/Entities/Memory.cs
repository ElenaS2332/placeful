using System.ComponentModel.DataAnnotations;

namespace Placeful.Api.Models.Entities;

public class Memory
{
    public Guid Id { get; init; }
    [MaxLength(1000)]
    public string Title { get; set; } = string.Empty;
    [MaxLength(5000)]
    public string Description { get; set; } = string.Empty;
    public Location? Location { get; set; }
    [MaxLength(1000)]
    public string ImageUrl { get; set; } = string.Empty;
}