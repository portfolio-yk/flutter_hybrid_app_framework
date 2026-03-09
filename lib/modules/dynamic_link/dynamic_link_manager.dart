// import 'dart:convert';

// import 'package:hybrid_module/basic/const/const.dart';
// import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
// import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
// import 'package:hybrid_module/basic/config/basic_config.dart';
// import 'package:hybrid_module/modules/dynamic_link/config/dynamiclink_config.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:share/share.dart';

// class DynamicLinkManager {
//   final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;
//   String dynamicLinkUrl = '';

//   static final DynamicLinkManager instance = DynamicLinkManager._internal();

//   DynamicLinkManager._internal();

//   static init({required String packageName, required String dynamicLinkPrefix}) {
//     DynamicLinkConfig.packageName = packageName;
//     DynamicLinkConfig.dynamicLinkPrefix = dynamicLinkPrefix;

//     DynamicLinkManager.instance._init();
//   }

//   _init() {
//     final nativeCallHandler = NativeCallHandler.instance;

//     WebViewController.addOnInitFuncs(() {
//       DynamicLinkManager.instance
//           .initDynamicLinks(nativeCallHandler.restartWebView);
//     });

//     nativeCallHandler.addCallBack(
//         name: 'getDynamicLinkUrl',
//         callback: (args) async {
//           final result = DynamicLinkManager.instance.dynamicLinkUrl;
//           DynamicLinkManager.instance.dynamicLinkUrl = '';
//           try {
//             //Home/travelDetial?seq=12314124
//             return result.split('&')[1].split('=')[1];
//           } catch (e) {
//             return '';
//           }
//         });

//     nativeCallHandler.addCallBack(
//         name: 'share',
//         callback: (args) async {
//           final dynamicLinkUrl = await DynamicLinkManager.instance
//               .createDynamicLink(args[1], true);
//           await Share.share(args[0] + '\r\n\r\n' + dynamicLinkUrl);
//         });
//     nativeCallHandler.addCallBack(
//         name: 'createDynamicLink',
//         callback: (args) async {
//           return DynamicLinkManager.instance
//               .createDynamicLink(args[0], args[1]);
//         });
//   }

//   //this.$nativ.basic.share('travelDetail=123');
// //this.$native.dynamicLink.createDynamicLink('')
//   Future<void> initDynamicLinks(Function onResume) async {
//     PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     Uri? deepLink = data?.link;
//     if (deepLink != null) {
//       dynamicLinkUrl = deepLink.toString();
//     }
//     //page=travel?seq=1/dewtial/
//     _dynamicLinks.onLink.listen((dynamicLinkData) {
//       dynamicLinkUrl = dynamicLinkData.link.query;
//       onResume();
//     }).onError((error) {
//       debugPrint(error.message);
//       dynamicLinkUrl = '';
//     });
//   }

//   Future<String> createDynamicLink(String text, bool short) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://${DynamicLinkConfig.dynamicLinkPrefix}',
//       link: Uri.parse('${Config.androidStoreUrl}&page=$text'),
//       androidParameters: AndroidParameters(
//         packageName: DynamicLinkConfig.packageName,
//         minimumVersion: 0,
//       ),
//       iosParameters: IOSParameters(
//         bundleId: DynamicLinkConfig.packageName,
//         minimumVersion: '0',
//       ),
//     );

//     Uri url;
//     if (short) {
//       final ShortDynamicLink shortLink =
//           await _dynamicLinks.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//     } else {
//       url = await _dynamicLinks.buildLink(parameters);
//     }

//     return url.toString();
//   }
// }
