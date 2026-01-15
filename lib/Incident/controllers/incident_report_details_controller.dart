import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Incident/models/incident_report.dart';
import 'package:cuidado_infantil/Incident/repositories/incident_report_repository.dart';
import 'package:get/get.dart';

class IncidentReportDetailsController extends GetxController {
  IncidentReport? _incidentReport;
  bool _loading = true;
  String? _error;

  IncidentReport? get incidentReport => _incidentReport;
  bool get loading => _loading;
  String? get error => _error;

  @override
  void onInit() {
    super.onInit();
    final incidentReportId = Get.arguments as String?;
    if (incidentReportId != null) {
      loadIncidentReport(incidentReportId);
    } else {
      _error = 'No se proporcionó un ID de reporte';
      _loading = false;
      update();
    }
  }

  Future<void> loadIncidentReport(String incidentReportId) async {
    _loading = true;
    _error = null;
    update();

    try {
      print('🔍 DEBUG: Cargando reporte de incidente con ID: $incidentReportId');
      final response = await IncidentReportRepository().getIncidentReportById(
        incidentReportId: incidentReportId,
      );

      print('📥 DEBUG: Respuesta recibida');
      print('  - success: ${response.success}');
      print('  - message: ${response.message}');
      print('  - data type: ${response.data.runtimeType}');

      if (!response.success) {
        _error = response.message.isNotEmpty 
            ? response.message 
            : 'Error al cargar el reporte de incidente';
        _loading = false;
        update();
        print('❌ DEBUG: Error en la respuesta: $_error');
        CustomSnackBar(context: Get.overlayContext!).show(
          message: _error!,
        );
        return;
      }

      // Parsear la respuesta - puede venir como { "data": { ... } } o directamente como objeto
      dynamic responseData = response.data;
      Map<String, dynamic>? dataMap;

      if (responseData is Map) {
        print('  - responseData es Map');
        print('  - responseData keys: ${responseData.keys}');
        
        if (responseData.containsKey('data')) {
          dataMap = responseData['data'] as Map<String, dynamic>?;
          print('  - dataMap obtenido desde responseData[\'data\']');
        } else {
          dataMap = responseData as Map<String, dynamic>?;
          print('  - dataMap obtenido desde responseData completo');
        }
      } else {
        print('  - responseData NO es Map, es: ${responseData.runtimeType}');
      }

      if (dataMap != null) {
        print('✅ DEBUG: Parseando IncidentReport desde dataMap');
        print('  - dataMap keys: ${dataMap.keys}');
        try {
          _incidentReport = IncidentReport.fromJson(dataMap);
          print('✅ DEBUG: IncidentReport cargado exitosamente');
          print('  - ID: ${_incidentReport?.id}');
          print('  - Code: ${_incidentReport?.code}');
          print('  - Child: ${_incidentReport?.child != null ? "Sí" : "No"}');
          print('  - Evidence Files: ${_incidentReport?.evidenceFiles?.length ?? 0}');
          _loading = false;
          update();
        } catch (e, stackTrace) {
          print('❌ ERROR parseando IncidentReport: $e');
          print('  StackTrace: $stackTrace');
          _error = 'Error al procesar los datos del reporte: $e';
          _loading = false;
          update();
          CustomSnackBar(context: Get.overlayContext!).show(
            message: _error!,
          );
        }
      } else {
        _error = 'Formato de respuesta inválido';
        _loading = false;
        update();
        print('❌ DEBUG: No se pudo obtener dataMap');
        CustomSnackBar(context: Get.overlayContext!).show(
          message: _error!,
        );
      }
    } catch (e, stackTrace) {
      print('💥 DEBUG: Error inesperado: $e');
      print('  StackTrace: $stackTrace');
      _error = 'Error inesperado: $e';
      _loading = false;
      update();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: _error!,
      );
    }
  }

  Future<void> refreshIncidentReport() async {
    if (_incidentReport?.id != null) {
      await loadIncidentReport(_incidentReport!.id!);
    }
  }
}

