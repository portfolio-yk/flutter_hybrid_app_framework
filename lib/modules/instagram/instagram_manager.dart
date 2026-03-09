import 'package:hybrid_module/basic/routes/app_pages.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/modules/instagram/config/instagram_config.dart';
import 'package:hybrid_module/modules/instagram/data/instagram_result.dart';
import 'package:hybrid_module/modules/instagram/views/instagram_binding.dart';
import 'package:hybrid_module/modules/instagram/views/instgram_page.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramManager {
  static init({
  required String clientID, required appSecret, required String redirectUri, required String scope, required String responseType}) {
    InstagramConfig.clientID = clientID;
    InstagramConfig.appSecret = appSecret;
    InstagramConfig.redirectUri = redirectUri;
    InstagramConfig.scope = scope;
    InstagramConfig.responseType = responseType;

    InstagramManager()._init();
  }

  _init() {
    print("인스타 init!");
    AppPages.pages.add(GetPage(
        name: '/instagram',
        page: () => InstagramPage(),
        binding: InstagramBinding()));

    NativeCallHandler.instance.addCallBack(name: 'getInstagramProfile', callback: (args) async {
        final InstagramResult result = await Get.toNamed('/instagram');
        print("결과는 :: ${result.toJson()}");
        return result.toJson();
    });
    NativeCallHandler.instance.addCallBack(name: 'openInstagram', callback: (args) async {
      print(args[0]);
      await launch("https://www.instagram.com/${args[0]}/?hl=ko");
      return true;
    });
  }
}