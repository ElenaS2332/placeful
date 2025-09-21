import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/core/domain/models/memory.dart';
import 'package:placeful/core/domain/models/user_profile.dart';

part 'favorite_memories_list_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteMemoriesListDto {
  final String id;
  final String userProfileId;
  final String memoryId;
  final UserProfile userProfile;
  final Memory memory;

  FavoriteMemoriesListDto({
    required this.id,
    required this.userProfileId,
    required this.memoryId,
    required this.userProfile,
    required this.memory,
  });

  factory FavoriteMemoriesListDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMemoriesListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMemoriesListDtoToJson(this);
}
