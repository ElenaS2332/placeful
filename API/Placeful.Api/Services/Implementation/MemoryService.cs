using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Exceptions.FavoriteMemoriesListExceptions;
using Placeful.Api.Models.Exceptions.MemoryExceptions;
using Placeful.Api.Models.Exceptions.UserProfileExceptions;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class MemoryService(PlacefulDbContext context,
    IHttpContextAccessor httpContextAccessor,
    IBlobStorageService blobStorageService) : IMemoryService
{
    public async Task<IEnumerable<Memory>> GetMemoriesForCurrentUser(int page = 1, int pageSize = 10)
    {
        var userId = GetCurrentUserFirebaseUid();

        return await context.Memories
            .Where(m => m.UserProfileId == userId)
            .Include(m => m.Location)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<Memory> GetMemory(Guid id)
    {
        var userId = GetCurrentUserFirebaseUid();

        var memory = await context.Memories
            .FirstOrDefaultAsync(c => c.Id == id && c.UserProfileId == userId);

        if (memory is null) throw new MemoryNotFoundException(id);

        return memory;
    }

    public async Task CreateMemory(MemoryDto memoryDto)
    {
        await using var transaction = await context.Database.BeginTransactionAsync();

        try
        {
            if (memoryDto.ImageFile is not null && memoryDto.ImageFile.Length > 0)
            {
                var imageUrl = await blobStorageService.UploadFileAsync(memoryDto.ImageFile);
                memoryDto.ImageUrl = imageUrl;
            }

            var location = new Location();
            if (memoryDto.LocationName is not null &&
                memoryDto.LocationLatitude is not null &&
                memoryDto.LocationLongitude is not null)
            {
                location = new Location
                {
                    Latitude = memoryDto.LocationLatitude.Value,
                    Longitude = memoryDto.LocationLongitude.Value,
                    Name = memoryDto.LocationName,
                };
                await context.Locations.AddAsync(location);
                await context.SaveChangesAsync();
            }

            var userId = GetCurrentUserFirebaseUid();

            var newMemory = new Memory
            {
                Title = memoryDto.Title,
                Description = memoryDto.Description,
                Date = (memoryDto.Date ?? DateTime.UtcNow).ToUniversalTime(),
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

    public async Task UpdateMemory(MemoryToUpdateDto dto)
    {
        // Get the existing memory
        var memory = await context.Memories.FindAsync(dto.Id);
        if (memory == null) throw new KeyNotFoundException("Memory not found");

        // Update fields if provided
        if (!string.IsNullOrEmpty(dto.Title))
            memory.Title = dto.Title;

        if (!string.IsNullOrEmpty(dto.Description))
            memory.Description = dto.Description;

        if (dto.Date.HasValue)
            memory.Date = dto.Date.Value.ToUniversalTime();

        if (dto.Location != null)
            memory.Location = dto.Location;

        if (dto.ImageFile != null)
        {
            memory.ImageUrl = await blobStorageService.UploadFileAsync(dto.ImageFile);
        }
        else if (!string.IsNullOrEmpty(dto.ImageUrl))
        {
            memory.ImageUrl = dto.ImageUrl;
        }

        context.Memories.Update(memory);
        await SaveChanges();
    }

    public async Task DeleteMemory(Guid id)
    {
        var memoryToBeDeleted = await GetMemory(id);

        if (!string.IsNullOrEmpty(memoryToBeDeleted.ImageUrl))
        {
            await blobStorageService.DeleteFileAsync(memoryToBeDeleted.ImageUrl);
        }

        context.Memories.Remove(memoryToBeDeleted);

        await SaveChanges();
    }

    public async Task ShareMemory(Guid memoryId, String friendFirebaseUserId)
    {
        var currentUserId = GetCurrentUserFirebaseUid();
        var currentUser = await context.UserProfiles
            .FirstOrDefaultAsync(u => u.FirebaseUid == currentUserId);
        if (currentUser is null) throw new UserProfileNotFoundException(currentUserId);
        
        var friend = await context.UserProfiles
            .Include(u => u.SharedMemories)
            .FirstOrDefaultAsync(u => u.FirebaseUid == friendFirebaseUserId);

        if (friend == null) throw new UserProfileNotFoundException(friendFirebaseUserId);
        
        var memory = await context.Memories.FindAsync(memoryId);
        if (memory == null) throw new MemoryNotFoundException(memoryId);
        
        var sharedMemoryFromDb = await context.SharedMemories.FirstOrDefaultAsync(
            m => m.MemoryId == memoryId && 
                 m.SharedFromUserId == currentUser.Id &&
                 m.SharedWithUserId == friend.Id);
        
        if (sharedMemoryFromDb is not null) throw new MemoryAlreadySharedException(memoryId, friend.Id);
        
        var sharedMemory = new SharedMemory
        {
            MemoryId = memoryId,
            Memory = memory,
            SharedWithUserId = friend.Id,
            SharedWithUser = friend,
            SharedFromUserId = currentUser.Id,
            SharedFromUser = currentUser
        };
        
        context.SharedMemories.Add(sharedMemory);
        await context.SaveChangesAsync();
        
        if (friend.SharedMemories is null)
        {
            friend.SharedMemories = new List<SharedMemory>();
        }

        friend.SharedMemories.Add(sharedMemory);
        await context.SaveChangesAsync();
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