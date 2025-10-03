import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';
import 'memory.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final double latitude;
  final double longitude;
  final List<Memory> memories;

  Location({
    required this.latitude,
    required this.longitude,
    this.memories = const [],
  });

  Location.fromDto(LocationDto dto)
    : latitude = dto.latitude,
      longitude = dto.longitude,
      memories = dto.memories;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
