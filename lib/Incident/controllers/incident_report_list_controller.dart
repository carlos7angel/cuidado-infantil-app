import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Incident/models/incident_report.dart';
import 'package:cuidado_infantil/Incident/models/pagination_info.dart';
import 'package:cuidado_infantil/Incident/repositories/incident_report_repository.dart';
import 'package:get/get.dart';

class IncidentReportListController extends GetxController {
  bool _loading = true;
  bool get loading => _loading;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  List<IncidentReport> _incidentReports = [];
  List<IncidentReport> get incidentReports => _incidentReports;

  PaginationInfo? _pagination;
  PaginationInfo? get pagination => _pagination;

  bool get hasMore => _pagination?.hasMore ?? false;
  int get currentPage => _pagination?.currentPage ?? 1;

  String? _childcareCenterId;
  static const int _pageSize = 10;
  
  bool _isLoading = false; // Flag para prevenir llamadas simultáneas

  @override
  void onInit() {
    super.onInit();
    // Obtener el ID del childcare center desde storage
    final childcareCenter = StorageService.instance.getChildcareCenter();
    _childcareCenterId = childcareCenter?.id;
    
    // Cargar los reportes de incidentes
    if (_childcareCenterId != null) {
      Future.microtask(() => loadIncidentReports());
    } else {
      _loading = false;
      update(['incident_report_list']);
    }
  }

  Future<void> loadIncidentReports({bool reset = true}) async {
    if (_childcareCenterId == null) return;

    // Prevenir llamadas simultáneas
    if (_isLoading) return;

    _isLoading = true;

    if (reset) {
      _loading = true;
      _incidentReports.clear();
      _pagination = null;
    } else {
      _loadingMore = true;
    }
    update(['incident_report_list']);

    try {
      final nextPage = reset ? 1 : (currentPage + 1);
      
      final response = await IncidentReportRepository().getIncidentReportsByChildcareCenter(
        childcareCenterId: _childcareCenterId!,
        page: nextPage,
        limit: _pageSize,
      );

      if (!response.success) {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudieron cargar los reportes de incidentes. ${response.message}'
          );
        }
        if (reset) {
          _loading = false;
        } else {
          _loadingMore = false;
        }
        update(['incident_report_list']);
        return;
      }

      // El API retorna { "data": [...], "meta": { "pagination": {...} } }
      final parsedData = _parseResponse(response.data);
      
      if (parsedData.reports.isNotEmpty) {
        if (reset) {
          _incidentReports = parsedData.reports;
        } else {
          _incidentReports.addAll(parsedData.reports);
        }
      }

      // Actualizar información de paginación
      if (parsedData.pagination != null) {
        _pagination = parsedData.pagination;
      }

      if (reset) {
        _loading = false;
      } else {
        _loadingMore = false;
      }
      _isLoading = false;
      update(['incident_report_list']);
    } catch (e) {
      final overlayContext = Get.overlayContext;
      if (overlayContext != null) {
        CustomSnackBar(context: overlayContext).show(
          message: 'Error al cargar los reportes de incidentes: $e'
        );
      }
      if (reset) {
        _loading = false;
      } else {
        _loadingMore = false;
      }
      _isLoading = false;
      update(['incident_report_list']);
    }
  }

  ({List<IncidentReport> reports, PaginationInfo? pagination}) _parseResponse(dynamic responseData) {
    List<dynamic>? reportsData;
    PaginationInfo? paginationInfo;

    if (responseData is Map) {
      if (responseData.containsKey('data')) {
        final dataValue = responseData['data'];
        if (dataValue is List) {
          reportsData = dataValue;
        }
      }
      if (responseData.containsKey('meta')) {
        final metaValue = responseData['meta'];
        if (metaValue is Map && metaValue.containsKey('pagination')) {
          final paginationData = metaValue['pagination'] as Map<String, dynamic>?;
          if (paginationData != null) {
            paginationInfo = PaginationInfo.fromJson(paginationData);
          }
        }
      }
    } else if (responseData is List) {
      reportsData = responseData;
    }

    final reports = <IncidentReport>[];
    if (reportsData != null && reportsData.isNotEmpty) {
      for (var json in reportsData) {
        try {
          reports.add(IncidentReport.fromJson(json as Map<String, dynamic>));
        } catch (_) {}
      }
    }

    return (reports: reports, pagination: paginationInfo);
  }

  /// Carga más reportes (siguiente página)
  Future<void> loadMoreIncidentReports() async {
    if (!hasMore) return;
    if (_loadingMore || _loading || _isLoading) return;
    await loadIncidentReports(reset: false);
  }

  /// Refresca la lista de reportes de incidentes (resetea a la primera página)
  Future<void> refreshIncidentReports() async {
    await loadIncidentReports(reset: true);
  }
}

