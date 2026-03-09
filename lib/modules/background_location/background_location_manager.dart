import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/modules/hybrid_manager.dart';

class BackgroundLocationManager implements HybridManager<void> {
  @override
  void init(options) async {
    final nativeCallHandler = NativeCallHandler.instance;
    //백그라운드 위치 서비스를 시작한다. 포그라운드 노티피케이션이 활성화되고,
    //이제, 백그라운드일때 4초마다 내 위치를 갱신한다.
    nativeCallHandler.addCallBack(
        name: 'startBackgroundLocationService',
        callback: (args) async {
          try {
            final res = await NativeCallHandler.instance.platform.invokeMethod(
                'startBackgroundLocationService', {
              'title': args[0]['title'].toString(),
              'contents': args[0]['contents'].toString()
            });
            return true;
          } catch (e) {
            debugPrint(e.toString());
            return false;
          }
        });

    //백그라운드로 갱신된 내 위치를 가져온다. myLocation은 [lo(경도), la(위도)], 혹은 null을 반환한다.
    nativeCallHandler.addCallBack(
        name: 'getMyBackgroundLocation',
        callback: (args) async {
          try {
            var myLocation = await NativeCallHandler.instance.platform
                .invokeMethod('getMyBackgroundLocation');
            return jsonDecode(myLocation);
          } catch (e) {
            debugPrint(e.toString());
            return null;
          }
        });

    //백그라운드 위치 서비스를 종료한다.
    nativeCallHandler.addCallBack(
        name: 'stopBackgroundLocationService',
        callback: (args) async {
          try {
            await NativeCallHandler.instance.platform
                .invokeMethod('stopBackgroundLocationService');
            return true;
          } catch (e) {
            debugPrint(e.toString());
            return false;
          }
        });
  }
}