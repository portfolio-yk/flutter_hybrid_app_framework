import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'data/AlarmConfig.dart';
import 'data/WeekData.dart';


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  // ignore: avoid_print
  print(details!.payload);
}

class AlarmController {

  static late final AlarmController? instance;
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static init() {
    instance = AlarmController._init();
  }
  AlarmController._init() {
    _internal();
  }

  _internal () async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
    InitializationSettings initializationSettings = const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,));
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);



  }

  setAlarmOption({ required AlarmConfig alarmConfig}) async {
    int hour = alarmConfig.hour;
    int min = alarmConfig.minute;
    String message = alarmConfig.message;
    String title = alarmConfig.title;
    WeekData alarmDate = alarmConfig.weekData;

    if(alarmDate.isAllDay) {
      await showAlarmDailyNotifi(title, message, getTime(hour : hour, min :min));
      return true;
    } else {
      final List<Future> alarmDateList = [] ;
      if(alarmDate.mon) {
        print(1.toString());
        alarmDateList.add(showAlarmWeekNotifi(title, message, DateTime.monday, getTime(hour : hour, min :min, day : DateTime.monday)));
      }
      if(alarmDate.tue) {
        print(2.toString());
        alarmDateList.add(showAlarmWeekNotifi(title, message, DateTime.tuesday, getTime(hour : hour, min :min, day : DateTime.tuesday)));
      }
      if(alarmDate.wed) {
        print(3.toString());
        alarmDateList.add(showAlarmWeekNotifi(title, message, DateTime.wednesday, getTime(hour : hour, min :min, day : DateTime.wednesday)));
      }
      if(alarmDate.thu) {
        print(4.toString());
        alarmDateList.add(showAlarmWeekNotifi(title, message, DateTime.thursday, getTime(hour : hour, min :min, day : DateTime.thursday)));
      }
      if(alarmDate.fri) {
        print(5.toString());
        alarmDateList.add(showAlarmWeekNotifi(title, message , DateTime.friday, getTime(hour : hour, min :min, day : DateTime.friday)));
      }
      if(alarmDate.sat) {
        alarmDateList.add(showAlarmWeekNotifi(title, message, DateTime.saturday, getTime(hour : hour, min :min, day : DateTime.saturday)));
        print(6.toString());
      }
      if(alarmDate.sun) {
        alarmDateList.add(showAlarmWeekNotifi(title, message, DateTime.sunday, getTime(hour : hour, min :min, day : DateTime.sunday)));
        print(7.toString());
      }
      await Future.wait(alarmDateList);
      return true;
    }

  }


  //하루하루 알람 지정
  Future<bool> showAlarmWeekNotifi(String title, String message, int id, tz.TZDateTime dateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        message,
        dateTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'ALARM', 'ALARM',
                channelDescription: 'ALARM',
                priority: Priority.max,
                importance: Importance.max)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    print("$id 생성");
    return true;
  }

  //매일 알람 지정
  Future<bool> showAlarmDailyNotifi(String title,String message,tz.TZDateTime dateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        10,
        title,
        message,
        dateTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'ALARM', 'ALARM',
                channelDescription: 'ALARM',
              priority: Priority.max,
              importance: Importance.max)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    return true;
  }

  //알람 모두 취소
  Future cancelScheduler() async {
    return await flutterLocalNotificationsPlugin.cancelAll();
  }


  tz.TZDateTime getTime({required int hour ,required int min, int? day}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, now.year,now.month,now.day,hour , min);

    if(day != null) {
      while (scheduleDate.weekday != day) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }
    } else {
      if (scheduleDate.isBefore(now)) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }
    }
    return scheduleDate;
  }

  Future selectNotification(String? payload) async {
    print("asd");
  }

  getAlarmStatus() async {
    final notificationLength= await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('dd${notificationLength}');
    return notificationLength;
  }
}