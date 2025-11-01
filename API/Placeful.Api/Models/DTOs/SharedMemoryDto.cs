using System.ComponentModel.DataAnnotations;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class SharedMemoryDto
{
    public Guid MemoryId { get; set; }
    public String? FriendFullName { get; set; }
    public string? MemoryTitle { get; set; }
    public string? MemoryDescription { get; set; }
    public DateTime? MemoryDate { get; set; }
    public string? MemoryLocationName { get; init; } 
    public double? MemoryLocationLatitude { get; init; }
    public double? MemoryLocationLongitude { get; init; }
    public string? MemoryImageUrl { get; set; }

    public SharedMemoryDto(SharedMemory memory)
    {
        MemoryId = memory.MemoryId;
        FriendFullName = memory.SharedWithUser?.FullName;
        MemoryTitle = memory.Memory?.Title;
        MemoryDescription = memory.Memory?.Description;
        MemoryDate = memory.Memory?.Date;
        MemoryLocationName = memory.Memory?.Location?.Name;
        MemoryLocationLatitude = memory.Memory?.Location?.Latitude;
        MemoryLocationLongitude = memory.Memory?.Location?.Longitude;
        MemoryImageUrl = memory.Memory?.ImageUrl;
    }
}