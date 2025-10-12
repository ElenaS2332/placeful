import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:placeful/common/domain/models/memory.dart';
import 'package:placeful/features/memories/viewmodels/memory_details_viewmodel.dart';

class MemoryDetailsScreen extends StatelessWidget {
  final Memory memory;

  const MemoryDetailsScreen({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryDetailsViewModel(memory),
      child: Consumer<MemoryDetailsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(title: Text(viewModel.title)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(viewModel.imageUrl!),
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
                    viewModel.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.pink),
                      const SizedBox(width: 8),
                      Text(
                        viewModel.locationName,
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
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: viewModel.toggleMap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        viewModel.showMap
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
                                    target: viewModel.memoryLocation,
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('memory'),
                                      position: viewModel.memoryLocation,
                                      infoWindow: InfoWindow(
                                        title: viewModel.title,
                                        snippet: viewModel.locationName,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
