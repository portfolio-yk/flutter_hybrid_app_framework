import 'package:hybrid_module/modules/camera/views/camera/camera_controller.dart';
import 'package:hybrid_module/modules/camera/views/gallery/gallery_controller.dart';
import 'package:get/get.dart';

class GalleryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(() {
      return GalleryController();
    });
  }
}
