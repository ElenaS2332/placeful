import 'package:flutter/material.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class AddMemoryViewModel extends ChangeNotifier {
  final MemoryService memoryService = getIt.get<MemoryService>();

  AddMemoryViewModel();

  String title = '';
  String description = '';
  DateTime? date;
  Location? location;
  String? imageUrl = '';

  bool isLoading = false;
  String? error;

  final dateController = TextEditingController();

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setDate(DateTime? value) {
    date = value;
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

  bool get isValid => title.isNotEmpty && description.isNotEmpty;

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
        date: date,
        location:
            location != null
                ? LocationDto(
                  latitude: location!.latitude,
                  longitude: location!.longitude,
                  name: location!.name,
                )
                : null,
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

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: now.subtract(const Duration(days: 365 * 12)),
    );
    if (picked != null) {
      dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      setDate(picked);
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}
