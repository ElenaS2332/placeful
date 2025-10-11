using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class FavoriteMemoriesListDto
{
    public String? UserProfileId { get; init; }

    public List<Memory>? Memories { get; set; }
}