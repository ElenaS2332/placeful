import 'package:placeful/core/domain/dtos/favorite_memories_list_dto.dart';
import 'package:placeful/core/domain/models/favorite_memories_list.dart';
import 'package:placeful/core/services/http_service.dart';
import 'package:placeful/core/services/service_locatior.dart';

class FavoriteMemoriesListService {
  FavoriteMemoriesListService();

  final HttpService _client = getIt<HttpService>();

  Future<List<FavoriteMemoriesList>> getFavoriteMemoriesLists() async {
    final List response = await _client.get("favorite-memories-list/");
    return response
        .map((c) => FavoriteMemoriesListDto.fromJson(c))
        .map((dto) => FavoriteMemoriesList.fromDto(dto))
        .toList();
  }

  Future<FavoriteMemoriesList> getFavoriteMemoriesList(String id) async {
    final Map<String, dynamic> response = await _client.get(
      "favorite-memories-list/$id",
    );
    return FavoriteMemoriesList.fromDto(
      FavoriteMemoriesListDto.fromJson(response),
    );
  }

  Future<FavoriteMemoriesList> getFavoriteMemoriesListForUser(
    String userId,
  ) async {
    final Map<String, dynamic> response = await _client.get(
      "favorite-memories-list/user/$userId",
    );
    return FavoriteMemoriesList.fromDto(
      FavoriteMemoriesListDto.fromJson(response),
    );
  }

  Future<void> createFavoriteMemoriesList(FavoriteMemoriesList list) async {
    await _client.post("favorite-memories-list/", list.toJson());
  }

  Future<void> updateFavoriteMemoriesList(FavoriteMemoriesList list) async {
    await _client.put("favorite-memories-list/${list.id}", list.toJson());
  }

  Future<void> deleteFavoriteMemoriesList(String id) async {
    await _client.delete("favorite-memories-list/$id");
  }
}
