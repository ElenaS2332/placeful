import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/favorite_memories_list_dto.dart';
import 'user_profile.dart';
import 'memory.dart';

part 'favorite_memories_list.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteMemoriesList {
  final String id;
  final String userProfileId;
  final String memoryId;
  final UserProfile userProfile;
  final Memory memory;

  FavoriteMemoriesList({
    required this.id,
    required this.userProfileId,
    required this.memoryId,
    required this.userProfile,
    required this.memory,
  });

  FavoriteMemoriesList.fromDto(FavoriteMemoriesListDto dto)
    : id = dto.id,
      userProfileId = dto.userProfileId,
      memoryId = dto.memoryId,
      userProfile = dto.userProfile,
      memory = dto.memory;

  factory FavoriteMemoriesList.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMemoriesListFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMemoriesListToJson(this);
}
