import 'package:camera/camera.dart';

class CameraService {
  CameraController? cameraController;

  Future<XFile?> takePicture() async {
    return cameraController!.takePicture();
  }

  Future<void> pauseCameraPreview() async {
    await cameraController!.pausePreview();
  }

  Future<void> resumeCameraPreview() async {
    await cameraController!.resumePreview();
  }

  Future<void> setFlashMode(FlashMode mode) async {
    await cameraController!.setFlashMode(mode);
  }
}
