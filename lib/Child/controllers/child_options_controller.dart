import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/repositories/child_repository.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
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
    
    print('🔍 DEBUG ChildOptionsController.onInit:');
    print('  selectedChild?.id: ${selectedChild?.id}');
    print('  _childId: $_childId');
    
    // Cargar los datos del child
    if (_childId != null) {
      Future.microtask(() => loadChildDetails());
    } else {
      print('❌ ERROR: No se encontró child ID');
      _isLoading.value = false;
      update();
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
      print('⚠️  WARNING: overlayContext no disponible, reintentando...');
      await Future.delayed(Duration(milliseconds: 200));
    }
    
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      print('❌ ERROR: No se pudo obtener overlayContext');
      _isLoading.value = false;
      update();
      return;
    }

    // final customDialog = CustomDialog(context: overlayContext);
    // customDialog.show();

    try {
      print('📡 DEBUG: Llamando a getChildById con ID: $_childId');
      ResponseRequest response = await ChildRepository().getChildById(childId: _childId!);

      print('📥 DEBUG: Respuesta recibida:');
      print('  success: ${response.success}');
      print('  message: ${response.message}');
      print('  statusCode: ${response.statusCode}');

      // customDialog.hide();

      if (!response.success) {
        print('❌ ERROR: La respuesta no fue exitosa');
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
      print('🔍 DEBUG: Analizando estructura de datos:');
      print('  responseData type: ${responseData.runtimeType}');
      
      Map<String, dynamic>? childData;
      
      if (responseData is Map) {
        print('  responseData es Map');
        print('  responseData keys: ${responseData.keys}');
        
        // Intentar obtener data de diferentes formas
        if (responseData.containsKey('data')) {
          childData = responseData['data'] as Map<String, dynamic>?;
          print('  childData desde responseData[\'data\']: ${childData != null}');
        } else {
          // Si no hay 'data', puede que el objeto completo sea el child
          childData = responseData as Map<String, dynamic>?;
          print('  childData desde responseData completo: ${childData != null}');
        }
      } else {
        print('  responseData NO es Map, es: ${responseData.runtimeType}');
      }
      
      if (childData != null) {
        print('✅ DEBUG: Intentando parsear child desde childData');
        print('  childData keys: ${childData.keys}');
        try {
          _child = Child.fromMap(childData);
          print('✅ DEBUG: Child cargado exitosamente');
          print('  ID: ${_child!.id}');
          print('  Nombre: ${_child!.firstName} ${_child!.paternalLastName}');
        } catch (e, stackTrace) {
          print('❌ ERROR parseando Child: $e');
          print('  StackTrace: $stackTrace');
          final overlayContext = Get.overlayContext;
          if (overlayContext != null) {
            CustomSnackBar(context: overlayContext).show(
              message: 'Error al procesar los datos del infante: $e'
            );
          }
        }
      } else {
        print('❌ ERROR: childData es null');
        print('  responseData completo: $responseData');
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se encontraron datos del infante en la respuesta'
          );
        }
      }
    } catch (e, stackTrace) {
      print('❌ ERROR EXCEPTION en loadChildDetails:');
      print('  Error: $e');
      print('  StackTrace: $stackTrace');
      // customDialog.hide();
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

