import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/domain/models/user_profile.dart';

part 'shared_memory.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedMemory {
  SharedMemory({
    required this.id,
    required this.memoryId,
    required this.sharedFromUserId,
    required this.sharedWithUserId,
    this.memory,
    this.sharedFromUser,
    this.sharedWithUser,
  });

  final String id;
  final String memoryId;
  final Memory? memory;
  final String sharedFromUserId;
  final UserProfile? sharedFromUser;
  final String sharedWithUserId;
  final UserProfile? sharedWithUser;

  factory SharedMemory.fromJson(Map<String, dynamic> json) =>
      _$SharedMemoryFromJson(json);

  Map<String, dynamic> toJson() => _$SharedMemoryToJson(this);
}
