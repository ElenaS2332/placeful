
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Placeful.Api.Models.Entities;

public class UserProfile
{
    public Guid Id { get; init; }
    [MaxLength(1000)]
    public String FirebaseUid { get; init; } = String.Empty;
    [MaxLength(1000)]
    public string Email { get; set; } = string.Empty;
    [MaxLength(1000)]
    public string FullName { get; set; } = string.Empty;
    public DateTime BirthDate { get; set; } = DateTime.UtcNow;
    
    [NotMapped]
    public ICollection<UserProfile>? Friends { get; set; }
    public FavoriteMemoriesList? FavoritesMemoriesList { get; set; }
    public ICollection<UserFriendship>? SentFriendRequests { get; set; }
    public ICollection<UserFriendship>? ReceivedFriendRequests { get; set; }
    public ICollection<SharedMemory>? SharedMemories { get; set; }
}