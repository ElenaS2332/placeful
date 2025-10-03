using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class UserProfileDto
{
    public string Email { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public DateTime BirthDate { get; set; } = DateTime.UtcNow;
}