// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_memories_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteMemoriesListDto _$FavoriteMemoriesListDtoFromJson(
  Map<String, dynamic> json,
) => FavoriteMemoriesListDto(
  id: json['id'] as String,
  userProfileId: json['userProfileId'] as String,
  memoryId: json['memoryId'] as String,
  userProfile: UserProfile.fromJson(
    json['userProfile'] as Map<String, dynamic>,
  ),
  memory: Memory.fromJson(json['memory'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FavoriteMemoriesListDtoToJson(
  FavoriteMemoriesListDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'userProfileId': instance.userProfileId,
  'memoryId': instance.memoryId,
  'userProfile': instance.userProfile.toJson(),
  'memory': instance.memory.toJson(),
};
