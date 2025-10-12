import 'package:flutter/material.dart';
import 'package:placeful/common/domain/dtos/favorite_memories_list_dto.dart';
import 'package:placeful/common/domain/models/favorite_memories_list.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class FavoriteMemoriesListService {
  FavoriteMemoriesListService();

  final HttpService _client = getIt<HttpService>();

  Future<FavoriteMemoriesList> getFavoriteMemoriesListForCurrentUser() async {
    try {
      final Map<String, dynamic> response = await _client.get(
        "favorite-memories-list",
      );
      return FavoriteMemoriesList.fromDto(
        FavoriteMemoriesListDto.fromJson(response),
      );
    } catch (e) {
      debugPrint("Error fetching favorite list: $e");
      throw Exception("Something went wrong while fetching favorites.");
    }
  }

  Future<void> addMemoryToFavoriteMemoriesListForCurrentUser(
    String memoryId,
  ) async {
    try {
      await _client.put("favorite-memories-list/$memoryId", memoryId);
    } catch (e) {
      debugPrint("Error adding memory to favorites: $e");
      throw Exception("Something went wrong while adding to favorites.");
    }
  }

  Future<void> removeMemoryFromFavoriteMemoriesListForCurrentUser(
    String memoryId,
  ) async {
    try {
      await _client.delete("favorite-memories-list/$memoryId");
    } catch (e) {
      debugPrint("Error removing memory from favorites: $e");
      throw Exception("Something went wrong while removing from favorites.");
    }
  }

  Future<void> clearFavoriteMemoriesListForCurrentUser() async {
    try {
      await _client.delete("favorite-memories-list/all");
    } catch (e) {
      debugPrint("Error clearing favorites: $e");
      throw Exception("Something went wrong while clearing favorites.");
    }
  }
}
