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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final Color bgColor = const Color(0xFFF7F5FF);

    return ChangeNotifierProvider(
      create: (_) {
        final vm = MemoryMapViewModel()..fetchFriendshipRequests();
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
            backgroundColor: bgColor,
            appBar: AppBar(
              title: Text(
                "Placeful",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: bgColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              actions: [
                IconButton(
                  icon: _friendRequestIcon(vm.friendRequestsCount),
                  tooltip: "User Profile",
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const UserProfileScreen(),
                          ),
                        )
                        .then((_) => vm.fetchFriendshipRequests());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  tooltip: "Favorites",
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                  ),
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
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Container(
                    height: screenHeight * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
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
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton(
                              heroTag: "myLocation",
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                await vm.setCurrentLocation();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildButton(
                        context,
                        label: "View Your Memories",
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
                      _buildButton(
                        context,
                        label: "View Memories from Friends",
                        icon: Icons.group,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SharedMemoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildButton(
                        context,
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade400,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
