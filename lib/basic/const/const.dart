import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:hybrid_module/basic/const/translations/ko_KR.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class OsType {
  static const android = 'android';
  static const ios = 'ios';
}

abstract class DownloadArgType {
  static const timeoutError = 'timeoutError';
  static const error = 'error';
  static const contentsUpdate = 'contentsUpdate';
  static const appUpdate = 'appUpdate';
}

const Map<String, Permission> permissions = {
  'calendar' : Permission.calendar,
  'camera' : Permission.camera,
  'contacts' : Permission.contacts,
  'location' : Permission.location,
  'locationAlways' : Permission.locationAlways,
  'locationWhenInUse' : Permission.locationWhenInUse,
  'mediaLibrary' : Permission.mediaLibrary,
  'microphone' : Permission.microphone,
  'phone' : Permission.phone,
  'photos' : Permission.photos,
  'photosAddOnly' : Permission.photosAddOnly,
  'reminders' : Permission.reminders,
  'sensors' : Permission.sensors,
  'sms' : Permission.sms,
  'speech' : Permission.speech,
  'storage' : Permission.storage,
  'ignoreBatteryOptimizations' : Permission.ignoreBatteryOptimizations,
  'notification' : Permission.notification,
  'accessMediaLocation' : Permission.accessMediaLocation,
  'activityRecognition' : Permission.activityRecognition,
  'unknown' : Permission.unknown,
  'bluetooth' : Permission.bluetooth,
  'manageExternalStorage' : Permission.manageExternalStorage,
  'systemAlertWindow' : Permission.systemAlertWindow,
  'requestInstallPackages' : Permission.requestInstallPackages,
  'appTrackingTransparency' : Permission.appTrackingTransparency,
  'criticalAlerts' : Permission.criticalAlerts,
  'accessNotificationPolicy' : Permission.accessNotificationPolicy,
  'bluetoothScan' : Permission.bluetoothScan,
  'bluetoothAdvertise' : Permission.bluetoothAdvertise,
  'bluetoothConnect' : Permission.bluetoothConnect,
  'nearbyWifiDevices' : Permission.nearbyWifiDevices,
  'videos' : Permission.videos,
  'audio' : Permission.audio,
  'scheduleExactAlarm' : Permission.scheduleExactAlarm
};

abstract class Yn {
  static const Y = 'Y';
  static const N = 'N';
}

enum DownloadType {
  success,
  networkError,
  zipError,
  defaultError,
}

abstract class Routes {
  static const download = '/download';
  static const webView = '/webview';
}

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'ko_KR': koKr,
  };
}
