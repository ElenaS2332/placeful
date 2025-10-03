namespace Placeful.Api.Models.Entities;

public class FavoriteMemoriesList
{
    public Guid Id { get; init; }
    public Guid UserProfileId { get; init; }
    public Guid MemoryId { get; init; }
    public UserProfile? UserProfile { get; set; }
    public Memory? Memory { get; set; }
}