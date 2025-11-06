// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_to_edit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryToEditDto _$MemoryToEditDtoFromJson(Map<String, dynamic> json) =>
    MemoryToEditDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location:
          json['location'] == null
              ? null
              : LocationDto.fromJson(json['location'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$MemoryToEditDtoToJson(MemoryToEditDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
      'location': instance.location?.toJson(),
      'imageUrl': instance.imageUrl,
    };
