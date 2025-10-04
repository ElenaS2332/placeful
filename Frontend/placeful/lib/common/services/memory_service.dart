import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class MemoryService {
  MemoryService();

  final HttpService _client = getIt<HttpService>();

  Future<List<Memory>> getMemories() async {
    final List response = await _client.get("memory/");
    return response
        .map((c) => MemoryDto.fromJson(c))
        .map((dto) => Memory.fromDto(dto))
        .toList();
  }

  Future<Memory> getMemory(String id) async {
    final Map<String, dynamic> response = await _client.get("memory/$id");
    return Memory.fromDto(MemoryDto.fromJson(response));
  }

  Future<void> addMemory(MemoryDto memoryDto) async {
    await _client.post("memory/", memoryDto.toJson());
  }

  Future<void> updateMemory(Memory memory) async {
    await _client.put("memory/${memory.id}", memory.toJson());
  }

  Future<void> deleteMemory(String id) async {
    await _client.delete("memory/$id");
  }
}
