import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'instagram_controller.dart';

class InstagramBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstagramController>(() {
      return InstagramController();
    });
  }
}