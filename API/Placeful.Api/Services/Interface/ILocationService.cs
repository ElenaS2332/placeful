using Placeful.Api.Models;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Services.Interface;

public interface ILocationService
{
    Task<IEnumerable<Location>> GetLocations();
    Task<Location> GetLocation(Guid id);
    Task CreateLocation(Location location);
    Task DeleteLocation(Guid id);
}