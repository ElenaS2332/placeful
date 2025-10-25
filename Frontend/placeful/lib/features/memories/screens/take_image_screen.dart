import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakeImageScreen extends StatefulWidget {
  const TakeImageScreen({super.key});

  @override
  State<TakeImageScreen> createState() => _TakeImageScreenState();
}

class _TakeImageScreenState extends State<TakeImageScreen> {
  CameraController? _controller;
  XFile? _capturedImage;
  bool _isInitialized = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera init failed: $e");
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isBusy) {
      return;
    }
    setState(() => _isBusy = true);

    try {
      final file = await _controller!.takePicture();
      setState(() {
        _capturedImage = file;
      });
    } catch (e) {
      debugPrint("Error taking picture: $e");
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _retake() async {
    setState(() => _capturedImage = null);
  }

  Future<void> _usePhoto() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      Navigator.pop(context, _capturedImage);
    }
  }

  @override
  void dispose() {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        _controller!.stopImageStream().catchError((_) {});
        _controller!.pausePreview().catchError((_) {});
      }
    } catch (_) {}

    try {
      _controller?.dispose();
    } catch (e) {
      debugPrint("Ignored camera dispose error: $e");
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Take image",
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child:
                _capturedImage == null
                    ? CameraPreview(_controller!)
                    : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:
                _capturedImage == null
                    ? Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: _takePicture,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),
                    )
                    : Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _retake,
                            icon: const Icon(Icons.close),
                            label: const Text("Retake"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _usePhoto,
                            icon: const Icon(Icons.check),
                            label: const Text("Use Photo"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
