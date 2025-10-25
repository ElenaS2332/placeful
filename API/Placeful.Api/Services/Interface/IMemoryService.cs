using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IMemoryService
{
    Task<IEnumerable<Memory>> GetMemoriesForCurrentUser(int page = 1, int pageSize = 10);
    Task<Memory> GetMemory(Guid id);
    Task CreateMemory(MemoryDto memoryDto);
    Task UpdateMemory(MemoryToUpdateDto memoryToUpdateDto);
    Task DeleteMemory(Guid id);
}