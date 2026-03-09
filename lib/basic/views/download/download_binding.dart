import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/views/download/download_controller.dart';
import 'package:get/get.dart';

class DownloadBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadController>(() {
      return DownloadController(repository: MyRepository());
    });
  }
}
