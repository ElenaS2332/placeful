import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final String id;
  final double latitude;
  final double longitude;
  final String name;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Location.fromDto(LocationDto dto)
    : id = dto.id,
      name = dto.name,
      latitude = dto.latitude,
      longitude = dto.longitude;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
