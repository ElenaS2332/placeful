import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';
import 'memory.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  late final String id;
  late final double latitude;
  late final double longitude;
  late final String name;
  late final List<Memory> memories;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    this.memories = const [],
  });

  Location.fromDto(LocationDto dto)
    : name = dto.name,
      latitude = dto.latitude,
      longitude = dto.longitude,
      memories = dto.memories;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
