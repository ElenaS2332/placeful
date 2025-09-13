using Microsoft.EntityFrameworkCore;
using Placeful.Api.Models;
using Placeful.Models;

namespace Placeful.Api.Data;

public class PlacefulDbContext(DbContextOptions<PlacefulDbContext> options) : DbContext(options)
{
    public DbSet<FavoritesList> FavoritesLists { get; init; }
    public DbSet<Location> Locations { get; init; }
    public DbSet<Memory> Memories { get; init; }
    public DbSet<UserProfile> UserProfiles { get; init; }
    
}