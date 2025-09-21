import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/core/domain/models/memory.dart';

part 'location_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class LocationDto {
  final String id;
  final double latitude;
  final double longitude;
  final List<Memory> memories;

  LocationDto({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.memories = const [],
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}
