import 'package:json_annotation/json_annotation.dart';
import 'package:placeful/common/domain/models/memory.dart';

part 'favorite_memories_list_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteMemoriesListDto {
  final String userProfileId;
  final List<Memory>? memories;

  FavoriteMemoriesListDto({required this.userProfileId, this.memories});

  factory FavoriteMemoriesListDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMemoriesListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMemoriesListDtoToJson(this);
}
