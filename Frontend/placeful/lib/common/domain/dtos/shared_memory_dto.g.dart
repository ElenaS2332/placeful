// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_memory_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedMemoryDto _$SharedMemoryDtoFromJson(Map<String, dynamic> json) =>
    SharedMemoryDto(
      memoryId: json['memoryId'] as String,
      friendFullName: json['friendFullName'] as String?,
      memoryTitle: json['memoryTitle'] as String?,
      memoryDescription: json['memoryDescription'] as String?,
      memoryDate:
          json['memoryDate'] == null
              ? null
              : DateTime.parse(json['memoryDate'] as String),
      memoryImageUrl: json['memoryImageUrl'] as String?,
      memoryLocationName: json['memoryLocationName'] as String?,
      memoryLocationLatitude:
          (json['memoryLocationLatitude'] as num?)?.toDouble(),
      memoryLocationLongitude:
          (json['memoryLocationLongitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SharedMemoryDtoToJson(SharedMemoryDto instance) =>
    <String, dynamic>{
      'memoryId': instance.memoryId,
      'friendFullName': instance.friendFullName,
      'memoryTitle': instance.memoryTitle,
      'memoryDescription': instance.memoryDescription,
      'memoryDate': instance.memoryDate?.toIso8601String(),
      'memoryImageUrl': instance.memoryImageUrl,
      'memoryLocationName': instance.memoryLocationName,
      'memoryLocationLatitude': instance.memoryLocationLatitude,
      'memoryLocationLongitude': instance.memoryLocationLongitude,
    };
