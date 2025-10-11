import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/dtos/favorite_memories_list_dto.dart';
import 'memory.dart';

part 'favorite_memories_list.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteMemoriesList {
  final String userProfileId;
  final List<Memory>? memories;

  FavoriteMemoriesList({required this.userProfileId, required this.memories});

  FavoriteMemoriesList.fromDto(FavoriteMemoriesListDto dto)
    : userProfileId = dto.userProfileId,
      memories = dto.memories;

  factory FavoriteMemoriesList.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMemoriesListFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMemoriesListToJson(this);
}
