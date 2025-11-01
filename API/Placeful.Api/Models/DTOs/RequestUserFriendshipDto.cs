namespace Placeful.Api.Models.DTOs;

public class RequestUserFriendshipDto
{
    public String FriendshipInitiatorId { get; set; } = String.Empty;
    public String? FriendshipInitiatorName { get; set; } = String.Empty;
    public String FriendshipReceiverId { get; set; } = String.Empty;
    public String? FriendshipReceiverName { get; set; } = String.Empty;
    public bool FriendshipAccepted { get; set; } = false;
}