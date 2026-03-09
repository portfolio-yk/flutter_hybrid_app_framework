import 'dart:io' show Platform;

import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewPage extends GetView<WebViewController> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetX<WebViewController>(
        initState: (state) {
          Get.find<WebViewController>();
        },
        builder: (_) {
          print("file://${_.webViewUrl.replaceAll('/index.html', '')}");
          return Scaffold(
            resizeToAvoidBottomInset: _.useResize,
            body: SafeArea(
              child: WillPopScope(
                onWillPop: () async {
                  _.androidBack();
                  return false;
                },
                child: InAppWebView(
                    initialFile: Config.isContentsUpdateApp == false
                        ? _.webViewUrl
                        : null,
                    initialUrlRequest: Config.isContentsUpdateApp == true
                        ? Platform.isIOS
                            ? URLRequest(
                                url: Uri.parse("file://${_.webViewUrl}"))
                            : URLRequest(
                                url: Uri.parse(_.webViewUrl))
                        : null,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        allowFileAccessFromFileURLs: true,
                        allowUniversalAccessFromFileURLs: true,
                        javaScriptEnabled: true,
                        supportZoom: false,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                        thirdPartyCookiesEnabled: true,
                        mixedContentMode:
                            AndroidMixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
                      ),
                      ios: IOSInAppWebViewOptions(
                        allowsBackForwardNavigationGestures: false,
                        allowsInlineMediaPlayback: true,
                        allowingReadAccessTo: Uri.parse(
                            "file://${_.webViewUrl.replaceAll('/index.html', '')}"),
                      ),
                    ),
                    androidOnGeolocationPermissionsShowPrompt:
                        (InAppWebViewController controller,
                            String origin) async {
                      return GeolocationPermissionShowPromptResponse(
                          origin: origin, allow: true, retain: true);
                    },
                    onWebViewCreated: (controller) {
                      NativeCallHandler.init(controller, context);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      return await _.goURL(navigationAction.request.url);
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    }),
              ),
            ),
          );
        },
      ),
    );
  }
}
