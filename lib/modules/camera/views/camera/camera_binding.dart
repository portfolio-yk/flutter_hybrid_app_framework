import 'package:hybrid_module/modules/camera/views/camera/camera_controller.dart';
import 'package:get/get.dart';

class CameraBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraController>(() {
      return CameraController();
    });
  }
}
