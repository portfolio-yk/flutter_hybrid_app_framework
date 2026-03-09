import 'package:hybrid_module/modules/camera/views/camera/camera_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CameraPreviewPage extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Get.back(result: true);
            },
          )
        ],
      ),
      body: GetX<CameraController>(
        initState: (state) async {
          final _ = Get.find<CameraController>();
          _.playVideo(_.filePath);
        },
        builder: (_) {
          return _.isLoading
              ? const Center(child: CircularProgressIndicator())
              : VideoPlayer(_.videoPlayerController);
        },
      ),
    );
  }
}
