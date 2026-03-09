import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/modules/alarm/alarm_controller.dart';
import 'package:hybrid_module/modules/alarm/data/AlarmConfig.dart';
import 'package:hybrid_module/modules/alarm/data/WeekData.dart';
import 'package:flutter/material.dart';

class AlaramManager {
  static void init() {

    AlarmController.init();

    NativeCallHandler.instance.addCallBack(name: 'turnOnAlarm', callback: (args) async {
      try {
        Map alarmConfigJson = args[0] as Map;
        //알림 시간
        int hour = alarmConfigJson['hour'];
        int minute = alarmConfigJson['minute'];

        //알림 내용, 제목
        String message = alarmConfigJson['message'];
        String title = alarmConfigJson['title'];

        //요일 지정
        bool mon = alarmConfigJson['day']['mon'] ?? false;
        bool tue = alarmConfigJson['day']['tue'] ?? false;
        bool wed = alarmConfigJson['day']['wed'] ?? false;
        bool thu = alarmConfigJson['day']['thu'] ?? false;
        bool fri = alarmConfigJson['day']['fri'] ?? false;
        bool sat = alarmConfigJson['day']['sat'] ?? false;
        bool sun = alarmConfigJson['day']['sun'] ?? false;



        final weekData = WeekData(mon: mon,
            tue: tue,
            wed: wed,
            thu: thu,
            fri: fri,
            sat: sat,
            sun: sun,
        );
        final alarmConfigModel = AlarmConfig(weekData : weekData, hour : hour, minute : minute, message: message, title : title);


        final res = await AlarmController.instance?.setAlarmOption(alarmConfig: alarmConfigModel);
        return res;
      } catch(e) {
        debugPrint(e.toString());
        return false;
      }
    });

    NativeCallHandler.instance.addCallBack(name: 'turnOffAlarm', callback: (args) async {
      await AlarmController.instance?.cancelScheduler();
      return true;
    });
  }
}