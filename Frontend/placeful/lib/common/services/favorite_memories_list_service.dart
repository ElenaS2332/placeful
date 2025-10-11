import 'package:placeful/common/domain/dtos/favorite_memories_list_dto.dart';
import 'package:placeful/common/domain/models/favorite_memories_list.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class FavoriteMemoriesListService {
  FavoriteMemoriesListService();

  final HttpService _client = getIt<HttpService>();

  Future<FavoriteMemoriesList> getFavoriteMemoriesListForCurrentUser() async {
    final Map<String, dynamic> response = await _client.get(
      "favorite-memories-list",
    );
    return FavoriteMemoriesList.fromDto(
      FavoriteMemoriesListDto.fromJson(response),
    );
  }

  Future<void> addMemoryToFavoriteMemoriesListForCurrentUser(
    String memoryId,
  ) async {
    await _client.put("favorite-memories-list/$memoryId", memoryId);
  }

  Future<void> removeMemoryFromFavoriteMemoriesListForCurrentUser(
    String memoryId,
  ) async {
    await _client.delete("favorite-memories-list/$memoryId");
  }

  Future<void> clearFavoriteMemoriesListForCurrentUser() async {
    await _client.delete("favorite-memories-list/all");
  }
}
