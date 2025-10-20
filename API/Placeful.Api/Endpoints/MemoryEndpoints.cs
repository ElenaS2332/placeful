using Microsoft.AspNetCore.Mvc;
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
        group.MapGet("", GetMemoriesForCurrentUser).WithName(nameof(GetMemoriesForCurrentUser)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapGet("{memoryId:guid}", GetMemory).WithName(nameof(GetMemory)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPost("", CreateMemory).WithName(nameof(CreateMemory)).DisableAntiforgery().RequireAuthorization(AuthPolicy.Authenticated);
        group.MapPut("", UpdateMemory).WithName(nameof(UpdateMemory)).RequireAuthorization(AuthPolicy.Authenticated);
        group.MapDelete("{memoryId:guid}", DeleteMemory).WithName(nameof(DeleteMemory)).RequireAuthorization(AuthPolicy.Authenticated);
    }
    
    private static async Task<IResult> GetMemoriesForCurrentUser(
        [FromQuery] int page,
        [FromQuery] int pageSize,
        IMemoryService memoryService, 
        HttpContext context)
    {
        var memories = await memoryService.GetMemoriesForCurrentUser(page, pageSize);
        return Results.Ok(memories);
    }
    
    private static async Task<IResult> GetMemory(Guid memoryId, IMemoryService memoryService)
    {
        try
        {
            var memory = await memoryService.GetMemory(memoryId);
            return Results.Ok(memory);
        }
        catch (Exception ex) 
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> CreateMemory([FromForm] MemoryDto memoryDto, IMemoryService memoryService)
    {
        await memoryService.CreateMemory(memoryDto);

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