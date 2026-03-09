class WeekData {
  bool mon;
  bool tue;
  bool wed;
  bool thu;
  bool fri;
  bool sat;
  bool sun;


  get isAllDay {
    return mon && tue && wed && thu && fri && sat && sun;
  }

  WeekData(
      {
        required this.mon,
        required this.tue,
        required this.wed,
        required this.thu,
        required this.fri,
        required this.sat,
        required this.sun,
      });
}
