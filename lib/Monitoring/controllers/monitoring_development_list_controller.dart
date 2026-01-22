import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';
import 'package:cuidado_infantil/Monitoring/repositories/monitoring_development_repository.dart';
import 'package:get/get.dart';

class MonitoringDevelopmentListController extends GetxController {
  bool _loading = true;
  bool get loading => _loading;

  List<ChildDevelopmentEvaluation> _evaluations = [];
  List<ChildDevelopmentEvaluation> get evaluations => _evaluations;

  String? _childId;

  @override
  void onInit() {
    super.onInit();
    // Obtener el ID del child desde storage
    final selectedChild = StorageService.instance.getSelectedChild();
    _childId = selectedChild?.id;
    
    // Cargar las evaluaciones
    if (_childId != null) {
      Future.microtask(() => loadEvaluations());
    } else {
      _loading = false;
      update();
    }
  }

  Future<void> loadEvaluations() async {
    if (_childId == null) return;

    _loading = true;
    update(['development_list']);

    try {
      final response = await MonitoringDevelopmentRepository().getEvaluationsByChild(childId: _childId!);

      if (!response.success) {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudieron cargar las evaluaciones. ${response.message}'
          );
        }
        _loading = false;
        update(['development_list']);
        return;
      }

      // El API retorna { "data": [...] }
      dynamic responseData = response.data;
      List<dynamic>? evaluationsData;

      if (responseData is Map) {
        if (responseData.containsKey('data')) {
          final dataValue = responseData['data'];
          if (dataValue is List) {
            evaluationsData = dataValue;
          } else {
            evaluationsData = null;
          }
        } else {
          evaluationsData = null;
        }
      } else if (responseData is List) {
        evaluationsData = responseData;
      } else {
        evaluationsData = null;
      }

      _evaluations.clear();
      if (evaluationsData != null && evaluationsData.isNotEmpty) {
        _evaluations = evaluationsData.map((json) {
          try {
            return ChildDevelopmentEvaluation.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            return null;
          }
        }).whereType<ChildDevelopmentEvaluation>().toList();        
      }

      _loading = false;
      update(['development_list']);
    } catch (e) {
      final overlayContext = Get.overlayContext;
      if (overlayContext != null) {
        CustomSnackBar(context: overlayContext).show(
          message: 'Error al cargar las evaluaciones: $e'
        );
      }
      _loading = false;
      update(['development_list']);
    }
  }

  /// Refresca la lista de evaluaciones
  Future<void> refreshEvaluations() async {
    await loadEvaluations();
  }
}

