import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeful/features/memories/screens/add_memory_screen.dart';
import 'package:placeful/features/memories/screens/favorite_memories_screen.dart';
import 'package:placeful/features/memories/screens/list_memories_screen.dart';
import 'package:placeful/features/user_profile/screens/user_profile_screen.dart';
import 'package:placeful/features/memories/viewmodels/memory_map_viewmodel.dart';
import 'package:placeful/features/memories/screens/shared_memory_screen.dart';
import 'package:provider/provider.dart';

class MemoryMapScreen extends StatelessWidget {
  const MemoryMapScreen({super.key});

  final String _mapStyle = '''[
    {"featureType": "poi", "stylers": [{"visibility": "off"}]},
    {"featureType": "transit", "stylers": [{"visibility": "off"}]}
  ]''';

  Widget _friendRequestIcon(int count) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Center(
            child: Icon(Icons.person, size: 28, color: Colors.deepPurple),
          ),
          if (count > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showTopToast(BuildContext context) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Dismissible(
                key: const Key('shared_memories_toast'),
                direction: DismissDirection.up,
                onDismissed: (_) => overlayEntry.remove(),
                child: GestureDetector(
                  onTap: () {
                    overlayEntry.remove();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SharedMemoryScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade400,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Unlock new memories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "See the memories your friends shared with you",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    // Future.delayed(const Duration(seconds: 10)).then((_) {
    //   if (overlayEntry.mounted) overlayEntry.remove();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bgColor = const Color(0xFFF7F5FF);

    return ChangeNotifierProvider(
      create: (_) {
        final vm = MemoryMapViewModel();
        vm.initializeMap();
        return vm;
      },
      child: Consumer<MemoryMapViewModel>(
        builder: (context, vm, _) {
          final purpleMarker = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          );

          final markers =
              vm.allMemories.map((memory) {
                return Marker(
                  markerId: MarkerId(memory.id),
                  position: LatLng(
                    memory.location?.latitude ?? 41.9981,
                    memory.location?.longitude ?? 21.4254,
                  ),
                  infoWindow: InfoWindow(title: memory.title),
                  icon: purpleMarker,
                );
              }).toSet();

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: bgColor,
            appBar: AppBar(
              title: Text(
                "Memories Map",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
              backgroundColor: bgColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              actions: [
                IconButton(
                  icon: _friendRequestIcon(vm.friendRequestsCount),
                  tooltip: "User Profile",
                  onPressed: () async {
                    final updated = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserProfileScreen(),
                      ),
                    );
                    if (updated == true) {
                      await vm.fetchFriendshipRequests();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  tooltip: "Favorites",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoriteMemoriesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                vm.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    )
                    : GoogleMap(
                      initialCameraPosition:
                          vm.currentLocation != null
                              ? CameraPosition(
                                target: vm.currentLocation!,
                                zoom: 16,
                              )
                              : const CameraPosition(
                                target: LatLng(41.9981, 21.4254),
                                zoom: 14,
                              ),
                      onMapCreated: (controller) {
                        vm.setMapController(controller);

                        Future.delayed(
                          const Duration(microseconds: 500),
                          () => _showTopToast(context),
                        );
                      },
                      markers: markers,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      style: _mapStyle,
                    ),
                Positioned(
                  bottom: screenHeight * 0.2,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: "myLocation",
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location, color: Colors.black),
                    onPressed: () async {
                      await vm.setCurrentLocation();
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.18,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade200.withValues(alpha: 0.9),
                          Colors.purple.shade400.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGradientButton(
                            label: "List All Memories",
                            icon: Icons.grid_view,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ListMemoriesScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildGradientButton(
                            label: "Add New Memory",
                            icon: Icons.add,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddMemoryScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.white, Colors.white70]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.deepPurple),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: onTap,
      ),
    );
  }
}
