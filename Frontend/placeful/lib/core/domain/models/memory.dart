import 'package:json_annotation/json_annotation.dart';
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

  factory Memory.fromJson(Map<String, dynamic> json) =>
      _$MemoryFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryToJson(this);
}
