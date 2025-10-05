import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/user_friendship_dto.dart';
import 'package:placeful/common/domain/models/user_profile.dart';

part 'user_friendship.g.dart';

@JsonSerializable()
class UserFriendship {
  final UserProfile? friendshipInitiator;
  final UserProfile? friendshipReceiver;
  final String? friendshipInitiatorId;
  final String? friendshipReceiverId;

  final bool friendshipAccepted;

  const UserFriendship({
    this.friendshipInitiator,
    this.friendshipReceiver,
    this.friendshipInitiatorId,
    this.friendshipReceiverId,
    required this.friendshipAccepted,
  });

  UserFriendship.fromDto(UserFriendshipDto dto)
    : friendshipInitiator = dto.friendshipInitiator,
      friendshipInitiatorId = dto.friendshipInitiatorId,
      friendshipReceiver = dto.friendshipReceiver,
      friendshipReceiverId = dto.friendshipReceiverId,
      friendshipAccepted = dto.friendshipAccepted;

  factory UserFriendship.fromJson(Map<String, dynamic> json) =>
      _$UserFriendshipFromJson(json);

  Map<String, dynamic> toJson() => _$UserFriendshipToJson(this);
}
