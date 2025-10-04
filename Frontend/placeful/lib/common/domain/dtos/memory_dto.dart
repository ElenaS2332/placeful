import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/location.dart';

part 'memory_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MemoryDto {
  final String title;
  final String description;
  final Location location;
  final String imageUrl;

  MemoryDto({
    this.title = '',
    this.description = '',
    required this.location,
    this.imageUrl = '',
  });

  factory MemoryDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryDtoToJson(this);
}
