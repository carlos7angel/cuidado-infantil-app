import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Monitoring/models/nutritional_assessment.dart';
import 'package:get/get.dart';

class MonitoringNutritionDetailsController extends GetxController {
  NutritionalAssessment? _assessment;
  Child? _child;
  final List<bool> _expandedPanels = [false, false, false, false]; // Para 4 paneles

  NutritionalAssessment? get assessment => _assessment;
  Child? get child => _child;
  List<bool> get expandedPanels => _expandedPanels;

  @override
  void onInit() {
    super.onInit();
    // Obtener la evaluación desde los argumentos de la ruta
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      if (arguments['assessment'] is NutritionalAssessment) {
        _assessment = arguments['assessment'] as NutritionalAssessment;
      }
    }
    
    // Obtener el child desde storage
    _child = StorageService.instance.getSelectedChild();
    
    update();
  }

  void setAssessment(NutritionalAssessment assessment) {
    _assessment = assessment;
    update();
  }

  void togglePanel(int index) {
    if (index >= 0 && index < _expandedPanels.length) {
      _expandedPanels[index] = !_expandedPanels[index];
      update();
    }
  }
}