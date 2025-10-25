import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:placeful/features/memories/viewmodels/location_picker_viewmodel.dart';
import 'package:provider/provider.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationPickerViewModel(),
      child: const _LocationPickerScreenBody(),
    );
  }
}

class _LocationPickerScreenBody extends StatefulWidget {
  const _LocationPickerScreenBody();

  @override
  State<_LocationPickerScreenBody> createState() =>
      _LocationPickerScreenBodyState();
}

class _LocationPickerScreenBodyState extends State<_LocationPickerScreenBody> {
  OverlayEntry? _toastEntry;

  void _showToast(String message) {
    _toastEntry?.remove();

    final overlay = Overlay.of(context);
    _toastEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: kToolbarHeight + 100,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
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
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
    );
    overlay.insert(_toastEntry!);
    Future.delayed(const Duration(seconds: 2), () => _toastEntry?.remove());
  }

  final String mapStyleNoPOI = '''
  [
    {
      "featureType": "poi",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "stylers": [{"visibility": "off"}]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationPickerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Pick Location",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            color: Colors.deepPurple,
            onPressed:
                vm.selectedPosition == null
                    ? null
                    : () {
                      final location = vm.getSelectedLocation();
                      Navigator.pop(context, location);
                    },
          ),
        ],
      ),
      body: gmap.GoogleMap(
        initialCameraPosition: const gmap.CameraPosition(
          target: gmap.LatLng(41.9981, 21.4254),
          zoom: 16,
        ),
        style: mapStyleNoPOI,
        onMapCreated: vm.onMapCreated,
        onTap: (position) async {
          vm.onMapTapped(position);

          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (ctx) {
              final controller = TextEditingController();
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                  left: 16,
                  right: 16,
                  top: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter location name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "e.g. My Favorite Spot",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        final name = value.trim();
                        if (name.isNotEmpty) {
                          vm.setLocationName(name);
                          _showToast(name);
                        }
                        Navigator.pop(ctx);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          vm.setLocationName(name);
                          _showToast(name);
                        }
                        Navigator.pop(ctx);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
        markers:
            vm.selectedPosition == null
                ? {}
                : {
                  gmap.Marker(
                    markerId: const gmap.MarkerId("selected"),
                    position: vm.selectedPosition!,
                    icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
                      gmap.BitmapDescriptor.hueViolet,
                    ),
                    infoWindow: gmap.InfoWindow(
                      title:
                          vm.locationName.isEmpty
                              ? "Unnamed location"
                              : vm.locationName,
                    ),
                  ),
                },
      ),
    );
  }
}
