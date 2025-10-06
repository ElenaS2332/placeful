// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_simplified_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemorySimplifiedDto _$MemorySimplifiedDtoFromJson(Map<String, dynamic> json) =>
    MemorySimplifiedDto(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$MemorySimplifiedDtoToJson(
  MemorySimplifiedDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
