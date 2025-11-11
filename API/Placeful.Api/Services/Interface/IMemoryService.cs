using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IMemoryService
{
    Task<IEnumerable<Memory>> GetMemoriesForCurrentUser(int page = 1, int pageSize = 10, string? searchQuery = null);
    Task<Memory> GetMemory(Guid id);
    Task CreateMemory(MemoryDto memoryDto);
    Task UpdateMemory(MemoryToUpdateDto memoryToUpdateDto);
    Task DeleteMemory(Guid id);
    Task ShareMemory(Guid memoryId, String friendFirebaseUserId);
    Task<IEnumerable<SharedMemoryDto>> ListSharedMemoriesForCurrentUser();
}