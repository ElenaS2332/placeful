import 'package:json_annotation/json_annotation.dart';

part 'shared_memory_dto.g.dart';

@JsonSerializable()
class SharedMemoryDto {
  final String memoryId;
  final String? friendFullName;
  final String? memoryTitle;
  final String? memoryDescription;
  final DateTime? memoryDate;
  final String? memoryImageUrl;
  final String? memoryLocationName;
  final double? memoryLocationLatitude;
  final double? memoryLocationLongitude;

  SharedMemoryDto({
    required this.memoryId,
    this.friendFullName,
    this.memoryTitle,
    this.memoryDescription,
    this.memoryDate,
    this.memoryImageUrl,
    this.memoryLocationName,
    this.memoryLocationLatitude,
    this.memoryLocationLongitude,
  });

  factory SharedMemoryDto.fromJson(Map<String, dynamic> json) =>
      _$SharedMemoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SharedMemoryDtoToJson(this);
}
