import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/domain/dtos/location_dto.dart';
import 'package:placeful/common/domain/dtos/memory_dto.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class AddMemoryViewModel extends ChangeNotifier {
  final MemoryService memoryService = getIt.get<MemoryService>();
  final Memory? memoryToEdit;

  AddMemoryViewModel(this.memoryToEdit) {
    _initializeMemory();
  }

  bool isInitializing = true;

  String title = '';
  String description = '';
  DateTime? date;
  Location? location;
  String? imageUrl = '';

  File? selectedImageFile;
  bool isLoading = false;
  String? error;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();

  bool _showMap = false;
  bool get showMap => _showMap;

  LatLng memoryLocation = LatLng(0, 0);

  Future<void> _initializeMemory() async {
    if (memoryToEdit != null) {
      titleController.text = memoryToEdit!.title;
      descriptionController.text = memoryToEdit!.description;
      title = memoryToEdit!.title;
      description = memoryToEdit!.description;

      if (memoryToEdit!.date != null) {
        dateController.text =
            '${memoryToEdit!.date!.day}/${memoryToEdit!.date!.month}/${memoryToEdit!.date!.year}';
        date = memoryToEdit!.date;
      }

      if (memoryToEdit!.location != null) {
        locationController.text = memoryToEdit!.location!.name;
        location = memoryToEdit!.location;
        setMemoryLocation(
          LatLng(
            memoryToEdit!.location!.latitude,
            memoryToEdit!.location!.longitude,
          ),
        );
      }

      if (memoryToEdit!.imageUrl != null) {
        imageUrl = memoryToEdit!.imageUrl;
      }
    }

    isInitializing = false;
    notifyListeners();
  }

  void setSelectedImage(File file) {
    selectedImageFile = file;
  }

  void setTitle(String value) {
    title = value;
  }

  void setDescription(String value) {
    description = value;
  }

  void setDate(DateTime? value) {
    date = value;
  }

  void setLocation(Location value) {
    location = value;
  }

  void setImageUrl(String value) {
    imageUrl = value;
    notifyListeners();
  }

  void setMemoryLocation(LatLng value) {
    memoryLocation = value;
    notifyListeners();
  }

  bool get isValid => title.isNotEmpty && description.isNotEmpty;

  void toggleMap() {
    _showMap = !_showMap;
    notifyListeners();
  }

  Future<bool> saveMemory() async {
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
                  id: location!.id,
                  latitude: location!.latitude,
                  longitude: location!.longitude,
                  name: location!.name,
                )
                : null,
        imageUrl: imageUrl,
      );

      if (memoryToEdit != null) {
        await memoryService.updateMemory(
          memoryToEdit!.copyWith(
            title: title,
            description: description,
            date: date,
            location: location,
            imageUrl: imageUrl,
          ),
          imageFile: selectedImageFile,
        );
      } else {
        await memoryService.addMemory(memoryDto, imageFile: selectedImageFile);
      }

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
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
