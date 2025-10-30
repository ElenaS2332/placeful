import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/features/memories/screens/location_picker_screen.dart';
import 'package:placeful/features/memories/screens/take_image_screen.dart';
import '../viewmodels/add_memory_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class AddMemoryScreen extends StatelessWidget {
  const AddMemoryScreen({super.key, this.memoryToEdit});

  final Memory? memoryToEdit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMemoryViewModel(memoryToEdit),
      child: const AddMemoryScreenBody(),
    );
  }
}

class AddMemoryScreenBody extends StatelessWidget {
  const AddMemoryScreenBody({super.key});

  Future<void> _showImageSourceDialog(
    BuildContext context,
    AddMemoryViewModel vm,
  ) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Open Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await _openCamera(context, vm);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Open Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await _openGallery(context, vm);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCamera(BuildContext context, AddMemoryViewModel vm) async {
    final status = await Permission.camera.request();
    if (!context.mounted) return;
    if (status.isGranted) {
      final capturedImage = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(builder: (_) => const TakeImageScreen()),
      );
      if (capturedImage != null && capturedImage.path.isNotEmpty) {
        vm.setImageUrl(capturedImage.path);
        vm.setSelectedImage(File(capturedImage.path));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Camera permission denied")));
    }
  }

  Future<void> _openGallery(BuildContext context, AddMemoryViewModel vm) async {
    PermissionStatus status;
    if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
        if (status.isDenied && ((int.tryParse(Platform.version) ?? 0) < 33)) {
          status = await Permission.storage.request();
        }
      }
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gallery permission denied")),
      );
      if (status.isPermanentlyDenied) await openAppSettings();
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (albums.isEmpty) return;

    final recentAlbum = albums.first;
    final recentImages = await recentAlbum.getAssetListPaged(page: 0, size: 30);
    if (!context.mounted) return;

    final selectedPath = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: recentImages.length,
          itemBuilder: (_, index) {
            final asset = recentImages[index];
            return FutureBuilder<Uint8List?>(
              future: asset.thumbnailDataWithSize(
                const ThumbnailSize(200, 200),
              ),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return GestureDetector(
                  onTap: () async {
                    final file = await asset.file;
                    if (!context.mounted) return;
                    if (file != null && file.existsSync()) {
                      Navigator.pop(context, file.path);
                    }
                  },
                  child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                );
              },
            );
          },
        );
      },
    );

    if (selectedPath != null && selectedPath.isNotEmpty) {
      vm.setImageUrl(selectedPath);
      vm.setSelectedImage(File(selectedPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddMemoryViewModel>(context);
    final formKey = GlobalKey<FormState>();

    if (vm.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          vm.memoryToEdit == null ? "Add New Memory" : "Edit Memory",
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: vm.titleController,
                onChanged: vm.setTitle,
                decoration: InputDecoration(
                  labelText: "Title",
                  prefixIcon: const Icon(Icons.title),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vm.descriptionController,
                onChanged: vm.setDescription,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vm.dateController,
                readOnly: true,
                onTap: () => vm.pickDate(context),
                decoration: InputDecoration(
                  hintText: "Select Date",
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vm.locationController,
                readOnly: true,
                onTap: () async {
                  if (!context.mounted) return;
                  if (vm.showMap) vm.toggleMap();
                  final selectedLocationDto = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LocationPickerScreen(),
                    ),
                  );

                  if (selectedLocationDto != null) {
                    final loc = Location.fromDto(selectedLocationDto);

                    vm.setLocation(loc);
                    vm.memoryLocation = gmap.LatLng(
                      loc.latitude,
                      loc.longitude,
                    );

                    vm.locationController.text = loc.name;

                    if (!vm.showMap) vm.toggleMap();
                  }
                },
                decoration: InputDecoration(
                  hintText: "Add Location",
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (vm.location != null)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: Text(vm.showMap ? "Hide Map" : "Show on Map"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8668FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: vm.toggleMap,
                  ),
                ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    vm.showMap
                        ? Container(
                          key: const ValueKey('map'),
                          height: 200,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: vm.memoryLocation,
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('memory'),
                                  position: vm.memoryLocation,
                                  infoWindow: InfoWindow(
                                    title: vm.title,
                                    snippet: vm.location!.name,
                                  ),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              scrollGesturesEnabled: true,
                              tiltGesturesEnabled: false,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              if (vm.imageUrl != null && vm.imageUrl!.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: Image.network(
                    vm.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                  ),
                ),
              if (vm.imageUrl != null && vm.imageUrl!.isNotEmpty)
                const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showImageSourceDialog(context, vm),
                icon: const Icon(Icons.add_a_photo),
                label: const Text("Add Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    vm.isLoading
                        ? null
                        : () async {
                          if (!formKey.currentState!.validate()) return;
                          final success = await vm.saveMemory();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? (vm.memoryToEdit == null
                                        ? 'Memory added!'
                                        : 'Memory updated!')
                                    : 'Error saving memory',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          if (success) Navigator.pop(context);
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    vm.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          vm.memoryToEdit == null
                              ? "Add Memory"
                              : "Save Memory",
                        ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
