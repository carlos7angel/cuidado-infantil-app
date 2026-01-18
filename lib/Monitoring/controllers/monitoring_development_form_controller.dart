import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_development_list_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';
import 'package:cuidado_infantil/Monitoring/models/create_child_development_evaluation_request.dart';
import 'package:cuidado_infantil/Monitoring/models/development_items_response.dart';
import 'package:cuidado_infantil/Monitoring/repositories/monitoring_development_repository.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;

class MonitoringDevelopmentFormController extends GetxController {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;

  Child? _selectedChild;
  Child? get selectedChild => _selectedChild;

  bool _loadingItems = true;
  bool get loadingItems => _loadingItems;

  DevelopmentItemsResponse? _developmentItems;
  DevelopmentItemsResponse? get developmentItems => _developmentItems;

  // Mapa para rastrear qué items están marcados como achieved
  final Map<String, bool> _selectedItems = {};
  Map<String, bool> get selectedItems => _selectedItems;

  String? _notes;
  String? _actionsTaken;

  /// Calcula la edad en meses desde la fecha de nacimiento
  int? getAgeInMonths() {
    return Child.calculateAgeInMonths(_selectedChild?.birthDate);
  }

  /// Formatea la edad en meses como string legible
  String getFormattedAgeInMonths() {
    return Child.calculateAgeFromDate(_selectedChild?.birthDate);
  }

  @override
  void onInit() {
    super.onInit();
    _selectedChild = StorageService.instance.getSelectedChild();
    if (_selectedChild?.id != null) {
      Future.microtask(() => loadDevelopmentItems());
    }
  }

  Future<void> loadDevelopmentItems() async {
    if (_selectedChild?.id == null) return;

    _loadingItems = true;
    update(['development_form']);

    try {
      final response = await MonitoringDevelopmentRepository().getDevelopmentItemsByChild(
        childId: _selectedChild?.id ?? '',
      );

      if (!response.success) {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudieron cargar los items de desarrollo. ${response.message}'
          );
        }
        _loadingItems = false;
        update(['development_form']);
        return;
      }

      // Parsear la respuesta
      // El API retorna: { "data": { "items_by_area": {...} } }
      dynamic responseData = response.data;
      
      print('🔍 DEBUG: responseData type: ${responseData.runtimeType}');
      
      if (responseData is Map) {
        // Pasar el responseData completo al parser, que buscará en data.items_by_area
        _developmentItems = DevelopmentItemsResponse.fromJson(responseData as Map<String, dynamic>);
        print('✅ DEBUG: Items de desarrollo cargados - Áreas: ${_developmentItems!.itemsByArea.keys.toList()}');
        print('✅ DEBUG: Total items: ${_developmentItems!.getAllItems().length}');
      } else {
        print('⚠️ WARNING: responseData no es un Map, es: ${responseData.runtimeType}');
        _developmentItems = DevelopmentItemsResponse(itemsByArea: {});
      }

