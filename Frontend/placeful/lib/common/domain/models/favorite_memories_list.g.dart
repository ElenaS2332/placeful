// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_memories_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteMemoriesList _$FavoriteMemoriesListFromJson(
  Map<String, dynamic> json,
) => FavoriteMemoriesList(
  userProfileId: json['userProfileId'] as String,
  memories:
      (json['memories'] as List<dynamic>?)
          ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FavoriteMemoriesListToJson(
  FavoriteMemoriesList instance,
) => <String, dynamic>{
  'userProfileId': instance.userProfileId,
  'memories': instance.memories?.map((e) => e.toJson()).toList(),
};
