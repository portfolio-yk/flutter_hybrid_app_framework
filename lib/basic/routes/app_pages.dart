import 'package:hybrid_module/basic/const/const.dart';
import 'package:hybrid_module/basic/views/download/download_binding.dart';
import 'package:hybrid_module/basic/views/download/download_page.dart';
import 'package:hybrid_module/basic/views/webview/webview_binding.dart';
import 'package:hybrid_module/basic/views/webview/webview_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.webView,
        page: () => WebViewPage(),
        binding: WebViewBinding()),
    GetPage(
        name: Routes.download,
        page: () => const DownloadPage(),
        binding: DownloadBinding()),
  ];
}

