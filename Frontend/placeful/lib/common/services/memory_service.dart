import 'dart:io';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class MemoryService {
  MemoryService();

  final HttpService _client = getIt<HttpService>();

  Future<List<Memory>> getMemories({
    required int page,
    int pageSize = 5,
  }) async {
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

  Future<void> updateMemory(Memory memory) async {
    await _client.put("memory/${memory.id}", memory.toJson());
  }

  Future<void> deleteMemory(String id) async {
    await _client.delete("memory/$id");
  }
}
