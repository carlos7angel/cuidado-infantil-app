import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/repositories/child_repository.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:get/get.dart';

class ChildOptionsController extends GetxController {
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Child? _child;
  Child? get child => _child;

  String? _childId;

  @override
  void onInit() {
    super.onInit();
    // Obtener el ID del child desde storage
    final selectedChild = StorageService.instance.getSelectedChild();
    _childId = selectedChild?.id;
    
    // Cargar los datos del child
    if (_childId != null) {
      Future.microtask(() => loadChildDetails());
    } else {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> refreshChildDetails() async {
    if (_childId != null) {
      await loadChildDetails();
    }
  }

  Future<void> loadChildDetails() async {
    if (_childId == null) return;

    _isLoading.value = true;
    update();

    // Esperar a que el contexto esté disponible
    await Future.delayed(Duration(milliseconds: 100));
    
    final context = Get.overlayContext;
    if (context == null) {
      await Future.delayed(Duration(milliseconds: 200));
    }
    
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      _isLoading.value = false;
      update();
      return;
    }

    try {
      ResponseRequest response = await ChildRepository().getChildById(childId: _childId!);

      if (!response.success) {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudieron cargar los datos del infante. ${response.message}'
          );
        }
        _isLoading.value = false;
        update();
        return;
      }

      // El API retorna { "data": { ... } }
      dynamic responseData = response.data;
      
      Map<String, dynamic>? childData;
      
      if (responseData is Map) {
        // Intentar obtener data de diferentes formas
        if (responseData.containsKey('data')) {
          childData = responseData['data'] as Map<String, dynamic>?;
        } else {
          // Si no hay 'data', puede que el objeto completo sea el child
          childData = responseData as Map<String, dynamic>?;
        }
      }
      
      if (childData != null) {
        try {
          _child = Child.fromMap(childData);
        } catch (e) {
          final overlayContext = Get.overlayContext;
          if (overlayContext != null) {
            CustomSnackBar(context: overlayContext).show(
              message: 'Error al procesar los datos del infante: $e'
            );
          }
        }
      } else {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se encontraron datos del infante en la respuesta'
          );
        }
      }
    } catch (e) {
      final overlayContext = Get.overlayContext;
      if (overlayContext != null) {
        CustomSnackBar(context: overlayContext).show(
          message: 'Error al cargar los datos: $e'
        );
      }
    } finally {
      _isLoading.value = false;
      update();
    }
  }
}

