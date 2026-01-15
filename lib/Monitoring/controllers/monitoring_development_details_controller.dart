import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';
import 'package:cuidado_infantil/Monitoring/repositories/monitoring_development_repository.dart';
import 'package:get/get.dart';

class MonitoringDevelopmentDetailsController extends GetxController {
  Child? _child;
  Child? get child => _child;

  ChildDevelopmentEvaluation? _evaluation;
  ChildDevelopmentEvaluation? get evaluation => _evaluation;

  bool _loading = true;
  bool get loading => _loading;

  List<bool> _expandedPanels = [false, false, false, false];
  List<bool> get expandedPanels => _expandedPanels;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  /// Inicializa los datos de la evaluación desde los argumentos
  void _initializeData() {
    // Resetear estado anterior
    _evaluation = null;
    _loading = true;
    _expandedPanels = [false, false, false, false];
    
    // Obtener el child desde storage
    _child = StorageService.instance.getSelectedChild();
    
    // Obtener la evaluación desde los argumentos
    final arguments = Get.arguments;
    String? evaluationId;
    
    if (arguments != null && arguments is Map) {
      if (arguments['evaluation'] != null && arguments['evaluation'] is ChildDevelopmentEvaluation) {
        _evaluation = arguments['evaluation'] as ChildDevelopmentEvaluation;
        evaluationId = _evaluation?.id;
      } else if (arguments['evaluationId'] != null) {
        evaluationId = arguments['evaluationId']?.toString();
      }
    }
    
    // Cargar los detalles completos desde el API
    if (evaluationId != null) {
      Future.microtask(() => loadEvaluationDetails(evaluationId!));
    } else {
      _loading = false;
      update(['development_details']);
    }
  }

  Future<void> loadEvaluationDetails(String evaluationId) async {
    _loading = true;
    update(['development_details']);

    try {
      final response = await MonitoringDevelopmentRepository().getEvaluationById(
        evaluationId: evaluationId,
      );

      if (!response.success) {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudieron cargar los detalles de la evaluación. ${response.message}'
          );
        }
        _loading = false;
        update(['development_details']);
        return;
      }

      // Parsear la respuesta
      dynamic responseData = response.data;
      Map<String, dynamic>? dataMap;

      if (responseData is Map) {
        if (responseData.containsKey('data')) {
          dataMap = responseData['data'] as Map<String, dynamic>?;
        } else {
          dataMap = responseData as Map<String, dynamic>?;
        }
      }

      if (dataMap != null) {
        _evaluation = ChildDevelopmentEvaluation.fromJson(dataMap);
        print('✅ DEBUG: Detalles de evaluación cargados');
      } else {
        print('⚠️ WARNING: No se encontraron detalles de evaluación');
      }

      _loading = false;
      update(['development_details']);
    } catch (e) {
      print('❌ ERROR cargando detalles de evaluación: $e');
      final overlayContext = Get.overlayContext;
      if (overlayContext != null) {
        CustomSnackBar(context: overlayContext).show(
          message: 'Error al cargar los detalles: $e'
        );
      }
      _loading = false;
      update(['development_details']);
    }
  }

  void togglePanel(int index) {
    if (index >= 0 && index < _expandedPanels.length) {
      _expandedPanels[index] = !_expandedPanels[index];
      update();
    }
  }
}

