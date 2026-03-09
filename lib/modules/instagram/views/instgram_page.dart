import 'dart:io';
import 'dart:typed_data';

import 'package:hybrid_module/modules/camera/data/camera_result.dart';
import 'package:hybrid_module/modules/camera/data/enums.dart';
import 'package:hybrid_module/modules/camera/views/camera/camera_controller.dart';
import 'package:hybrid_module/modules/camera/views/gallery/gallery_controller.dart';
import 'package:camera/camera.dart' as camera;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'instagram_controller.dart';

import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class InstagramPage extends GetView<InstagramController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<InstagramController>(
        initState: (state) {
          Get.find<InstagramController>();
        },
        builder: (_) {
          return SafeArea(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_.url.value)),
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
                  allowsInlineMediaPlayback: true,
                ),
              ),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                return await _.goURL(navigationAction.request.url);
              },
            ),
          );
        },
      ),
    );
  }
}
