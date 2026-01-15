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
      dynamic responseData = response.data;
      List<dynamic>? reportsData;
      Map<String, dynamic>? paginationData;

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
            paginationData = metaValue['pagination'] as Map<String, dynamic>?;
          }
        }
      } else if (responseData is List) {
        reportsData = responseData;
      }

      if (reportsData != null && reportsData.isNotEmpty) {
        final newReports = reportsData.map((json) {
          try {
            return IncidentReport.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            return null;
          }
        }).whereType<IncidentReport>().toList();
        
        if (reset) {
          _incidentReports = newReports;
        } else {
          _incidentReports.addAll(newReports);
        }
      }

      // Actualizar información de paginación
      if (paginationData != null) {
        _pagination = PaginationInfo.fromJson(paginationData);
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

