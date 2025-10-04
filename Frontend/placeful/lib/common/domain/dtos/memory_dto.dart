import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/location.dart';

part 'memory_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MemoryDto {
  MemoryDto({
    this.title = '',
    this.description = '',
    this.date,
    this.location,
    this.imageUrl,
  });

  late final String title;
  late final String description;
  late final DateTime? date;
  late final Location? location;
  late final String? imageUrl;

  factory MemoryDto.fromJson(Map<String, dynamic> json) =>
      _$MemoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryDtoToJson(this);
}
