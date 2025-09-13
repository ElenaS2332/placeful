using Microsoft.EntityFrameworkCore;
using Placeful.Api.Data;
using Placeful.Api.Models;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class LocationService(PlacefulDbContext context) : ILocationService
{
    public async Task<IEnumerable<Location>> GetLocations()
    {
        return await context.Locations
            .ToListAsync();
    }

    public async Task<Location> GetLocation(Guid id)
    {
        var location = await context.Locations.FirstOrDefaultAsync(c => c.Id == id);

        if (location is null) throw new Exception(); // create specific exceptions

        return location;
    }

    public async Task CreateLocation(Location location)
    {
        await context.Locations.AddAsync(location);
        await SaveChanges();
    }

    public async Task DeleteLocation(Guid id)
    {
        var locationToBeDeleted = await GetLocation(id);

        context.Locations.Remove(locationToBeDeleted);

        await SaveChanges();
    }
    
    private async Task<bool> SaveChanges()
    {
        return await context.SaveChangesAsync() >= 0;
    }
    
    private async Task<bool> LocationExists(Guid guid)
    {
        return await context.UserProfiles.AnyAsync(c => c.Id == guid);
    }
}