using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class MemoryService(PlacefulDbContext context, IHttpContextAccessor httpContextAccessor) : IMemoryService
{
    public async Task<IEnumerable<Memory>> GetMemoriesForCurrentUser(int page = 1, int pageSize = 10)
    {
        var userId = GetCurrentUserFirebaseUid();

        return await context.Memories
            .Where(m => m.UserProfileId == userId)
            .Include(m => m.Location)
            .OrderByDescending(m => m.Date)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<Memory> GetMemory(Guid id)
    {
        var userId = GetCurrentUserFirebaseUid();

        var memory = await context.Memories
            .FirstOrDefaultAsync(c => c.Id == id && c.UserProfileId == userId);

        if (memory is null) throw new Exception();

        return memory;
    }

    public async Task CreateMemory(MemoryDto memoryDto)
    {
        await using var transaction = await context.Database.BeginTransactionAsync();
        
        try
        {
            var location = memoryDto.Location;
            if (memoryDto.Location is not null)
            {
                location = new Location
                {
                    Latitude = memoryDto.Location.Latitude,
                    Longitude = memoryDto.Location.Longitude,
                    Name = memoryDto.Location.Name
                };
                await context.Locations.AddAsync(location);
                await context.SaveChangesAsync();
            }

            var userId = GetCurrentUserFirebaseUid();

            var newMemory = new Memory
            {
                Title = memoryDto.Title,
                Description = memoryDto.Description,
                ImageUrl = memoryDto.ImageUrl,
                Location = location,
                UserProfileId = userId
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
    
    private String GetCurrentUserFirebaseUid()
    {
        var currentUserUid = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (currentUserUid == null)
            throw new UnauthorizedAccessException("User identifier not found in token.");
        
        return currentUserUid;
    }
}