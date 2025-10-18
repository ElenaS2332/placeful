
using System.ComponentModel.DataAnnotations;

namespace Placeful.Api.Models.Entities;

public class UserProfile
{
    public Guid Id { get; init; }
    [MaxLength(1000)]
    public String FirebaseUid { get; init; } = String.Empty;
    [MaxLength(1000)]
    public string Email { get; init; } = string.Empty;
    [MaxLength(1000)]
    public string FullName { get; init; } = string.Empty;
    public DateTime BirthDate { get; init; } = DateTime.UtcNow;
    public ICollection<UserProfile>? Friends { get; set; }
    public FavoriteMemoriesList? FavoritesMemoriesList { get; set; }
    public ICollection<UserFriendship>? SentFriendRequests { get; set; }
    public ICollection<UserFriendship>? ReceivedFriendRequests { get; set; }
}