import 'dart:async';
import 'dart:convert';

import 'package:hybrid_module/basic/const/const.dart';
import 'package:hybrid_module/basic/util/http.dart';
import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/basic/util/util.dart' as util;
import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailto/mailto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

part 'basic_callbacks.dart';

class NativeCallHandler {
  InAppWebViewController? webViewController;
  late BuildContext context;
  final platform = const MethodChannel('intent');

  final Map<String, Function(List<dynamic>)> _callbacks = getBasicCallBacks();

  static final NativeCallHandler instance = NativeCallHandler._internal();

  static init(InAppWebViewController controller, BuildContext context) {
    instance.webViewController = controller;
    instance.context = context;
    instance._callbacks.forEach((funcName, callback) {
      instance._addHandler(handlerName: funcName, callback: callback);
    });
  }

  NativeCallHandler._internal();

  void restartWebView() {
    if (webViewController != null) {
      if (Config.isContentsUpdateApp == false) {
        webViewController?.loadFile(
            assetFilePath: WebViewController.firstWebViewUrl);
      } else {
        webViewController?.loadUrl(
            urlRequest:
                URLRequest(url: Uri.parse(WebViewController.firstWebViewUrl)));
      }
    }
  }

  addCallBack(
      {required String name,
      required Future Function(List<dynamic>) callback}) {
    _callbacks[name] = callback;
  }

  _addHandler(
      {required String handlerName,
      required JavaScriptHandlerCallback callback}) {
    webViewController?.addJavaScriptHandler(
      handlerName: handlerName,
      callback: callback,
    );
  }

  void callEvent(name, detail) {
    var detailStr = detail;
    if (detail is Map) detailStr = jsonEncode(detail);
    print(detailStr);
    final source = '''
      var customEvent = new CustomEvent('$name', { detail: $detailStr } );
      window.dispatchEvent(customEvent);
    ''';
    webViewController!.evaluateJavascript(source: source);
  }
}
