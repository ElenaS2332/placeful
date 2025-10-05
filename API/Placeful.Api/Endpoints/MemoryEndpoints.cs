using System.Security.Claims;
using Placeful.Api.Models;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;
using Placeful.Api.Models.Enums;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Endpoints;

public static class MemoryEndpoints
{
    public static void MapMemoryEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("api/memory");
        group.MapGet("", GetMemories).WithName(nameof(GetMemories)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("{memoryId:guid}", GetMemory).WithName(nameof(GetMemory)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("", CreateMemory).WithName(nameof(CreateMemory)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPut("", UpdateMemory).WithName(nameof(UpdateMemory)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{memoryId:guid}", DeleteMemory).WithName(nameof(DeleteMemory)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetMemories(IMemoryService memoryService, HttpContext context)
    {
        var memories = await memoryService.GetMemories();

        var memoryDtos = memories.Select(m => new MemoryDto
        {
            Title = m.Title,
            Description = m.Description,
            Date = m.Date ?? DateTime.UtcNow,
            Location = m.Location,
            ImageUrl = m.ImageUrl
        });

        return Results.Ok(memoryDtos);
    }
    
    private static async Task<IResult> GetMemory(Guid memoryId, IMemoryService memoryService)
    {
        try
        {
            var memory = await memoryService.GetMemory(memoryId);

            var memoryDto = new MemoryDto
            {
                Title = memory.Title,
                Description = memory.Description,
                Date = memory.Date ?? DateTime.UtcNow,
                Location = memory.Location,
                ImageUrl = memory.ImageUrl
            };

            return Results.Ok(memoryDto);
        }
        catch (Exception ex) 
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> CreateMemory(MemoryDto memoryDto, IMemoryService memoryService)
    {
        var memory = new Memory
        {
            Title = memoryDto.Title,
            Description = memoryDto.Description,
            Date = memoryDto.Date ?? DateTime.UtcNow,
            Location = memoryDto.Location,
            ImageUrl = memoryDto.ImageUrl
        };

        await memoryService.CreateMemory(memory);

        return Results.Ok();
    }
    
    private static async Task<IResult> UpdateMemory(MemoryToUpdateDto memoryToUpdateDto, IMemoryService memoryService)
    {
        try
        {
            var memory = new Memory
            {
                Title = memoryToUpdateDto.Title,
                Description = memoryToUpdateDto.Description,
                Date = memoryToUpdateDto.Date ?? DateTime.UtcNow,
                Location = memoryToUpdateDto.Location,
                ImageUrl = memoryToUpdateDto.ImageUrl
            };

            await memoryService.UpdateMemory(memory);
            return Results.Ok();
        }
        catch (Exception ex) // more specific exceptions like MemoryNotFound
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> DeleteMemory(Guid memoryId, IMemoryService memoryService)
    {
        try
        {
            await memoryService.DeleteMemory(memoryId);
            return Results.Ok();
        }
        catch (Exception ex)
        {
            return Results.NotFound();
        }
    }
}