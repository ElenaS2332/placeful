import 'package:camera/camera.dart';

class CameraService {
  CameraController? cameraController;

  Future<XFile?> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return null;
    }
    return cameraController!.takePicture();
  }

  Future<void> pauseCameraPreview() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await cameraController!.pausePreview();
    }
  }

  Future<void> resumeCameraPreview() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await cameraController!.resumePreview();
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await cameraController!.setFlashMode(mode);
    }
  }

  void dispose() {
    cameraController?.dispose();
  }
}
