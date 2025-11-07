import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/features/memories/screens/location_picker_screen.dart';
import 'package:placeful/features/memories/screens/take_image_screen.dart';
import 'package:placeful/features/memories/viewmodels/add_memory_viewmodel.dart';
import 'package:provider/provider.dart';

class AddMemoryScreen extends StatelessWidget {
  const AddMemoryScreen({super.key, this.memoryToEdit});
  final Memory? memoryToEdit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMemoryViewModel(memoryToEdit),
      child: const _AddMemoryScreenBody(),
    );
  }
}

class _AddMemoryScreenBody extends StatelessWidget {
  const _AddMemoryScreenBody();

  void showTopToast(
    BuildContext context,
    String message, {
    bool success = true,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: kToolbarHeight + 80,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      success
                          ? Colors.green.shade700.withValues(alpha: 0.9)
                          : Colors.red.shade700,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddMemoryViewModel>(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Memory")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                controller: vm.titleController,
                onChanged: vm.setTitle,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: "Description"),
                controller: vm.descriptionController,
                onChanged: vm.setDescription,
              ),
              const SizedBox(height: 12),
              TextField(
                readOnly: true,
                controller: vm.dateController,
                onTap: () => vm.pickDate(context),
                decoration: InputDecoration(
                  hintText: "Select Date",
                  filled: true,
                  fillColor: Colors.white24,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                readOnly: true,
                controller: vm.locationController,
                onTap: () async {
                  final selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LocationPickerScreen(),
                    ),
                  );
                  if (selectedLocation != null) {
                    final locationToAdd = Location.fromDto(selectedLocation);
                    vm.setLocation(locationToAdd);
                    vm.locationController.text = locationToAdd.name;
                  }
                },
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  labelText: "Location",
                ),
              ),
              const SizedBox(height: 18),
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
              if (vm.location != null)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      vm.showMap && vm.location != null
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
                              child: gmap.GoogleMap(
                                initialCameraPosition: gmap.CameraPosition(
                                  target: gmap.LatLng(
                                    vm.location!.latitude,
                                    vm.location!.longitude,
                                  ),
                                  zoom: 15,
                                ),
                                markers: {
                                  gmap.Marker(
                                    markerId: const gmap.MarkerId(
                                      'selected_location',
                                    ),
                                    position: gmap.LatLng(
                                      vm.location!.latitude,
                                      vm.location!.longitude,
                                    ),
                                    infoWindow: gmap.InfoWindow(
                                      title: vm.titleController.text,
                                      snippet: vm.location!.name,
                                    ),
                                    icon: gmap
                                        .BitmapDescriptor.defaultMarkerWithHue(
                                      gmap.BitmapDescriptor.hueViolet,
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
              Consumer<AddMemoryViewModel>(
                builder: (_, vm, __) {
                  final imagePath = vm.imageUrl;
                  if (imagePath == null || imagePath.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image:
                            imagePath.startsWith('http')
                                ? NetworkImage(imagePath)
                                : FileImage(File(imagePath)) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showImageSourceDialog(context, vm),
                      child: const Text("Add Image"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          vm.isLoading
                              ? null
                              : () async {
                                if (!formKey.currentState!.validate()) return;
                                final success = await vm.addMemory();
                                if (!context.mounted) return;
                                showTopToast(
                                  context,
                                  success
                                      ? vm.memoryToEdit != null
                                          ? 'Memory updated successfully.'
                                          : 'Memory added successfully.'
                                      : 'An error occurred while adding memory.',
                                  success: success,
                                );
                                if (success) Navigator.pop(context, true);
                              },
                      child:
                          vm.isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                vm.memoryToEdit != null
                                    ? "Update Memory"
                                    : "Add Memory",
                              ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (vm.error != null)
                Text(vm.error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

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
      final file = File(capturedImage.path);
      vm.setImageUrl(capturedImage.path);
      vm.setSelectedImage(file);
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
  } else if (Platform.isAndroid) {
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      status = PermissionStatus.granted;
    } else {
      status = await Permission.photos.request();
      if (status.isDenied && ((int.tryParse(Platform.version) ?? 0) < 33)) {
        status = await Permission.storage.request();
      }
    }
  } else {
    status = PermissionStatus.denied;
  }

  if (status.isDenied || status.isPermanentlyDenied) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Gallery permission denied")));
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

  final selectedPath = await Navigator.push<String>(
    context,
    MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text("Select Image")),
            body: GridView.builder(
              padding: const EdgeInsets.all(2),
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
            ),
          ),
    ),
  );

  if (selectedPath != null && selectedPath.isNotEmpty) {
    final file = File(selectedPath);
    vm.setImageUrl(selectedPath);
    vm.setSelectedImage(file);
  }
}
