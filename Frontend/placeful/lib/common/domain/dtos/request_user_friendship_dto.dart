import 'package:json_annotation/json_annotation.dart';

part 'request_user_friendship_dto.g.dart';

@JsonSerializable()
class RequestUserFriendshipDto {
  final String friendshipInitiatorId;
  final String? friendshipInitiatorName;
  final String friendshipReceiverId;
  final String? friendshipReceiverName;
  final bool friendshipAccepted;

  RequestUserFriendshipDto({
    required this.friendshipInitiatorId,
    required this.friendshipReceiverId,
    required this.friendshipAccepted,
    this.friendshipInitiatorName,
    this.friendshipReceiverName,
  });

  factory RequestUserFriendshipDto.fromJson(Map<String, dynamic> json) =>
      _$RequestUserFriendshipDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUserFriendshipDtoToJson(this);
}
