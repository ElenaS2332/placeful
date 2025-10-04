// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryDto _$MemoryDtoFromJson(Map<String, dynamic> json) => MemoryDto(
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  location:
      json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$MemoryDtoToJson(MemoryDto instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'date': instance.date?.toIso8601String(),
  'location': instance.location?.toJson(),
  'imageUrl': instance.imageUrl,
};
