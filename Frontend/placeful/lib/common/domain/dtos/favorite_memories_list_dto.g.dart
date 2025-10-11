// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_memories_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteMemoriesListDto _$FavoriteMemoriesListDtoFromJson(
  Map<String, dynamic> json,
) => FavoriteMemoriesListDto(
  userProfileId: json['userProfileId'] as String,
  memories:
      (json['memories'] as List<dynamic>?)
          ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FavoriteMemoriesListDtoToJson(
  FavoriteMemoriesListDto instance,
) => <String, dynamic>{
  'userProfileId': instance.userProfileId,
  'memories': instance.memories?.map((e) => e.toJson()).toList(),
};
