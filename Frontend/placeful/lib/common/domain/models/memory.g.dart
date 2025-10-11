// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memory _$MemoryFromJson(Map<String, dynamic> json) => Memory(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  userProfileId: json['userProfileId'] as String,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  location:
      json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$MemoryToJson(Memory instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date?.toIso8601String(),
  'location': instance.location?.toJson(),
  'imageUrl': instance.imageUrl,
  'userProfileId': instance.userProfileId,
};
