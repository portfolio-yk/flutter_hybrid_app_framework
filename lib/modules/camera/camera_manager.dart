import 'dart:io';

import 'package:hybrid_module/basic/data/provider/api.dart';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/routes/app_pages.dart';
import 'package:hybrid_module/basic/util/http.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:hybrid_module/modules/camera/data/camera_result.dart';
import 'package:hybrid_module/modules/camera/views/camera/camera_binding.dart';
import 'package:hybrid_module/modules/camera/views/camera/camera_page.dart';
import 'package:hybrid_module/modules/camera/views/camera/camera_preview_page.dart';
import 'package:hybrid_module/modules/camera/views/gallery/gallery_binding.dart';
import 'package:hybrid_module/modules/camera/views/gallery/gallery_page.dart';
import 'package:camera/camera.dart' as camera;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CameraManager {
  static void init() {
    AppPages.pages.add(GetPage(
        name: '/camera',
        page: () => CameraPage(),
        binding: CameraBinding()));

    AppPages.pages.add(GetPage(
        name: '/gallery',
        page: () => GalleryPage(),
        binding: GalleryBinding()));
    AppPages.pages.add(GetPage(
        name: '/cameraPreview',
        page: () => CameraPreviewPage(),
        binding: CameraBinding()));



    NativeCallHandler.instance.addCallBack(name: 'openCamera', callback: (args) async {
      final CameraResult result = await Get.toNamed('/camera', arguments:  args.isNotEmpty ? args[0] : {});
      return result.toJson();
    });
    NativeCallHandler.instance.addCallBack(name: "openGallery", callback: (args) async {
      final CameraResult result = await Get.toNamed('/gallery');
      return result.toJson();
    });

    NativeCallHandler.instance.addCallBack(name: "openCameraPreview", callback: (args) async {
      final CameraResult result = await Get.toNamed('/cameraPreview', arguments: args[0]);
      return result.toJson();
    });

  }
}