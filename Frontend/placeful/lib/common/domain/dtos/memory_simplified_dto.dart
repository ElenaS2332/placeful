import 'package:json_annotation/json_annotation.dart';

part 'memory_simplified_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MemorySimplifiedDto {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  MemorySimplifiedDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory MemorySimplifiedDto.fromJson(Map<String, dynamic> json) =>
      _$MemorySimplifiedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MemorySimplifiedDtoToJson(this);
}
