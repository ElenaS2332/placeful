import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:placeful/common/services/camera_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/handlers/lifecycle_event_handler.dart';

class TakeImageViewModel extends ChangeNotifier {
  TakeImageViewModel() {
    _lifecycleEventHandler.init();
  }

  final CameraService cameraService = getIt.get<CameraService>();
  final _lifecycleEventHandler = LifecycleEventHandler();

  bool _isFlashTurnedOn = false;
  bool _isBackCameraOn = true;
  bool _hasTakenPicture = false;
  XFile? _capturedImage;

  bool get hasTakenPicture => _hasTakenPicture;
  XFile? get capturedImage => _capturedImage;

  bool get isFlashTurnedOn => _isFlashTurnedOn;
  set isFlashTurnedOn(bool value) {
    _isFlashTurnedOn = value;
    notifyListeners();
  }

  bool get isBackCameraOn => _isBackCameraOn;
  set isBackCameraOn(bool value) {
    _isBackCameraOn = value;
    notifyListeners();
  }

  CameraController? get cameraController => cameraService.cameraController;
  set cameraController(CameraController? controller) {
    cameraService.cameraController = controller;
  }

  Future<void> takePicture() async {
    try {
      await toggleFlash(shouldTurnOn: false);
      final picture = await cameraService.takePicture();
      if (picture != null) {
        _capturedImage = picture;
        _hasTakenPicture = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void discardPicture() {
    _hasTakenPicture = false;
    _capturedImage = null;
    notifyListeners();
  }

  Future<void> toggleFlash({required bool shouldTurnOn}) async {
    isFlashTurnedOn = shouldTurnOn;
    await cameraService.setFlashMode(
      shouldTurnOn ? FlashMode.always : FlashMode.off,
    );
  }

  Future<void> handleCameraPreview(AppLifecycleState state) async {
    if (cameraController == null ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      await cameraService.resumeCameraPreview();
    } else {
      await cameraService.pauseCameraPreview();
    }
  }

  @override
  void dispose() {
    cameraService.dispose();
    super.dispose();
  }
}
