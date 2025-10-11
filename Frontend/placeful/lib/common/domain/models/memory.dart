import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'memory.g.dart';

@JsonSerializable(explicitToJson: true)
class Memory {
  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.userProfileId,
    this.date,
    this.location,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final DateTime? date;
  final Location? location;
  final String? imageUrl;
  final String userProfileId;

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryToJson(this);
}
