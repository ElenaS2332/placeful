using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class UpdateUserProfileDto
{
    public string? Email { get; set; }
    public string? FullName { get; set; }
    public DateTime? BirthDate { get; set; }
}