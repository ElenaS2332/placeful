using System.ComponentModel.DataAnnotations;

namespace Placeful.Api.Models.Entities;

public class FavoriteMemoriesList
{
    public Guid Id { get; init; }

    [MaxLength(1000)]
    public String UserProfileId { get; init; } = String.Empty;
    public List<Memory>? Memories { get; init; }
}