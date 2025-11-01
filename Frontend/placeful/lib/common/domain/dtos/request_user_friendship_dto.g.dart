// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_user_friendship_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUserFriendshipDto _$RequestUserFriendshipDtoFromJson(
  Map<String, dynamic> json,
) => RequestUserFriendshipDto(
  friendshipInitiatorId: json['friendshipInitiatorId'] as String,
  friendshipReceiverId: json['friendshipReceiverId'] as String,
  friendshipAccepted: json['friendshipAccepted'] as bool,
  friendshipInitiatorName: json['friendshipInitiatorName'] as String?,
  friendshipReceiverName: json['friendshipReceiverName'] as String?,
);

Map<String, dynamic> _$RequestUserFriendshipDtoToJson(
  RequestUserFriendshipDto instance,
) => <String, dynamic>{
  'friendshipInitiatorId': instance.friendshipInitiatorId,
  'friendshipInitiatorName': instance.friendshipInitiatorName,
  'friendshipReceiverId': instance.friendshipReceiverId,
  'friendshipReceiverName': instance.friendshipReceiverName,
  'friendshipAccepted': instance.friendshipAccepted,
};
