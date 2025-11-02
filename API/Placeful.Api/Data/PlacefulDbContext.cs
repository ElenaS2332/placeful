using Microsoft.EntityFrameworkCore;
using Placeful.Api.Models;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Data;

public class PlacefulDbContext(DbContextOptions<PlacefulDbContext> options) : DbContext(options)
{
    public DbSet<FavoriteMemoriesList> FavoriteMemoriesLists { get; init; }
    public DbSet<Location> Locations { get; init; }
    public DbSet<Memory> Memories { get; init; }
    public DbSet<UserProfile> UserProfiles { get; init; }
    public DbSet<UserFriendship> UserFriendships { get; init; }
    public DbSet<SharedMemory> SharedMemories { get; init; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<UserFriendship>()
            .HasOne(f => f.FriendshipInitiator)
            .WithMany(u => u.SentFriendRequests)
            .HasForeignKey(f => f.FriendshipInitiatorId)
            .HasPrincipalKey(u => u.FirebaseUid)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<UserFriendship>()
            .HasOne(f => f.FriendshipReceiver)
            .WithMany(u => u.ReceivedFriendRequests)
            .HasForeignKey(f => f.FriendshipReceiverId)
            .HasPrincipalKey(u => u.FirebaseUid)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Memory>()
            .HasOne(m => m.Location)
            .WithMany(l => l.Memories)
            .OnDelete(DeleteBehavior.Restrict);
        
        modelBuilder.Entity<SharedMemory>(entity =>
        {
            entity.HasKey(sm => sm.Id);

            entity.HasOne(sm => sm.SharedWithUser)
                .WithMany()
                .HasForeignKey(sm => sm.SharedWithUserId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(sm => sm.SharedFromUser)
                .WithMany()
                .HasForeignKey(sm => sm.SharedFromUserId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}