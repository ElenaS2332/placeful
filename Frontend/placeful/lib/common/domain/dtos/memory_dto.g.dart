// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryDto _$MemoryDtoFromJson(Map<String, dynamic> json) => MemoryDto(
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String? ?? '',
);

Map<String, dynamic> _$MemoryDtoToJson(MemoryDto instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'location': instance.location.toJson(),
  'imageUrl': instance.imageUrl,
};
