using System.Security.Claims;
using AutoMapper;
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
    
    private static async Task<IResult> GetMemories(IMemoryService memoryService, IMapper mapper, HttpContext context)
    {
        var memories = await memoryService.GetMemories();
        return Results.Ok(mapper.Map<IEnumerable<MemoryDto>>(memories));
    }
    
    private static async Task<IResult> GetMemory(Guid memoryId, IMemoryService memoryService, IMapper mapper)
    {
        try
        {
            return Results.Ok(mapper.Map<MemoryDto>(await memoryService.GetMemory(memoryId)));
        }
        catch (Exception ex) // more specific
        {
            return Results.NotFound();
        } 
    }
    
    private static async Task<IResult> CreateMemory(MemoryDto memoryDto, IMemoryService memoryService,
        IMapper mapper)
    {
        var mappedMemory = mapper.Map<Memory>(memoryDto);
        await memoryService.CreateMemory(mappedMemory);
        return Results.Ok();
    }
    
    private static async Task<IResult> UpdateMemory(MemoryToUpdateDto memoryToUpdateDto,
        IMemoryService memoryService, IMapper mapper)
    {
        try
        {
            await memoryService.UpdateMemory(mapper.Map<MemoryToUpdateDto, Memory>(memoryToUpdateDto));
            return Results.Ok();
        }
        catch (Exception ex) // more specific exceptions like UserProfileNotFound
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