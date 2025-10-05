using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Placeful.Api.Models.Entities;
public class UserFriendship
{
    public Guid Id { get; init; }

    [MaxLength(100)]
    public string FriendshipInitiatorId { get; init; } = String.Empty;
    [MaxLength(100)]
    public string FriendshipReceiverId { get; init; } = String.Empty;

    public bool FriendshipAccepted { get; set; }

    [ForeignKey(nameof(FriendshipInitiatorId))]
    public UserProfile? FriendshipInitiator { get; init; }

    [ForeignKey(nameof(FriendshipReceiverId))]
    public UserProfile? FriendshipReceiver { get; init; }
}
