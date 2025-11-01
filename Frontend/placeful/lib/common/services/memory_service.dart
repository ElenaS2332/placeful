import 'dart:io';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
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

  Future<void> updateMemory(Memory memory, {File? imageFile}) async {
    final fields = <String, String>{
      'Title': memory.title,
      'Description': memory.description,
    };

    if (memory.date != null) {
      fields['Date'] = memory.date!.toIso8601String();
    }

    if (memory.location != null) {
      fields['LocationLatitude'] = memory.location!.latitude.toString();
      fields['LocationLongitude'] = memory.location!.longitude.toString();
      fields['LocationName'] = memory.location!.name;
    }

    if (imageFile != null) {
      await _client.postWithMedia(
        'memory/${memory.id}',
        fields: fields,
        file: imageFile,
        fileFieldName: 'ImageFile',
      );
    } else {
      await _client.put("memory/${memory.id}", memory.toJson());
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
}
