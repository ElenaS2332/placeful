import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:placeful/features/memories/viewmodels/take_image_viewmodel.dart';
import 'package:placeful/features/memories/widgets/camera_shutter.dart';
import 'package:provider/provider.dart';

class TakeImageScreen extends StatelessWidget {
  const TakeImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TakeImageViewModel(),
      child: const _TakeImageScreenBody(),
    );
  }
}

class _TakeImageScreenBody extends StatefulWidget {
  const _TakeImageScreenBody();

  @override
  State<_TakeImageScreenBody> createState() => _TakeImageScreenBodyState();
}

class _TakeImageScreenBodyState extends State<_TakeImageScreenBody> {
  List<CameraDescription>? _availableCameras;
  bool isBackCameraOn = true;

  TakeImageViewModel get vm =>
      Provider.of<TakeImageViewModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();

    final backCamera = _availableCameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    await _initCamera(backCamera);
  }

  Future<void> _initCamera(CameraDescription description) async {
    vm.cameraController?.dispose();
    vm.cameraController = CameraController(
      description,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await vm.cameraController!.initialize();

    if (mounted) {
      setState(() {
        isBackCameraOn = description.lensDirection == CameraLensDirection.back;
      });
    }
  }

  Future<void> _toggleCameraLens() async {
    final lensDirection = vm.cameraController!.description.lensDirection;
    final newDescription = _availableCameras!.firstWhere(
      (desc) =>
          desc.lensDirection ==
          (lensDirection == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front),
    );
    await _initCamera(newDescription);
  }

  @override
  void dispose() {
    vm.cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (vm.cameraController == null ||
        !vm.cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Take Image")),
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 100,
                child: Transform.scale(
                  scaleX: isBackCameraOn ? 1 : -1,
                  child: CameraPreview(vm.cameraController!),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 21, 0, 44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 🔦 Flash toggle button (if you add one later)
                    // CameraShutter button can go here
                    CameraShutter(viewModel: vm),
                    IconButton(
                      onPressed: _toggleCameraLens,
                      icon: const Icon(
                        Icons.switch_camera,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 24,
            child: ElevatedButton(
              onPressed: () async => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
