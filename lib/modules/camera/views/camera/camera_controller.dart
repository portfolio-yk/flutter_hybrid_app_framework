import 'dart:convert';
import 'dart:io';
import 'package:hybrid_module/basic/data/provider/api.dart';
import 'package:hybrid_module/basic/util/http.dart';
import 'package:hybrid_module/modules/camera/config/camera_config.dart';
import 'package:hybrid_module/modules/camera/components/camera_icons.dart';
import 'package:hybrid_module/modules/camera/data/camera_option.dart';
import 'package:hybrid_module/modules/camera/data/camera_result.dart';
import 'package:hybrid_module/modules/camera/data/enums.dart';
import 'package:camera/camera.dart' as camera;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class CameraController extends GetxController {
  late camera.CameraController controller;
  late List<camera.CameraDescription> cameras;
  late VideoPlayerController videoPlayerController;

  File? captureImage;
  DateTime? _captureDate;

  final _appBarTitle = "".obs;

  get appBarTitle => _appBarTitle;

  final _isLoading = true.obs;

  get isLoading => _isLoading.value;

  final _isTakePicture = false.obs;

  get isTakePicture => _isTakePicture.value;

  final _isRecording = false.obs; // >>???
  get isRecording => _isRecording.value;

  final _flashMode = camera.FlashMode.auto.obs;

  get flashMode => _flashMode.value;

  final _isShowTimeStamp = true.obs;

  get isShowTimeStamp => _isShowTimeStamp.value;

  final _cameraMode = CameraMode.normal.obs;

  get cameraMode => _cameraMode.value;

  final _timeStamp = DateTime.now().obs;

  get timeStamp => DateFormat('yy MM dd hh:mm').format(_timeStamp.value);

  final _filePath = "".obs;

  get filePath => _filePath.value;

  late List<Widget> _cameraBottomBar = <Widget>[].obs;

  get cameraBottomBar => _cameraBottomBar;

  late List<Widget> _completeBottomBar = <Widget>[].obs;

  get completeBottomBar => _completeBottomBar;

  late CameraOption cameraOption;

  CameraController();

  @override
  void onInit() async {
    if (Get.currentRoute == "/cameraPreview") {
      _filePath.value = Get.arguments;
    } else {
      cameraOption = CameraOption.fromJson(Get.arguments);
      _setCameraView(cameraOption);
      cameras = await camera.availableCameras();
      controller =
          camera.CameraController(cameras[0], camera.ResolutionPreset.medium);
      controller.initialize().then((value) => _isLoading.value = false);
    }
    super.onInit();
  }

  @override
  void onClose() {
    if (cameraOption.isCamera) {
      controller.dispose();
    }
    if (cameraOption.isVideo) {
      videoPlayerController.dispose();
    }
    super.onClose();
  }

  _setCameraView(CameraOption option) {
    _appBarTitle.value = option.title!;

    List<Widget> cameraBtnList = <Widget>[];
    if (option.isSelf) {
      cameraBtnList.add(
          CameraIcons(icon: CameraConfig.changeModeIcon, onTap: changeMode));
    }
    if (option.isVideo) {
      cameraBtnList.add(Obx(() => CameraIcons(
          icon: _isRecording.value
              ? CameraConfig.videoStop
              : CameraConfig.videoPlay,
          onTap: recordVideo)));
    }
    if (option.isCamera) {
      cameraBtnList
          .add(CameraIcons(icon: CameraConfig.cameraIcon, onTap: takePicture));
    }
    if (option.isFlash) {
      cameraBtnList.add(Obx(() =>
          CameraIcons(icon: getFlashIcon(flashMode), onTap: toggleAutoFlash)));
    }
    _cameraBottomBar = cameraBtnList;

    _completeBottomBar = <Widget>[
      CameraIcons(icon: CameraConfig.undoIcon, onTap: retry),
      CameraIcons(icon: CameraConfig.uploadIcon, onTap: downloadPicture),
    ];
  }

  takePicture() async {
    final shouldToReversePicture = _cameraMode.value == CameraMode.self;
    try {
      if (_isLoading.value == false) {
        await controller.takePicture().then((value) async {
          _captureDate = _timeStamp.value;
          captureImage = File(value.path);

          if (shouldToReversePicture) {
            final originalImg =
                decodeImage(await File(value.path).readAsBytes());
            final orientedImg = flipHorizontal(originalImg!);

            await File(value.path).writeAsBytes(encodeJpg(orientedImg));
          }

          _isTakePicture.value = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  playVideo(filePath) async {
    videoPlayerController = VideoPlayerController.file(File(filePath));
    await videoPlayerController.initialize();
    await videoPlayerController.setLooping(true);
    await videoPlayerController.play();
    _isLoading.value = false;
  }

  recordVideo() async {
    if (_isRecording.value) {
      final file = await controller.stopVideoRecording();
      _filePath.value = file.path;
      _isRecording.value = false;
      bool isOk = await Get.toNamed('/cameraPreview');
      if (isOk) {
        Get.back(
            result: CameraResult(code: CameraCode.success, filePath: filePath));
        videoPlayerController.dispose();
      }
    } else {
      await controller.prepareForVideoRecording();
      await controller.startVideoRecording();
      _isRecording.value = true;
    }
  }

  downloadPicture() async {
    GallerySaver.saveImage(captureImage!.path).then((success) async {
      var imageBytes = await captureImage!.readAsBytes();
      Get.back(
          result: CameraResult(
              code: CameraCode.success,
              date: _captureDate,
              imgData: ("data:image/jpeg;base64," + base64Encode(imageBytes))));
    });
    controller.dispose();
  }

  changeMode() async {
    _isLoading.value = true;

    await controller.dispose();

    if (_cameraMode.value == CameraMode.normal) {
      _cameraMode.value = CameraMode.self;
      controller =
          camera.CameraController(cameras[1], camera.ResolutionPreset.high);
    } else {
      _cameraMode.value = CameraMode.normal;
      controller =
          camera.CameraController(cameras[0], camera.ResolutionPreset.high);
    }

    controller.initialize().then((value) => _isLoading.value = false);
  }

  retry() async {
    _isTakePicture.value = false;
    captureImage?.delete();
    _captureDate = null;
  }

  removeTimeStamp() {
    _isShowTimeStamp.value = false;
  }

  toggleAutoFlash() {
    switch (flashMode) {
      case camera.FlashMode.auto:
        _flashMode.value = camera.FlashMode.off;
        break;
      case camera.FlashMode.off:
        _flashMode.value = camera.FlashMode.always;
        break;
      case camera.FlashMode.always:
      default:
        _flashMode.value = camera.FlashMode.auto;
    }

    controller.setFlashMode(_flashMode.value);
  }

  Widget getFlashIcon(camera.FlashMode flashMode) {
    switch (flashMode) {
      case camera.FlashMode.auto:
        return CameraConfig.flashAutoIcon;
      case camera.FlashMode.off:
        return CameraConfig.flashOffIcon;
      case camera.FlashMode.always:
      default:
        return CameraConfig.flashOnIcon;
    }
  }
}
