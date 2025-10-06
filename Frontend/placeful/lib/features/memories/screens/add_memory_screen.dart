import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/features/memories/screens/location_picker_screen.dart';
import 'package:placeful/features/memories/screens/take_image_screen.dart';
import 'package:provider/provider.dart';
import '../viewmodels/add_memory_viewmodel.dart';

class AddMemoryScreen extends StatelessWidget {
  const AddMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMemoryViewModel(),
      child: const _AddMemoryScreenBody(),
    );
  }
}

Future<void> _showImageSourceDialog(BuildContext context) async {
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
                await _openCamera(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Open Gallery"),
              onTap: () async {
                Navigator.pop(context);
                await _openGallery(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _openGallery(BuildContext context) async {
  var status = await Permission.photos.request(); // iOS
  if (status.isGranted) {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    final recentAlbum = albums.first;
    final recentImages = await recentAlbum.getAssetListPaged(page: 0, size: 30);

    if (!context.mounted) return;

    showModalBottomSheet(
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

                    Navigator.pop(context, file?.path);
                  },
                  child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                );
              },
            );
          },
        );
      },
    );
  } else {
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Gallery permission denied")));
  }
}

Future<void> _openCamera(BuildContext context) async {
  var status = await Permission.camera.request();
  if (!context.mounted) return;

  if (status.isGranted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TakeImageScreen()),
    );
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Camera permission denied")));
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
                          : Colors.red,
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
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddMemoryViewModel>(context);
    final locationController = TextEditingController(
      text: vm.location != null ? vm.location!.name : 'Add Location',
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Memory")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: vm.setTitle,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
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
            TextField(
              readOnly: true,
              controller: locationController,
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
                  locationController.text = locationToAdd.name;
                }
              },
              style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showImageSourceDialog(context),
                    child: const Text("Add Image"),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        vm.isLoading
                            ? null
                            : () async {
                              final success = await vm.addMemory();
                              if (!context.mounted) return;

                              showTopToast(
                                context,
                                success
                                    ? 'Memory successfully added!'
                                    : 'An error occurred while adding memory.',
                                success: success,
                              );

                              if (success) Navigator.pop(context);
                            },
                    child:
                        vm.isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Add Memory"),
                  ),
                ),
              ],
            ),
            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