      _loadingItems = false;
      update(['development_form']);
    } catch (e) {
      print('❌ ERROR cargando items de desarrollo: $e');
      final overlayContext = Get.overlayContext;
      if (overlayContext != null) {
        CustomSnackBar(context: overlayContext).show(
          message: 'Error al cargar los items: $e'
        );
      }
      _loadingItems = false;
      update(['development_form']);
    }
  }

  /// Toggle el estado de un item (achieved/not achieved)
  void toggleItem(String developmentItemId) {
    _selectedItems[developmentItemId] = !(_selectedItems[developmentItemId] ?? false);
    update(['development_form']);
  }

  /// Verifica si un item está marcado como achieved
  bool isItemSelected(String developmentItemId) {
    return _selectedItems[developmentItemId] ?? false;
  }

  /// Obtiene la cantidad de items seleccionados por área
  int getSelectedCountByArea(String area) {
    if (_developmentItems == null) return 0;
    final items = _developmentItems!.getItemsByArea(area);
    return items.where((item) => isItemSelected(item.developmentItemId)).length;
  }

  /// Obtiene el total de items por área
  int getTotalCountByArea(String area) {
    if (_developmentItems == null) return 0;
    return _developmentItems!.getItemsByArea(area).length;
  }

  Future<void> saveEvaluation() async {
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      print('❌ ERROR: No se pudo obtener overlayContext');
      return;
    }

    final customDialog = CustomDialog(context: overlayContext);

    // Validar que haya al menos un item seleccionado
    final selectedItemIds = _selectedItems.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    if (selectedItemIds.isEmpty) {
      CustomSnackBar(context: overlayContext).show(
        message: 'Por favor, seleccione al menos un item logrado'
      );
      return;
    }

    // Obtener notas y acciones tomadas del formulario si existe
    if (_fbKey.currentState != null) {
      _fbKey.currentState!.save();
      final formValues = _fbKey.currentState!.value;
      _notes = formValues['notes']?.toString().trim();
      _actionsTaken = formValues['actions_taken']?.toString().trim();
    }

    if (_selectedChild?.id == null) {
      CustomSnackBar(context: overlayContext).show(
        message: 'No hay un infante seleccionado'
      );
      return;
    }

    // Mostrar loading
    customDialog.show();

    try {
      final request = CreateChildDevelopmentEvaluationRequest(
        childId: _selectedChild!.id!,
        items: selectedItemIds,
        notes: _notes,
        actionsTaken: _actionsTaken,
      );

      final response = await MonitoringDevelopmentRepository().createDevelopmentEvaluation(
        request: request,
      );

      // Cerrar el CustomDialog inmediatamente después de recibir la respuesta
      customDialog.hide();
      
      // Esperar un momento para asegurar que el diálogo se cierre completamente
      await Future.delayed(Duration(milliseconds: 300));

      if (!response.success) {
        CustomSnackBar(context: overlayContext).show(
          message: response.message.isNotEmpty 
              ? response.message 
              : 'Error al guardar la evaluación'
        );
        return;
      }

      // Parsear la respuesta para obtener la evaluación creada
      dynamic responseData = response.data;
      Map<String, dynamic>? dataMap;

      if (responseData is Map) {
        if (responseData.containsKey('data')) {
          dataMap = responseData['data'] as Map<String, dynamic>?;
        } else {
          dataMap = responseData as Map<String, dynamic>?;
        }
      }

      ChildDevelopmentEvaluation? createdEvaluation;
      if (dataMap != null) {
        try {
          createdEvaluation = ChildDevelopmentEvaluation.fromJson(dataMap);
        } catch (e) {
          print('⚠️ Error parseando evaluación creada: $e');
        }
      }

      // Mostrar modal de éxito y navegar
      _showSuccessDialog(createdEvaluation);

    } catch (e) {
      customDialog.hide();
      print('❌ ERROR guardando evaluación: $e');
      CustomSnackBar(context: overlayContext).show(
        message: 'Error inesperado al guardar la evaluación'
      );
    }
  }

  void _showSuccessDialog(ChildDevelopmentEvaluation? evaluation) {
    // Asegurarse de que el CustomDialog esté completamente cerrado
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      final customDialog = CustomDialog(context: overlayContext);
      customDialog.hide();
    }
    
    // Esperar un momento antes de mostrar el modal de éxito
    Future.delayed(Duration(milliseconds: 300), () {
      final context = Get.overlayContext;
      if (context == null) {
        print('❌ ERROR: No se pudo obtener overlayContext para el modal de éxito');
        return;
      }
      
      NDialog dialog = NDialog(
        title: Text(
          "Evaluación guardada",
          style: Theme.of(context).textTheme.titleMedium?.merge(
            TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/correct.gif', height: 90.h),
            SizedBox(height: 10.h),
            Text(
              "La evaluación de desarrollo ha sido guardada exitosamente.",
              style: Theme.of(context).textTheme.bodyMedium?.merge(
                TextStyle(color: config.Colors().gray99Color(1), fontSize: 13.sp)
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        dialogStyle: DialogStyle(
          titlePadding: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 30.w, right: 30.w),
          contentPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
          elevation: 0,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Cerrar el modal de éxito
              Navigator.of(context).pop();
              
              // Esperar un momento para que el diálogo se cierre completamente
              await Future.delayed(Duration(milliseconds: 300));
              
              // Asegurarse de cerrar cualquier diálogo que pueda estar abierto
              while (Get.isDialogOpen == true || Navigator.of(context).canPop()) {
                try {
                  Navigator.of(context).pop();
                } catch (e) {
                  break;
                }
              }
              
              // Recargar la lista antes de navegar
              try {
                final listController = Get.find<MonitoringDevelopmentListController>();
                listController.refreshEvaluations();
              } catch (e) {
                print('⚠️ No se pudo encontrar el controlador del listado: $e');
              }
              
              // Navegar a la pantalla de detalles
              if (evaluation != null) {
                Get.offNamed(
                  MonitoringDevelopmentDetailsScreen.routeName,
                  arguments: {'evaluation': evaluation},
                );
              } else {
                Get.offNamed('/monitoring_development_list');
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              overlayColor: Colors.grey.withOpacity(0.2),
            ),
            child: Text(
              "Aceptar",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
      dialog.show(context, dismissable: false);
    });
  }

  void clearForm() {
    _selectedItems.clear();
    _notes = null;
    _actionsTaken = null;
    _fbKey.currentState?.reset();
  }
}

