
namespace Placeful.Api.Models;

public class UserProfile
{
    public Guid Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public DateTime BirthDate { get; set; } = DateTime.MinValue;
    public IEnumerable<UserProfile> Friends { get; set; } = new List<UserProfile>();
    public FavoriteMemoriesList FavoritesMemoriesList { get; set; } = new FavoriteMemoriesList();
}