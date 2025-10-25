import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placeful/features/memories/screens/add_memory_screen.dart';
import 'package:placeful/features/memories/screens/favorite_memories_screen.dart';
import 'package:placeful/features/memories/screens/list_memories_screen.dart';
import 'package:placeful/features/user_profile/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/memory_map_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryMapScreen extends StatelessWidget {
  const MemoryMapScreen({super.key});

  final String _mapStyle = '''[
    {
      "featureType": "poi",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "stylers": [{"visibility": "off"}]
    }
  ]''';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bgColor = const Color(0xFFF7F5FF);

    return ChangeNotifierProvider(
      create: (_) => MemoryMapViewModel()..fetchLatestMemories(),
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
                  icon: const Icon(Icons.person),
                  tooltip: "User Profile",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserProfileScreen(),
                      ),
                    );
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
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(41.9981, 21.4254),
                        zoom: 16,
                      ),
                      markers: markers,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationEnabled: false,
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
                    child: const Icon(Icons.my_location),
                    onPressed: () {
                      // Move camera to current location if available
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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.white, Colors.white70],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.grid_view),
                              label: Text(
                                "List All Memories",
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ListMemoriesScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.white, Colors.white70],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.deepPurple,
                              ),
                              label: Text(
                                "Add New Memory",
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddMemoryScreen(),
                                  ),
                                );
                              },
                            ),
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
}
