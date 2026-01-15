import 'package:cuidado_infantil/Monitoring/models/attendance_child.dart';

class AttendanceResponse {
  final String centerId;
  final AttendanceRange range;
  final int childrenCount;
  final List<String> dates;
  final List<AttendanceChild> children;

  AttendanceResponse({
    required this.centerId,
    required this.range,
    required this.childrenCount,
    required this.dates,
    required this.children,
  });

  factory AttendanceResponse.fromMap(Map<String, dynamic> map) {
    return AttendanceResponse(
      centerId: map['center_id']?.toString() ?? '',
      range: AttendanceRange.fromMap(map['range'] as Map<String, dynamic>? ?? {}),
      childrenCount: map['children_count'] ?? 0,
      dates: (map['dates'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      children: (map['children'] as List<dynamic>? ?? [])
          .map((e) => AttendanceChild.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AttendanceRange {
  final String start;
  final String end;

  AttendanceRange({
    required this.start,
    required this.end,
  });

  factory AttendanceRange.fromMap(Map<String, dynamic> map) {
    return AttendanceRange(
      start: map['start']?.toString() ?? '',
      end: map['end']?.toString() ?? '',
    );
  }
}

