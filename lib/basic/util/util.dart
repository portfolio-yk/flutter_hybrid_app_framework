import 'dart:convert';
import 'dart:io';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

exitApp() async {
  if (Platform.isIOS) {
    exit(0);
  } else if (Platform.isAndroid) {
    SystemNavigator.pop();
  }
}

get deviceId async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId;
  }
}

get storeUrl {
  if (Platform.isIOS) {
    return Config.iosStoreUrl;
  } else {
    return Config.androidStoreUrl;
  }
}



double getDoubleFromVersion(String version) {
  var re = RegExp('^(\\d+).(\\d+)\\.*(\\d*)\$');
  var match = re.firstMatch(version);
  return double.parse('${match!.group(1)}.${match.group(2)}${match.group(3)}');
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<String> getLatestAppVersion() async {
  try {
    return "0.0.0";
    // final newVersion = NewVersion(iOSId: "", androidId: Config.androidStoreId);
    // final status = await newVersion.getVersionStatus();
    // return status!.storeVersion;
  } catch (e) {
    return "0.0.0";
  }
  /*
  if (Platform.isIOS) {
    return await _getLatestIOSAppVersion();
  } else if (Platform.isAndroid) {
    return await _getLatestAndroidAppVersion();
  } else {
    return "0.0.0";
  } */
}


/*
Future<String> _getLatestAndroidAppVersion() async {
  try {
    final uri =
    Uri.parse(Config.androidStoreUrl);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Error();
    }

    final document = parse(response.body);
    final elements = document.getElementsByClassName('hAyfc');
    final versionElement = elements.firstWhere(
          (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    return versionElement.querySelector('.htlgb')!.text;
  } catch (e) {
    return "0.0.0";
  }
}

Future<dynamic> _getLatestIOSAppVersion() async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final id = packageInfo.packageName;
    var uri = Uri.https("itunes.apple.com", "/lookup", {"bundleId": id});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Error();
    }
    return json.decode(response.body)['results'][0]['version'];
  } catch (e) {
    return "0.0.0";
  }
}
*/
