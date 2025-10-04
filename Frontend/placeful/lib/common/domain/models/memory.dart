import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'location.dart';

part 'memory.g.dart';

@JsonSerializable(explicitToJson: true)
class Memory {
  final String id;
  final String title;
  final String description;
  final Location location;
  final String imageUrl;

  Memory({
    required this.id,
    this.title = '',
    this.description = '',
    required this.location,
    this.imageUrl = '',
  });

  Memory.fromDto(MemoryDto dto)
    : id =
          '0000-0000-0000-0000', // Since MemoryDto does not have an id, we assign a default value
      title = dto.title,
      description = dto.description,
      location = dto.location,
      imageUrl = dto.imageUrl;

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryToJson(this);
}
