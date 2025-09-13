using Placeful.Models;

namespace Placeful.Api.Models;

public class FavoriteMemoriesList
{
    public Guid Id { get; set; }
    public Guid UserProfileId { get; set; }
    public Guid MemoryId { get; set; }
    public UserProfile UserProfile { get; set; } = new UserProfile();
    public Memory Memory { get; set; } = new Memory();
}