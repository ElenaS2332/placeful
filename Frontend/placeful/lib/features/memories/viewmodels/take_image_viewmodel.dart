import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:placeful/common/handlers/lifecycle_event_handler.dart';
import 'package:placeful/common/services/camera_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class TakeImageViewModel extends ChangeNotifier {
  TakeImageViewModel() {
    _lifecycleEventHandler.init();
  }

  final ImagePicker _picker = ImagePicker();

  final CameraService cameraService = getIt.get<CameraService>();
  final _lifecycleEventHandler = LifecycleEventHandler();
  bool _isFlashTurnedOn = false;
  bool _isBackCameraOn = true;

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

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;
  set cameraController(CameraController? value) {
    _cameraController = value;
    cameraService.cameraController = _cameraController;
  }

  List<AssetEntity> _galleryImages = [];
  List<AssetEntity> get galleryImages => _galleryImages;

  Future<void> openCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _selectedImage = pickedFile;
        notifyListeners();
      }
    }
  }

  Future<void> loadGalleryImages() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (albums.isNotEmpty) {
        final recent = albums.first;
        _galleryImages = await recent.getAssetListRange(
          start: 0,
          end: 30,
        ); // latest 30
        notifyListeners();
      }
    }
  }

  void selectFromGallery(AssetEntity entity) async {
    final file = await entity.file;
    if (file != null) {
      _selectedImage = XFile(file.path);
      notifyListeners();
    }
  }

  Future<void> takePicture() async {
    try {
      _lifecycleEventHandler.onLifecycleChange = null;

      final picture = await cameraService.takePicture();
      await toggleFlash(shouldTurnOn: false);
      await cameraService.pauseCameraPreview();

      final snapShotDataInBytes = await picture!.readAsBytes();

      // navigationService
      //     .replaceCurrent<DisplayPicturePage, DisplayPictureViewModel>(
      //   initParams: {
      //     imageBytes: snapShotDataInBytes,
      //     rideData: ride,
      //   },
      // );
    } catch (e) {
      // loggerService.logError(e.toString(), errorTitle: 'Camera error');
    }
  }

  Future<void> toggleFlash({required bool shouldTurnOn}) async {
    isFlashTurnedOn = shouldTurnOn;

    if (isFlashTurnedOn) {
      await cameraService.setFlashMode(FlashMode.always);
    } else {
      await cameraService.setFlashMode(FlashMode.off);
    }
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
}
