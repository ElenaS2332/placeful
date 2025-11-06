import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/common/domain/exceptions/memory_already_shared_exception.dart';
import 'package:placeful/features/friends/screens/select_friend_screen.dart';
import 'package:placeful/features/memories/screens/add_memory_screen.dart';
import 'package:placeful/features/memories/screens/list_memories_screen.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/memory_details_viewmodel.dart';

class MemoryDetailsScreen extends StatelessWidget {
  final String memoryId;

  const MemoryDetailsScreen({super.key, required this.memoryId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryDetailsViewModel(memoryId)..loadMemoryDetails(),
      child: Consumer<MemoryDetailsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                viewModel.memory?.title ?? '',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  tooltip: "Edit Profile",
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                AddMemoryScreen(memoryToEdit: viewModel.memory),
                      ),
                    );
                    if (updated == true) await viewModel.loadMemoryDetails();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.deepPurple),
                  onPressed: () async {
                    await viewModel.deleteMemory(memoryId);
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ListMemoriesScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    final selectedFriend = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectFriendScreen(),
                      ),
                    );

                    if (selectedFriend != null) {
                      try {
                        await viewModel.shareMemoryWith(
                          selectedFriend.firebaseUid,
                        );

                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                content: Text(
                                  "Memory shared with ${selectedFriend.fullName}",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                        );
                      } on MemoryAlreadySharedException {
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Already Shared"),
                                content: Text(
                                  "This memory was already shared with ${selectedFriend.fullName}.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Error"),
                                content: Text("Failed to share memory: $e"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            body:
                viewModel.memory == null
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8668FF),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (viewModel.memory!.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                viewModel.memory!.imageUrl!,
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
                          const SizedBox(height: 16),

                          Text(
                            viewModel.memory!.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                viewModel.memory!.date != null
                                    ? "${viewModel.memory!.date!.day.toString().padLeft(2, '0')}/${viewModel.memory!.date!.month.toString().padLeft(2, '0')}/${viewModel.memory!.date!.year}"
                                    : "No date specified",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Text(
                            viewModel.memory!.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF8668FF),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                viewModel.memory!.location?.name ??
                                    'Unknown location',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: Text(
                                viewModel.showMap ? "Hide Map" : "Show on Map",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8668FF),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: viewModel.toggleMap,
                            ),
                          ),

                          const SizedBox(height: 16),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child:
                                viewModel.showMap &&
                                        viewModel.memory!.location != null
                                    ? Container(
                                      key: const ValueKey('map'),
                                      height: 200,
                                      margin: const EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                              viewModel
                                                  .memory!
                                                  .location!
                                                  .latitude,
                                              viewModel
                                                  .memory!
                                                  .location!
                                                  .longitude,
                                            ),
                                            zoom: 15,
                                          ),
                                          markers: {
                                            Marker(
                                              markerId: const MarkerId(
                                                'memory',
                                              ),
                                              position: LatLng(
                                                viewModel
                                                    .memory!
                                                    .location!
                                                    .latitude,
                                                viewModel
                                                    .memory!
                                                    .location!
                                                    .longitude,
                                              ),
                                              infoWindow: InfoWindow(
                                                title: viewModel.memory!.title,
                                                snippet:
                                                    viewModel
                                                        .memory!
                                                        .location!
                                                        .name,
                                              ),
                                              icon:
                                                  BitmapDescriptor.defaultMarkerWithHue(
                                                    BitmapDescriptor.hueViolet,
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

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }
}
