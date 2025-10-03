import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MemoriesPage extends StatefulWidget {
  const MemoriesPage({super.key});

  @override
  State<MemoriesPage> createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  late GoogleMapController _mapController;

  final List<Marker> _markers = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(40.7128, -74.0060),
      infoWindow: InfoWindow(title: 'Memory 1'),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(34.0522, -118.2437),
      infoWindow: InfoWindow(title: 'Memory 2'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memories')),
      body: Column(
        children: [
          // Top: Map
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(40.7128, -74.0060),
                zoom: 4,
              ),
              markers: _markers.toSet(),
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
          // Bottom: Memories list
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                    title: Text('Memory #${index + 1}'),
                    subtitle: const Text('This is a placeholder memory.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
