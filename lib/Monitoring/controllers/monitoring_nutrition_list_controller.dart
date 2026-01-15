import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/models/nutritional_assessment.dart';
import 'package:cuidado_infantil/Monitoring/repositories/monitoring_nutrition_repository.dart';
import 'package:get/get.dart';

class MonitoringNutritionListController extends GetxController {
  bool _loading = true;
  bool get loading => _loading;

  List<NutritionalAssessment> _evaluations = [];
  List<NutritionalAssessment> get evaluations => _evaluations;

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
      print('❌ ERROR: No se encontró child ID');
      _loading = false;
      update();
    }
  }

  Future<void> loadEvaluations() async {
    if (_childId == null) return;

    _loading = true;
    update(['nutrition_list']);

    // Esperar a que el contexto esté disponible
    await Future.delayed(Duration(milliseconds: 100));
    
    // final overlayContext = Get.overlayContext;
    // if (overlayContext == null) {
    //   print('⚠️  WARNING: overlayContext no disponible, reintentando...');
    //   await Future.delayed(Duration(milliseconds: 200));
    // }
    
    final context = Get.overlayContext;
    if (context == null) {
      print('❌ ERROR: No se pudo obtener overlayContext');
      _loading = false;
      update(['nutrition_list']);
      return;
    }

    // final customDialog = CustomDialog(context: context);
    // customDialog.show();

    try {
      final response = await MonitoringNutritionRepository().getEvaluationsByChild(childId: _childId!);
      
      // customDialog.hide();

      if (!response.success) {
        CustomSnackBar(context: context).show(
          message: 'No se pudieron cargar las evaluaciones. ${response.message}'
        );
        _loading = false;
        update(['nutrition_list']);
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
            return NutritionalAssessment.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('⚠️ Error parseando evaluación nutricional: $e');
            return null;
          }
        }).whereType<NutritionalAssessment>().toList();
        
        print('✅ DEBUG: ${_evaluations.length} evaluaciones nutricionales cargadas');
      } else {
        print('ℹ️ INFO: No se encontraron evaluaciones nutricionales');
      }

      _loading = false;
      update(['nutrition_list']);
    } catch (e) {
      // customDialog.hide();
      print('❌ ERROR cargando evaluaciones nutricionales: $e');
      CustomSnackBar(context: context).show(
        message: 'Error al cargar las evaluaciones: $e'
      );
      _loading = false;
      update(['nutrition_list']);
    }
  }

  /// Refresca la lista de evaluaciones
  Future<void> refreshEvaluations() async {
    await loadEvaluations();
  }
}