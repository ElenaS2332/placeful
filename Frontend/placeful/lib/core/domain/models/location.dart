import 'package:json_annotation/json_annotation.dart';
import 'memory.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final String id;
  final double latitude;
  final double longitude;
  final List<Memory> memories;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.memories = const [],
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
