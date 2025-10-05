// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFriendship _$UserFriendshipFromJson(Map<String, dynamic> json) =>
    UserFriendship(
      friendshipInitiator:
          json['friendshipInitiator'] == null
              ? null
              : UserProfile.fromJson(
                json['friendshipInitiator'] as Map<String, dynamic>,
              ),
      friendshipReceiver:
          json['friendshipReceiver'] == null
              ? null
              : UserProfile.fromJson(
                json['friendshipReceiver'] as Map<String, dynamic>,
              ),
      friendshipInitiatorId: json['friendshipInitiatorId'] as String?,
      friendshipReceiverId: json['friendshipReceiverId'] as String?,
      friendshipAccepted: json['friendshipAccepted'] as bool,
    );

Map<String, dynamic> _$UserFriendshipToJson(UserFriendship instance) =>
    <String, dynamic>{
      'friendshipInitiator': instance.friendshipInitiator,
      'friendshipReceiver': instance.friendshipReceiver,
      'friendshipInitiatorId': instance.friendshipInitiatorId,
      'friendshipReceiverId': instance.friendshipReceiverId,
      'friendshipAccepted': instance.friendshipAccepted,
    };
