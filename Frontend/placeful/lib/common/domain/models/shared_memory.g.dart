// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedMemory _$SharedMemoryFromJson(Map<String, dynamic> json) => SharedMemory(
  id: json['id'] as String,
  memoryId: json['memoryId'] as String,
  sharedFromUserId: json['sharedFromUserId'] as String,
  sharedWithUserId: json['sharedWithUserId'] as String,
  memory:
      json['memory'] == null
          ? null
          : Memory.fromJson(json['memory'] as Map<String, dynamic>),
  sharedFromUser:
      json['sharedFromUser'] == null
          ? null
          : UserProfile.fromJson(
            json['sharedFromUser'] as Map<String, dynamic>,
          ),
  sharedWithUser:
      json['sharedWithUser'] == null
          ? null
          : UserProfile.fromJson(
            json['sharedWithUser'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$SharedMemoryToJson(SharedMemory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memoryId': instance.memoryId,
      'memory': instance.memory?.toJson(),
      'sharedFromUserId': instance.sharedFromUserId,
      'sharedFromUser': instance.sharedFromUser?.toJson(),
      'sharedWithUserId': instance.sharedWithUserId,
      'sharedWithUser': instance.sharedWithUser?.toJson(),
    };
