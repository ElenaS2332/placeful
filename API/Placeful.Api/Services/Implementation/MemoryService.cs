using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models.Entities;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class MemoryService(PlacefulDbContext context) : IMemoryService
{
    public async Task<IEnumerable<Memory>> GetMemories()
    {
        return await context.Memories
            .Include(m => m.Location)
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
        await using var transaction = await context.Database.BeginTransactionAsync();

        try
        {
            var location = memory.Location;
            if (memory.Location is not null)
            {
                location = new Location
                {
                    Latitude = memory.Location.Latitude,
                    Longitude = memory.Location.Longitude,
                    Name = memory.Location.Name
                };
                await context.Locations.AddAsync(location);
                await context.SaveChangesAsync();
            }

            var newMemory = new Memory
            {
                Title = memory.Title,
                Description = memory.Description,
                ImageUrl = memory.ImageUrl,
                Location = location
            };
            await context.Memories.AddAsync(newMemory);
            await context.SaveChangesAsync();

            await transaction.CommitAsync();
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
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