class AttendanceDay {
  String id;
  int day;
  String month;
  DateTime date;

  AttendanceDay({
    required this.id,
    required this.day,
    required this.month,
    required this.date,
  });

  factory AttendanceDay.fromDate(DateTime date, int index) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'dic'];
    
    return AttendanceDay(
      id: index.toString(),
      day: date.day,
      month: months[date.month - 1],
      date: date,
    );
  }

  String toDateString() {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String get dateString => toDateString();
}