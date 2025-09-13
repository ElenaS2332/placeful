using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Services.Interface;
using Placeful.Models;

namespace Placeful.Api.Services.Implementation;

public class MemoryService(PlacefulDbContext context) : IMemoryService
{
    public async Task<IEnumerable<Memory>> GetMemories()
    {
        return await context.Memories
            .ToListAsync();
    }

    public async Task<Memory> GetMemory(Guid id)
    {
        var memory = await context.Memories.FirstOrDefaultAsync(c => c.Id == id);

        if (memory is null) throw new Exception(); // create specific exceptions

        return memory;
    }

    public async Task CreateMemory(Memory memory)
    {
        await context.Memories.AddAsync(memory);
        await SaveChanges();
    }

    public async Task UpdateMemory(Memory memory)
    {
        var memoryExists = await MemoryExists(memory.Id);

        if (!memoryExists) throw new Exception();

        context.Memories.Update(memory);

        await SaveChanges();
    }

    public async Task DeleteMemory(Guid id)
    {
        var memoryToBeDeleted = await GetMemory(id);

        context.Memories.Remove(memoryToBeDeleted);

        await SaveChanges();
    }
    
    private async Task<bool> SaveChanges()
    {
        return await context.SaveChangesAsync() >= 0;
    }
    
    private async Task<bool> MemoryExists(Guid guid)
    {
        return await context.Memories.AnyAsync(c => c.Id == guid);
    }
}