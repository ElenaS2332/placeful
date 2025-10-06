using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface IMemoryService
{
    Task<IEnumerable<Memory>> GetMemories(int page = 1, int pageSize = 10);
    Task<Memory> GetMemory(Guid id);
    Task CreateMemory(Memory memory);
    Task UpdateMemory(Memory memory);
    Task DeleteMemory(Guid id);
}