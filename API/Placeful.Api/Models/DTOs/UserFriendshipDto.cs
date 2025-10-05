using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.DTOs;

public class UserFriendshipDto
{
    public String FriendshipInitiatorId { get; set; } = String.Empty;
    public UserProfile? FriendshipInitiator { get; init; }
    public String FriendshipReceiverId { get; set; } = String.Empty;
    public UserProfile? FriendshipReceiver { get; init; }
    public bool FriendshipAccepted { get; set; } = false;
}