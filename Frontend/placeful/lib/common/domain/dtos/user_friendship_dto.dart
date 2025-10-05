import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/user_profile.dart';

part 'user_friendship_dto.g.dart';

@JsonSerializable()
class UserFriendshipDto {
  final UserProfile? friendshipInitiator;
  final UserProfile? friendshipReceiver;
  final String? friendshipInitiatorId;
  final String? friendshipReceiverId;

  final bool friendshipAccepted;

  const UserFriendshipDto({
    this.friendshipInitiator,
    this.friendshipReceiver,
    this.friendshipInitiatorId,
    this.friendshipReceiverId,
    required this.friendshipAccepted,
  });

  factory UserFriendshipDto.fromJson(Map<String, dynamic> json) =>
      _$UserFriendshipDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserFriendshipDtoToJson(this);
}
