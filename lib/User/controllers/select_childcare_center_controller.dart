import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/User/models/childcare_center_model.dart';
import 'package:cuidado_infantil/User/repositories/user_repository.dart';
import 'package:get/get.dart';

class SelectChildcareCenterController extends GetxController {

  List<ChildcareCenter> childcareCenters = [];
  ChildcareCenter? currentChildcareCenter;
  bool isLoading = true;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading = true;
    errorMessage = null;
    update();

    // Obtener el childcare center actual del storage
    currentChildcareCenter = StorageService.instance.getChildcareCenter();

    // Obtener la lista de childcare centers del endpoint
    final response = await UserRepository().getAuthenticatedUser();

    if (response.success && response.data != null) {
      final userData = response.data['data'] as Map<String, dynamic>;
      final childcareCentersData = userData['childcareCenters']?['data'] as List?;

      if (childcareCentersData != null) {
        childcareCenters = childcareCentersData
            .map((json) => ChildcareCenter.fromApiResponse(json))
            .toList();
      }
    } else {
      errorMessage = response.message;
    }

    isLoading = false;
    update();
  }

  /// Verifica si el centro es el actualmente seleccionado
  bool isSelected(ChildcareCenter center) {
    return currentChildcareCenter?.id == center.id;
  }

  /// Selecciona un centro de cuidado y lo guarda en storage
  Future<void> selectChildcareCenter(ChildcareCenter center) async {
    if (isSelected(center)) return; // No hacer nada si ya está seleccionado

    await StorageService.instance.setChildcareCenter(center);
    currentChildcareCenter = center;
    
    // Actualizar el SessionController global
    Get.find<SessionController>().loadSession();
    
    update();
    
    // Volver a la pantalla anterior
    Get.back();
  }

  /// Recargar la lista
  Future<void> reloadData() async {
    await _loadData();
  }
}

