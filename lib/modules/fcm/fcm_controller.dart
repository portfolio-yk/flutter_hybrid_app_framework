import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/basic/views/webview/webview_controller.dart';
import 'package:hybrid_module/modules/fcm/config/fcm_config.dart';
import './extension/extensions.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  //쉐어드 프리프런스에 해당 메시지 타입의 count가 1씩 증가한다. 추후 읽게 되면 이 count는 0이 된다.
  final localDataInfo = LocalData(
      key: message.data['msgTy'] ?? 'ALL' + '_COUNT', type: int, defaultValue: 0);
  int count = await getLocalData(localDataInfo);
  setLocalData(localDataInfo, count + 1);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  // ignore: avoid_print
  if (!(details.payload == null || details.payload == "")) {
    FcmController.instance!.pushUrl = details.payload!;
    NativeCallHandler.instance.restartWebView();
  }
}

class FcmController {
  FcmController._() {
    _init();
  }

  static FcmController? _instance;
  String? pushUrl = '';
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final AndroidNotificationChannel androidNotificationChannel;

  static FcmController get instance => _instance ??= FcmController._();


  void _init() async {
    print("FCM 생성!");
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint('fcm token :: ' + value!);
    });

    androidNotificationChannel = const AndroidNotificationChannel(
      'high_importance_channel', // 임의의 id
      'High Importance Notifications', // 설정에 보일 채널명
      importance: Importance.max,
    );



    // Notification Channel을 디바이스에 생성
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
          iOS: DarwinInitializationSettings()),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? initialMessage) {
      print('initialMessage data: ${initialMessage?.data}');
      pushUrl = initialMessage != null ? _convertToPushUrl(initialMessage) : '';
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');

      pushUrl = _convertToPushUrl(message);

      if (pushUrl != '') {
        NativeCallHandler.instance.restartWebView();
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      final pushUrl = _convertToPushUrl(message);

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        //블락될 url이 있는가?? 비어있군 그럼 Noti 띄우기
        if (FcmConfig.caseMap.entries
            .expand((element) => element.value.blockNotiUrls)
            .where((str) => str == WebViewController.to.currentPage)
            .isEmpty) {
          makeNotification(notification.title!, notification.body!,
              pushUrl: pushUrl);
        }
      }
    });
  }

  Future<bool> requestFcmPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    var androidPushNotiAuth = await instance!.flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();


    return settings.authorizationStatus == AuthorizationStatus.authorized ;
  }

  makeNotification(String title, String body, {String? pushUrl}) {
    instance!.flutterLocalNotificationsPlugin.show(
        10000,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidNotificationChannel.id,
            androidNotificationChannel.name,
          ),
        ),
        payload: pushUrl);
  }

  Future<bool> subscribeTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      final localDataInfo =
      LocalData(key: topic, type: bool, defaultValue: null);
      setLocalData(localDataInfo, true);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> unsubscribeTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      final localDataInfo =
      LocalData(key: topic, type: bool, defaultValue: null);
      setLocalData(localDataInfo, false);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  String _convertToPushUrl(RemoteMessage message) {
    final currentCase = FcmConfig.caseMap[message.data['msgTy']];

    if (currentCase != null) {
      final pushStack = currentCase.pushUrl;
      final paramName = currentCase.paramName;

      if (paramName != null) {
        return pushStack.addParameter({paramName: message.data['seq'] ?? ''});
      } else {
        return pushStack;
      }
    } else {
      return '';
    }
  }

  Future getFcmToken() async {
    final result = await FirebaseMessaging.instance.getToken();
    for (var element in FcmConfig.topicMap.entries) {
      if (element.value) {
        instance.subscribeTopic(element.key);
      } else {
        instance.unsubscribeTopic(element.key);
      }
    }
    return result;
  }
}