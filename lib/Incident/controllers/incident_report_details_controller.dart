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
      final response = await IncidentReportRepository().getIncidentReportById(
        incidentReportId: incidentReportId,
      );

      if (!response.success) {
        _error = response.message.isNotEmpty 
            ? response.message 
            : 'Error al cargar el reporte de incidente';
        _loading = false;
        update();
        CustomSnackBar(context: Get.overlayContext!).show(
          message: _error!,
        );
        return;
      }

      final incidentReport = _parseIncidentReport(response.data);

      if (incidentReport != null) {
        _incidentReport = incidentReport;
        _loading = false;
        update();
      } else {
        _error = 'Formato de respuesta inválido';
        _loading = false;
        update();
        CustomSnackBar(context: Get.overlayContext!).show(
          message: _error!,
        );
      }
    } catch (e) {
      _error = 'Error inesperado: $e';
      _loading = false;
      update();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: _error!,
      );
    }
  }

  IncidentReport? _parseIncidentReport(dynamic responseData) {
    Map<String, dynamic>? dataMap;

    if (responseData is Map) {
      if (responseData.containsKey('data')) {
        dataMap = responseData['data'] as Map<String, dynamic>?;
      } else {
        dataMap = responseData as Map<String, dynamic>?;
      }
    }

    if (dataMap != null) {
      try {
        return IncidentReport.fromJson(dataMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> refreshIncidentReport() async {
    if (_incidentReport?.id != null) {
      await loadIncidentReport(_incidentReport!.id!);
    }
  }
}

