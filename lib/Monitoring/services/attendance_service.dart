import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:intl/intl.dart';

class AttendanceService {

  AttendanceService._internal();
  static final AttendanceService _instance = AttendanceService._internal();
  static AttendanceService get instance => _instance;
  factory AttendanceService() => _instance;

  final ApiService _api = ApiService.instance;

  /// Calcula el lunes y domingo de la semana de una fecha dada
  static Map<String, DateTime> getWeekRange(DateTime date) {
    // Obtener el día de la semana (1 = lunes, 7 = domingo)
    int weekday = date.weekday;
    
    // Calcular cuántos días restar para llegar al lunes
    int daysFromMonday = weekday - 1;
    
    // Calcular el lunes de la semana
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    monday = DateTime(monday.year, monday.month, monday.day);
    
    // Calcular el domingo de la semana (6 días después del lunes)
    DateTime sunday = monday.add(Duration(days: 6));
    sunday = DateTime(sunday.year, sunday.month, sunday.day);
    
    return {
      'start': monday,
      'end': sunday,
    };
  }

  Future<ResponseRequest> getAttendance({DateTime? startDate, DateTime? endDate, DateTime? selectedDate}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final childcareCenter = StorageService.instance.getChildcareCenter();
    
    Map<String, dynamic> queryParams = {};
    
    // Si se pasa una fecha seleccionada, calcular el rango de la semana (lunes a domingo)
    if (selectedDate != null) {
      final weekRange = getWeekRange(selectedDate);
      queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(weekRange['start']!);
      queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(weekRange['end']!);
      print('📅 DEBUG: Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
      print('📅 DEBUG: Rango de semana: ${queryParams['start_date']} a ${queryParams['end_date']}');
    }
    // Si se pasan fechas específicas, usarlas
    else if (startDate != null && endDate != null) {
      queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
      queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
    }
    // Si no se pasa nada, calcular la semana de hoy (lunes a domingo)
    else {
      final today = DateTime.now();
      final weekRange = getWeekRange(today);
      queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(weekRange['start']!);
      queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(weekRange['end']!);
    }

    print('🌐 DEBUG: Llamando endpoint con queryParams: $queryParams');
    
    final response = await _api.get(
        '/attendance/childcare-center/${childcareCenter!.id}',
        queryParams: queryParams,
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    
    print('🌐 DEBUG: Respuesta del endpoint - success: ${response.success}, statusCode: ${response.statusCode}');
    if (response.data != null) {
      print('🌐 DEBUG: Respuesta tiene data: ${response.data is Map}');
    }
    
    return response;
  }

  Future<ResponseRequest> saveAttendance({ required String childId, required String attendanceStatus, required DateTime attendanceDate}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final childcareCenter = StorageService.instance.getChildcareCenter();
    
    if (childcareCenter == null) {
      final errorResponse = ResponseRequest();
      errorResponse.success = false;
      errorResponse.message = 'No se encontró el centro de cuidado infantil';
      errorResponse.statusCode = 400;
      return errorResponse;
    }

    print('🔍 DEBUG: Enviando datos de asistencia:');
    print('  childcare_center_id: ${childcareCenter.id}');
    print('  child_id: $childId');
    print('  status: $attendanceStatus');
    print('  date: ${DateFormat('yyyy-MM-dd').format(attendanceDate)}');

    final response = await _api.put(
        '/attendance/upsert',
        data: {
          'childcare_center_id': childcareCenter.id,
          'child_id': childId,
          'status': attendanceStatus,
          'date': DateFormat('yyyy-MM-dd').format(attendanceDate),
        },
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    return response;

  }
}