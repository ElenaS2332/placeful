// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memory _$MemoryFromJson(Map<String, dynamic> json) => Memory(
  id: json['id'] as String,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String? ?? '',
);

Map<String, dynamic> _$MemoryToJson(Memory instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location.toJson(),
  'imageUrl': instance.imageUrl,
};
