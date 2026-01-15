import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Monitoring/services/attendance_service.dart';

class AttendanceRepository {

  Future<ResponseRequest> getAttendance({DateTime? startDate, DateTime? endDate, DateTime? selectedDate}) async => await AttendanceService().getAttendance(startDate: startDate, endDate: endDate, selectedDate: selectedDate);

  Future<ResponseRequest> saveAttendance({ required String childId, required String attendanceStatus, required DateTime attendanceDate}) async => await AttendanceService().saveAttendance(childId: childId, attendanceStatus: attendanceStatus, attendanceDate: attendanceDate);

}