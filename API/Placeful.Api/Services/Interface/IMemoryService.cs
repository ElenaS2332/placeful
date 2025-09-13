using Placeful.Models;

namespace Placeful.Api.Services.Interface;

public interface IMemoryService
{
    Task<IEnumerable<Memory>> GetMemories();
    Task<Memory> GetMemory(Guid id);
    Task CreateMemory(Memory memory);
    Task UpdateMemory(Memory memory);
    Task DeleteMemory(Guid id);
}