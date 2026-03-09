import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewController extends FullLifeCycleController with FullLifeCycleMixin{

  static WebViewController get to => Get.find();

  static var firstWebViewUrl = "";

  final _webViewUrl = "".obs;

  get webViewUrl => _webViewUrl.value;

  static List<Function> _onInitFuncs = [];

  final _currentPage = "".obs;
  get currentPage => _currentPage.value;

  final _useResize = true.obs;
  get useResize => _useResize.value;

  @override
  void onInit() {
    for (var func in _onInitFuncs) {
      func();
    }
    _onInitFuncs = [];

    super.onInit();
  }

  @override
  void onPaused() {
    NativeCallHandler.instance.callEvent("onPaused", true);
  }

  @override
  void onResumed() {
    NativeCallHandler.instance.callEvent("onResumed", false);
  }

  @override
  void onDetached() {
    NativeCallHandler.instance.callEvent("onDetached", true);
  }
  @override
  void onInactive() {
    NativeCallHandler.instance.callEvent("onInactive", true);
  }
  @override
  void onHidden() {
    NativeCallHandler.instance.callEvent("onHidden", true);
  }

  WebViewController(firstWebViewUrl) {
    _webViewUrl.value = firstWebViewUrl;
  }

  static void addOnInitFuncs(Function function) {
    _onInitFuncs.add(function);
  }

  void androidBack() async {
    NativeCallHandler.instance.callEvent("androidBack", null);
  }

  void setCurrentPage(String page) {
    _currentPage.value = page;
  }

  goURL(url) async {
    var urlStr = url.toString();
    try {

      if (urlStr.startsWith("http") ||
          urlStr.startsWith("tel") ||
          urlStr.startsWith("smsto") ||
          urlStr.startsWith("mailto")) {

        await canLaunch(urlStr)
            ? await launch(urlStr, forceSafariVC: false, forceWebView: false)
            : throw "URL_ERROR".tr;
        return Future<NavigationActionPolicy>(
            () => NavigationActionPolicy.CANCEL);
      }
    } catch (e) {
      NativeCallHandler.instance.callEvent('openDialog', {'message': e.toString()});
      return Future<NavigationActionPolicy>(
          () => NavigationActionPolicy.CANCEL);
    }
  }

  turnOnResize() {
    _useResize.value = true;
  }

  turnOffResize() {
    _useResize.value = false;
  }

}
