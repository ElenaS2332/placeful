import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  late final String id;
  late final double latitude;
  late final double longitude;
  late final String name;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Location.fromDto(LocationDto dto)
    : name = dto.name,
      latitude = dto.latitude,
      longitude = dto.longitude;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
