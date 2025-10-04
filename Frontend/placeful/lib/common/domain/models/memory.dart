import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'location.dart';

part 'memory.g.dart';

@JsonSerializable(explicitToJson: true)
class Memory {
  Memory({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.location,
    this.imageUrl,
  });

  late final String id;
  late final String title;
  late final String description;
  late final DateTime? date;
  late final Location? location;
  late final String? imageUrl;

  Memory.fromDto(MemoryDto dto)
    : title = dto.title,
      description = dto.description,
      date = dto.date,
      location = dto.location,
      imageUrl = dto.imageUrl;

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryToJson(this);
}
