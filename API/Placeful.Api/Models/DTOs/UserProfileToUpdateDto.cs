using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class UserProfileToUpdateDto
{
    public string Email { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public DateTime BirthDate { get; set; } = DateTime.UtcNow;
    public IEnumerable<UserProfile>? Friends { get; set; } = new List<UserProfile>();
    public FavoriteMemoriesList? FavoritesMemoriesList { get; set; } = new FavoriteMemoriesList();
}