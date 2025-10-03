
using System.ComponentModel.DataAnnotations;

namespace Placeful.Api.Models.Entities;

public class UserProfile
{
    public Guid Id { get; init; }
    [MaxLength(1000)]
    public string Email { get; init; } = string.Empty;
    [MaxLength(1000)]
    public string FullName { get; init; } = string.Empty;
    public DateTime BirthDate { get; init; } = DateTime.UtcNow;
    public IEnumerable<UserProfile>? Friends { get; init; }
    public FavoriteMemoriesList? FavoritesMemoriesList { get; init; }
}