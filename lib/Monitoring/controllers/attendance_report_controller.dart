import 'package:cuidado_infantil/Monitoring/models/attendance_response.dart';
import 'package:cuidado_infantil/Monitoring/models/attendance_child.dart';
import 'package:cuidado_infantil/Monitoring/repositories/Attendance_repository.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:get/get.dart';

class AttendanceReportController extends GetxController {
  /// Número máximo de inasistencias permitidas antes de resaltar en rojo
  /// Se puede modificar este valor para cambiar el umbral de alerta
  static const int MAX_ABSENCES_THRESHOLD = 1;
  bool _loading = true;
  bool get loading => _loading;

  List<AttendanceChild> _children = [];
  List<AttendanceChild> get children => _children;

  List<String> _dates = [];
  List<String> get dates => _dates;

  DateTime _startDate = DateTime.now().subtract(Duration(days: 9)); // Últimos 10 días
  DateTime _endDate = DateTime.now();
  
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  AttendanceResponse? _attendanceResponse;
  AttendanceResponse? get attendanceResponse => _attendanceResponse;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() {
      loadAttendanceReport();
    });
  }

  /// Carga el reporte de asistencia para el rango de fechas especificado
  Future<void> loadAttendanceReport({DateTime? startDate, DateTime? endDate}) async {
    _loading = true;
    update(['report_table']);

    // Si se pasan fechas, actualizarlas
    if (startDate != null) _startDate = startDate;
    if (endDate != null) _endDate = endDate;

    // Asegurar que startDate <= endDate
    if (_startDate.isAfter(_endDate)) {
      final temp = _startDate;
      _startDate = _endDate;
      _endDate = temp;
    }

    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      final customDialog = CustomDialog(context: overlayContext);
      customDialog.show();

      try {
        final response = await AttendanceRepository().getAttendance(
          startDate: _startDate,
          endDate: _endDate,
        );

        customDialog.hide();

        if (!response.success) {
          if (overlayContext.mounted) {
            CustomSnackBar(context: overlayContext).show(
              message: 'No se pudieron cargar los datos del reporte. ${response.message}'
            );
          }
          _loading = false;
          update(['report_table']);
          return;
        }

        // Parsear la respuesta
        dynamic responseData = response.data;
        Map<String, dynamic>? attendanceData;

        if (responseData is Map) {
          if (responseData.containsKey('data')) {
            attendanceData = responseData['data'] as Map<String, dynamic>?;
          } else {
            attendanceData = responseData as Map<String, dynamic>?;
          }
        }

        if (attendanceData != null) {
          _attendanceResponse = AttendanceResponse.fromMap(attendanceData);
          _children = _attendanceResponse!.children;
          _dates = _attendanceResponse!.dates;
          
          // Ordenar children por apellido paterno, luego materno, luego nombre
          _children.sort(_sortChildren);
          
          print('✅ DEBUG: Reporte cargado - ${_children.length} children, ${_dates.length} fechas');
        }

        _loading = false;
        update(['report_table']);
      } catch (e) {
        customDialog.hide();
        _loading = false;
        update(['report_table']);
        if (overlayContext.mounted) {
          CustomSnackBar(context: overlayContext).show(
            message: 'Error al cargar el reporte: $e',
            title: 'Error',
          );
        }
      }
    } else {
      _loading = false;
      update(['report_table']);
    }
  }

  /// Actualiza el rango de fechas y recarga el reporte
  Future<void> updateDateRange(DateTime startDate, DateTime endDate) async {
    await loadAttendanceReport(startDate: startDate, endDate: endDate);
  }

  /// Obtiene el estado de asistencia de un child para una fecha específica
  String getAttendanceStatus(String childId, String date) {
    final child = _children.firstWhere(
      (c) => c.childId == childId,
      orElse: () => AttendanceChild(
        childId: '',
        fullName: '',
        firstName: '',
        paternalLastName: '',
        maternalLastName: '',
        birthDate: '',
        gender: '',
        roomId: '',
        roomName: '',
        attendance: {},
      ),
    );
    return child.getAttendanceStatus(date);
  }

  /// Cuenta las inasistencias (falta + justificado) de un child en el rango de fechas
  /// No cuenta los estados sin especificar o sin registro
  int getAbsenceCount(String childId) {
    final child = _children.firstWhere(
      (c) => c.childId == childId,
      orElse: () => AttendanceChild(
        childId: '',
        fullName: '',
        firstName: '',
        paternalLastName: '',
        maternalLastName: '',
        birthDate: '',
        gender: '',
        roomId: '',
        roomName: '',
        attendance: {},
      ),
    );

    int absenceCount = 0;
    for (final date in _dates) {
      final status = child.getAttendanceStatus(date).toLowerCase();
      // Contar solo 'falta' y 'justificado' (y sus equivalentes en inglés)
      if (status == 'falta' || status == 'absent' || 
          status == 'justificado' || status == 'justified') {
        absenceCount++;
      }
    }
    return absenceCount;
  }

  /// Verifica si un child tiene más inasistencias que el umbral permitido
  bool hasMoreThanThreeAbsences(String childId) {
    return getAbsenceCount(childId) > MAX_ABSENCES_THRESHOLD;
  }

  /// Función de ordenamiento para children
  int _sortChildren(AttendanceChild a, AttendanceChild b) {
    // Ordenar por apellido paterno
    int paternalCompare = a.paternalLastName.compareTo(b.paternalLastName);
    if (paternalCompare != 0) return paternalCompare;

    // Si los apellidos paternos son iguales, ordenar por apellido materno
    int maternalCompare = a.maternalLastName.compareTo(b.maternalLastName);
    if (maternalCompare != 0) return maternalCompare;

    // Si ambos apellidos son iguales, ordenar por nombre
    return a.firstName.compareTo(b.firstName);
  }

  /// Formatea una fecha para mostrar en la columna
  String formatDateForColumn(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final dayName = _getDayName(date.weekday);
      return '${dayName}\n${date.day}/${date.month}';
    } catch (e) {
      return dateString;
    }
  }

  String _getDayName(int weekday) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[weekday - 1];
  }
}

