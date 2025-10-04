import 'package:flutter/material.dart';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class AddMemoryViewModel extends ChangeNotifier {
  final MemoryService memoryService = getIt.get<MemoryService>();

  AddMemoryViewModel();

  String title = '';
  String description = '';
  Location? location;
  String imageUrl = '';

  bool isLoading = false;
  String? error;

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setLocation(Location value) {
    location = value;
    notifyListeners();
  }

  void setImageUrl(String value) {
    imageUrl = value;
    notifyListeners();
  }

  bool get isValid =>
      title.isNotEmpty && description.isNotEmpty && location != null;

  Future<bool> addMemory() async {
    if (!isValid) {
      error = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final memoryDto = MemoryDto(
        title: title,
        description: description,
        location: location!,
        imageUrl: imageUrl,
      );

      await memoryService.addMemory(memoryDto);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
