import 'dart:io';

import 'package:hybrid_module/modules/camera/data/camera_result.dart';
import 'package:hybrid_module/modules/camera/data/enums.dart';
import 'package:hybrid_module/modules/camera/views/camera/camera_controller.dart';
import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraPage extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Get.find<CameraController>()
              .appBarTitle
              .toString(), //'TAKE_MISSION'.tr,
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.back(result: CameraResult(code: CameraCode.cancel));
              },
              icon: const Icon(Icons.close))
        ],
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: GetX<CameraController>(
        initState: (state) {
          Get.find<CameraController>();
        },
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: _.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                      width: double.infinity,
                      child: _.isTakePicture == false
                          ? camera.CameraPreview(_.controller)
                          : Image.file(
                        File(_.captureImage!.path),
                        fit: BoxFit.cover,
                      )),
                ),
                Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: getBottomButtons(_))),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> getBottomButtons(CameraController controller) {
    return controller.isTakePicture == false
        ? controller.cameraBottomBar
        : controller.completeBottomBar;
  }
}