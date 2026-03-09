import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
import 'package:get/get.dart';

class WebViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebViewController>(() {
      return WebViewController(WebViewController.firstWebViewUrl);
    });
  }
}