import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/memory.dart';

part 'location_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class LocationDto {
  late final double latitude;
  late final double longitude;
  final String name;
  late final List<Memory> memories;

  LocationDto({
    required this.latitude,
    required this.longitude,
    required this.name,
    this.memories = const [],
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}
