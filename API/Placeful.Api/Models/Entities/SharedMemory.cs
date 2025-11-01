namespace Placeful.Api.Models.Entities;

public class SharedMemory
{
    public Guid Id { get; set; }

    public Guid MemoryId { get; set; }
    public Memory? Memory { get; set; }

    public Guid SharedWithUserId { get; set; } 
    public UserProfile? SharedWithUser { get; set; }
    
    public Guid SharedFromUserId { get; set; } 
    public UserProfile? SharedFromUser { get; set; }

    public DateTime SharedAt { get; set; } = DateTime.UtcNow;
}