import 'dart:io';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'package:placeful/common/domain/dtos/memory_to_edit_dto.dart';
import 'package:placeful/common/domain/dtos/shared_memory_dto.dart';
import 'package:placeful/common/domain/exceptions/http_response_exception.dart';
import 'package:placeful/common/domain/exceptions/memory_already_shared_exception.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class MemoryService {
  MemoryService();

  final HttpService _client = getIt<HttpService>();

  Future<List<Memory>> getMemories({int page = 1, int pageSize = 5}) async {
    final List response = await _client.get(
      "memory?page=$page&pageSize=$pageSize",
    );
    return response.map((c) => Memory.fromJson(c)).toList();
  }

  Future<List<Memory>> searchMemories(
    String searchQuery, {
    int page = 1,
    int pageSize = 5,
  }) async {
    final List response = await _client.get(
      "memory?page=$page&pageSize=$pageSize&searchQuery=$searchQuery",
    );
    return response.map((c) => Memory.fromJson(c)).toList();
  }

  Future<Memory> getMemory(String id) async {
    final Map<String, dynamic> response = await _client.get("memory/$id");
    return Memory.fromJson(response);
  }

  Future<void> addMemory(MemoryDto memoryDto, {File? imageFile}) async {
    if (imageFile != null) {
      final fields = <String, String>{
        'Title': memoryDto.title,
        'Description': memoryDto.description,
      };

      if (memoryDto.date != null) {
        fields['Date'] = memoryDto.date!.toIso8601String();
      }

      if (memoryDto.location != null) {
        fields['LocationLatitude'] = memoryDto.location!.latitude.toString();
        fields['LocationLongitude'] = memoryDto.location!.longitude.toString();
        fields['LocationName'] = memoryDto.location!.name;
      }

      await _client.postWithMedia(
        'memory/',
        fields: fields,
        file: imageFile,
        fileFieldName: 'ImageFile',
      );
    } else {
      await _client.post('memory/', memoryDto.toJson());
    }
  }

  Future<void> updateMemory(
    MemoryToEditDto memoryToEdit, {
    File? imageFile,
  }) async {
    final fields = <String, String>{
      'Id': memoryToEdit.id,
      'Title': memoryToEdit.title,
      'Description': memoryToEdit.description,
    };

    if (memoryToEdit.date != null) {
      fields['Date'] = memoryToEdit.date!.toIso8601String();
    }

    if (memoryToEdit.location != null) {
      fields['Location.Latitude'] = memoryToEdit.location!.latitude.toString();
      fields['Location.Longitude'] =
          memoryToEdit.location!.longitude.toString();
      fields['Location.Name'] = memoryToEdit.location!.name;
    }

    if (imageFile != null) {
      await _client.putWithMedia(
        'memory/${memoryToEdit.id}',
        fields: fields,
        file: imageFile,
        fileFieldName: 'ImageFile',
      );
    } else {
      if (memoryToEdit.imageUrl != null) {
        fields['ImageUrl'] = memoryToEdit.imageUrl!;
      }

      await _client.putWithMedia(
        'memory/${memoryToEdit.id}',
        fields: fields,
        file: null,
        fileFieldName: 'ImageFile',
      );
    }
  }

  Future<void> deleteMemory(String id) async {
    await _client.delete("memory/$id");
  }

  Future<void> shareMemoryWith(String memoryId, String friendId) async {
    try {
      await _client.post('memory/$memoryId/share/$friendId', {});
    } on HttpResponseException catch (e) {
      if (e.statusCode == 409) {
        throw MemoryAlreadySharedException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<SharedMemoryDto>> listSharedMemoriesForCurrentUser() async {
    final List response = await _client.get("memory/shared");
    return response.map((c) => SharedMemoryDto.fromJson(c)).toList();
  }
}
