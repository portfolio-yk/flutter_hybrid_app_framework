import 'WeekData.dart';

class AlarmConfig {
  WeekData weekData;
  String message;
  String title;
  int hour;
  int minute;

  get isAllDay {
    return weekData.isAllDay;
  }

  AlarmConfig(
      {
        required this.weekData,
        required this.minute,
        required this.hour,
        this.message = '',
        this.title = '',
      });
}
