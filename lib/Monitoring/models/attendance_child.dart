class AttendanceChild {
  final String childId;
  final String fullName;
  final String firstName;
  final String paternalLastName;
  final String maternalLastName;
  final String birthDate;
  final String gender;
  final String roomId;
  final String roomName;
  final Map<String, String> attendance; // fecha -> status

  AttendanceChild({
    required this.childId,
    required this.fullName,
    required this.firstName,
    required this.paternalLastName,
    required this.maternalLastName,
    required this.birthDate,
    required this.gender,
    required this.roomId,
    required this.roomName,
    required this.attendance,
  });

  factory AttendanceChild.fromMap(Map<String, dynamic> map) {
    // Convertir attendance de Map a Map<String, String>
    Map<String, String> attendanceMap = {};
    if (map['attendance'] is Map) {
      final attendanceData = map['attendance'] as Map;
      attendanceData.forEach((key, value) {
        attendanceMap[key.toString()] = value.toString();
      });
    }

    return AttendanceChild(
      childId: map['child_id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      firstName: map['first_name']?.toString() ?? '',
      paternalLastName: map['paternal_last_name']?.toString() ?? '',
      maternalLastName: map['maternal_last_name']?.toString() ?? '',
      birthDate: map['birth_date']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      roomId: map['room_id']?.toString() ?? '',
      roomName: map['room_name']?.toString() ?? '',
      attendance: attendanceMap,
    );
  }

  String getAttendanceStatus(String date) {
    return attendance[date] ?? 'unspecified';
  }

  AttendanceChild copyWith({
    String? childId,
    String? fullName,
    String? firstName,
    String? paternalLastName,
    String? maternalLastName,
    String? birthDate,
    String? gender,
    String? roomId,
    String? roomName,
    Map<String, String>? attendance,
  }) {
    return AttendanceChild(
      childId: childId ?? this.childId,
      fullName: fullName ?? this.fullName,
      firstName: firstName ?? this.firstName,
      paternalLastName: paternalLastName ?? this.paternalLastName,
      maternalLastName: maternalLastName ?? this.maternalLastName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      attendance: attendance ?? this.attendance,
    );
  }
}

