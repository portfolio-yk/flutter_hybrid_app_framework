library cms_module;

import 'dart:async';
import 'dart:io';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:hybrid_module/basic/const/const.dart';
import 'package:hybrid_module/basic/routes/app_pages.dart';
import 'package:hybrid_module/basic/views/download/download_arguments.dart';
import 'package:hybrid_module/main_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:hybrid_module/modules/hybrid_manager.dart';


class HybridApp {
  HybridApp.runApp(CmsConfig cmsConfig) {
    _install(cmsConfig);
  }


  Future<HybridApp> _install(CmsConfig cmsConfig) async {
    String initialRoute;
    try {
      if (Config.orientations.isNotEmpty) {
        SystemChrome.setPreferredOrientations(Config.orientations);
      }
      if (Platform.isAndroid) {
        AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
            Config.isDebugMode);
      }

      setConfig(cmsConfig);

      await setBaseUrl();

      await initWebViewSetting(Config.webViewUrl, Config.isContentsUpdateApp);

      initialRoute = await getInitialRoute(Config.isContentsUpdateApp);
    }on TimeoutException catch (e, s) {
      debugPrint(s.toString());
      var arguments = DownloadArguments(type: DownloadArgType.timeoutError);
      initialRoute = Routes.download + arguments.toQueryString();
    } catch (e, s) {
      debugPrint(s.toString());
      var arguments = DownloadArguments(type: DownloadArgType.error);
      initialRoute = Routes.download + arguments.toQueryString();
    }

    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      defaultTransition: Transition.fade,
      getPages: AppPages.pages,
      locale: const Locale('ko', 'KR'),
      translationsKeys: AppTranslation.translations,
    ));

    return this;
  }

  HybridApp use(HybridManager hybridManager, {Map<String, dynamic>? options}) {
    hybridManager.init(options);
    return this;
  }


}

class CmsConfig {
  //앱 이름
  String appName = '';
  //웹뷰 시작 화면
  String webViewUrl = '';
  // Orientation 설정
  List<DeviceOrientation> orientations = [];
  //다운로드 화면 로고, 배경 화면 설정
  String downloadImageUrl = '';
  int downloadBackgroundColor = 0xFFFFFFFF;
  Color textColor = Colors.black;
  //플레이스토어 앱id
  String androidStoreId = '';
  //앱스토어 앱 id
  String iosStoreId = '';
  //안드로이드 실행 시, chrome inspect 활성화 여부
  bool isDebugMode = true;
  //컨텐츠 업데이트 활성화 여부
  bool isContentsUpdateApp = false;
  //서버 통신 url
  String baseUrl;

  CmsConfig({required appName, required webViewUrl, List<DeviceOrientation>? orientations, String? downloadImageUrl,String? downloadBackgroundColor,Color? textColor,String? androidStoreId
    ,String? iosStoreId,required bool isDebugMode,required bool isContentsUpdateApp, required String baseUrl}) :
        appName = appName,
        webViewUrl = webViewUrl,
        baseUrl = baseUrl,
        isContentsUpdateApp = isContentsUpdateApp,
        isDebugMode = isDebugMode,
        orientations = orientations ?? [],
        androidStoreId = androidStoreId ?? '',
        iosStoreId = iosStoreId ?? '',
        textColor = textColor ?? Colors.black,
        downloadImageUrl = downloadImageUrl ?? '';
}


setConfig(CmsConfig cmsConfig) {
  //required
  Config.isContentsUpdateApp = cmsConfig.isContentsUpdateApp;
  Config.isDebugMode = cmsConfig.isDebugMode;
  Config.webViewUrl = cmsConfig.webViewUrl;
  Config.appName = cmsConfig.appName;
  Config.setBaseUrl(cmsConfig.baseUrl);

  //선택
  Config.orientations = cmsConfig.orientations;
  Config.androidStoreId = cmsConfig.androidStoreId;
  Config.iosStoreId = cmsConfig.iosStoreId;
  Config.downloadBackgroundColor = cmsConfig.downloadBackgroundColor;
  Config.downloadImageUrl = cmsConfig.downloadImageUrl;
  Config.textColor = cmsConfig.textColor;

  return true;
}