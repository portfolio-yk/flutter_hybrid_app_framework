import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:hybrid_module/basic/const/const.dart';
import 'package:hybrid_module/basic/data/model/test_user_model.dart';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/util/file.dart';
import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/basic/views/download/download_arguments.dart';
import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:hybrid_module/basic/util/util.dart' as util;


initWebViewSetting(String webViewUrl, bool isContentsUpdateApp) async {
  if (webViewUrl.contains('http') == false) {
    if (isContentsUpdateApp == false) {
      WebViewController.firstWebViewUrl = webViewUrl;
    } else {
      final path = await localPath;
      WebViewController.firstWebViewUrl = '$path/$webViewUrl';
    }
  } else {
    WebViewController.firstWebViewUrl = webViewUrl;
  }
}

setBaseUrl() async {
  try {
    String deviceId = await util.deviceId;

    TestUserModel? testUser =
    await MyRepository().getTestUser(deviceId: deviceId);

    if (testUser != null) {
      if (testUser.useAt == Yn.Y) {
        Config.setCustomUrl(testUser.url);
      }
    }
  } catch(e) {
    debugPrint(e.toString());
    return false;
  }
}

getInitialRoute(bool isContentsUpdateApp) async {
  try {
    String initialRoute;
    if (isContentsUpdateApp == false) {
      //앱 업데이트 체크만 함
      if (await _getShouldAppUpdate()) {
        var arguments = DownloadArguments(type: DownloadArgType.appUpdate);
        initialRoute = Routes.download + arguments.toQueryString();
      } else {
        initialRoute = Routes.webView;
      }
    } else {
      //앱 업데이트 체크 후 컨텐츠 업데이트 체크
      if (await _getShouldAppUpdate()) {
        var arguments = DownloadArguments(type: DownloadArgType.appUpdate);
        initialRoute = Routes.download + arguments.toQueryString();
      } else {
        if (await _getShouldContentUpdate()) {
          var arguments =
              DownloadArguments(type: DownloadArgType.contentsUpdate);
          initialRoute = Routes.download + arguments.toQueryString();
        } else {
          initialRoute = Routes.webView;
        }
      }
    }

    return initialRoute;
  } catch (e) {
    debugPrint(e.toString());
    var arguments = DownloadArguments(type: DownloadArgType.error);
    return Routes.download + arguments.toQueryString();
  }
}

_getShouldAppUpdate() async {
  //app 업데이트 확인
  var appVersion = await util.getAppVersion();
  var marketVersion = await util.getLatestAppVersion();

  return util.getDoubleFromVersion(appVersion) <
      util.getDoubleFromVersion(marketVersion);
}

_getShouldContentUpdate() async {
  try {
    //컨텐츠 업데이트 확인
    String latestVersion = await MyRepository().getLatestContentsVersion();
    String myVersion = await getLocalData(LocalData.contentsVersion);

    return util.getDoubleFromVersion(myVersion) <
        util.getDoubleFromVersion(latestVersion);
  } catch(e) {
    debugPrint(e.toString());
    return false;
  }
}
