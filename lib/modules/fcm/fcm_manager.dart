import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/hybrid_manager.dart';
import 'package:hybrid_module/modules/fcm/config/fcm_config.dart';
import 'package:hybrid_module/modules/fcm/fcm_controller.dart';
import 'package:hybrid_module/modules/fcm/model/fcm_message_case.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';



class FcmManager implements HybridManager<Map<String, FcmMessageCase>>{

  @override
  void init(Map<String, FcmMessageCase>? fcmCaseMap) async {
    if(fcmCaseMap != null) {
      FcmConfig.add(fcmCaseMap);
    }
    _init();
  }


  _init() async {
    FcmController fcmController = FcmController.instance;

    NativeCallHandler.instance.addCallBack(
        name: 'requestFcmPermission',
        callback: (args) async {
          final bool isFcmPermissionExist = (args[0] as List)
                  .firstWhereOrNull((element) => element == 'fcm') !=
              null;
          if (isFcmPermissionExist) {
            return await fcmController.requestFcmPermission();
          } else {
            debugPrint("FCM 권한 안보내면서 FCM 보낸다고??");
            return false;
          }
        });

    //읽음 처리. 인자 넘겨주면 해당 메시지 타입의 count을 0으로, 안 넘기면 모든 count을 0으로 만든다.
    NativeCallHandler.instance.addCallBack(
        name: 'readMessage',
        callback: (args) async {
          if (args.isEmpty) {
            for (var element in FcmConfig.caseMap.entries) {
              final localDataInfo = LocalData(
                  key: element.key + '_COUNT', type: int, defaultValue: 0);
              setLocalData(localDataInfo, 0);
            }
          } else {
            final localDataInfo =
                LocalData(key: args[0] + '_COUNT', type: int, defaultValue: 0);
            setLocalData(localDataInfo, 0);
          }
        });

    //안 읽은 메시지 개수를 리턴한다. 인자를 안 넘기면 전체 수, 넘기면 해당 타입의 count 수
    NativeCallHandler.instance.addCallBack(
        name: 'getMessageCount',
        callback: (args) async {
          int count = 0;
          if (args.isEmpty) {
            for (var element in FcmConfig.caseMap.entries) {
              final localDataInfo = LocalData(
                  key: element.key + '_COUNT', type: int, defaultValue: 0);
              final int keyCount = await getLocalData(localDataInfo);
              count += keyCount;
            }
          } else {
            final localDataInfo =
                LocalData(key: args[0] + '_COUNT', type: int, defaultValue: 0);
            count = await getLocalData(localDataInfo);
          }
          return count;
        });

    //fcm token 전달
    NativeCallHandler.instance.addCallBack(
        name: 'getFcmToken',
        callback: (args) async {
          final pushNoti = await getLocalData(LocalData(
              key: 'isAllowPushNoti', type: bool, defaultValue: true));
          final String? token = pushNoti ? await fcmController.getFcmToken() : '';
          return token ?? '';
        });

    //pushUrl 전달
    NativeCallHandler.instance.addCallBack(
        name: 'getPushUrl',
        callback: (args) async {
          final result = fcmController.pushUrl;
          fcmController.pushUrl = '';

          return result;
        });

    //푸시 알림 켜기 (켜게 되면 토큰을 다시 발급받는다. 해당 토큰을 서버에 보내주어야한다.)
    NativeCallHandler.instance.addCallBack(
        name: 'turnOnPushNoti',
        callback: (args) async {
          try {
            final localDataInfo = LocalData(
                key: 'isAllowPushNoti', type: bool, defaultValue: true);
            setLocalData(localDataInfo, true);
            final result = await fcmController.getFcmToken();
            return result;
          } catch (e) {
            debugPrint(e.toString());
            return '';
          }
        });

    //푸시 알림 끄기
    NativeCallHandler.instance.addCallBack(
        name: 'turnOffPushNoti',
        callback: (args) async {
          try {
            FirebaseMessaging.instance.deleteToken();
            final localDataInfo = LocalData(
                key: 'isAllowPushNoti', type: bool, defaultValue: true);
            setLocalData(localDataInfo, false);
            return true;
          } catch (e) {
            debugPrint(e.toString());
            return false;
          }
        });

    //주제 구독
    NativeCallHandler.instance.addCallBack(
        name: 'subscribeTopic',
        callback: (args) async {
          return await fcmController.subscribeTopic(args[0]);
        });

    //주제 구독 해제 네이티브 콜 제작
    NativeCallHandler.instance.addCallBack(
        name: 'unsubscribeTopic',
        callback: (args) async {
          return await fcmController.unsubscribeTopic(args[0]);
        });

    //수신 여부 (인자값 안 넘기면 푸시 알림 여부, 넘기면 해당 토픽 수신 여부)
    NativeCallHandler.instance.addCallBack(
        name: 'getIsAllowPushNoti',
        callback: (args) async {
          if (args.isEmpty) {
            final localDataInfo = LocalData(
                key: 'isAllowPushNoti', type: bool, defaultValue: true);
            return await getLocalData(localDataInfo);
          } else {
            final localDataInfo = LocalData(
                key: args[0],
                type: bool,
                defaultValue: FcmConfig.topicMap[args[0]]);
            return await getLocalData(localDataInfo);
          }
        });

    //notification make
    NativeCallHandler.instance.addCallBack(
        name: 'makeNotification',
        callback: (args) async {
          try {
            fcmController.makeNotification(args[0]['title'], args[0]['contents']);
            return true;
          } catch (e, s) {
            debugPrint(e.toString());
            debugPrint(s.toString());
            return false;
          }
        });

    //토큰 만료
    NativeCallHandler.instance.addCallBack(
        name: 'expireFcmToken',
        callback: (args) async {
          try {
            FirebaseMessaging.instance.deleteToken();
            final localDataInfo = LocalData(
                key: 'isAllowPushNoti', type: bool, defaultValue: true);
            setLocalData(localDataInfo, true);
            for (var element in FcmConfig.topicMap.entries) {
              final localData =
                  LocalData(key: element.key, type: bool, defaultValue: null);
              setLocalData(localData, null);
            }

            return true;
          } catch (e, s) {
            debugPrint(e.toString());
            debugPrint(s.toString());
            return false;
          }
        });
  }
}
