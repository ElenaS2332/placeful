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
  bool _isToastVisible = false;

  void _showToast(String message, {bool success = true}) {
    _toastEntry?.remove();
    _isToastVisible = true;

    final overlay = Overlay.of(context);
    _toastEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: kToolbarHeight + 16,
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
                  color:
                      success
                          ? Color.fromRGBO(141, 172, 22, 0.9)
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

    overlay.insert(_toastEntry!);
  }

  @override
  void dispose() {
    _toastEntry?.remove();
    super.dispose();
  }

  final String mapStyleNoPOI = '''
  [
    {
      "featureType": "poi",
      "stylers": [
        { "visibility": "off" }
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        { "visibility": "off" }
      ]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationPickerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
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
          if (_isToastVisible) {
            _isToastVisible = false;
          }
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) {
              final controller = TextEditingController();
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "e.g. My Favorite Spot",
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final name = controller.text.trim();
                        vm.setLocationName(name);
                        _showToast(name);
                        Navigator.pop(ctx);
                      },
                      child: const Text("Save"),
                    ),
                    const SizedBox(height: 10),
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
