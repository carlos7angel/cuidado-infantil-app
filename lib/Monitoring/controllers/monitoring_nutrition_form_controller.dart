import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_nutrition_list_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/create_nutritional_assessment_request.dart';
import 'package:cuidado_infantil/Monitoring/repositories/monitoring_nutrition_repository.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;

class MonitoringNutritionFormController extends GetxController {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;

  Child? _selectedChild;
  Child? get selectedChild => _selectedChild;

  String? _weight;
  String? _height;
  String? _actions_taken;
  

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
  }

  Future<void> saveEvaluation() async {
    final customDialog = CustomDialog(context: Get.overlayContext!);

    // Validar formulario
    if (!_fbKey.currentState!.saveAndValidate()) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Por favor, complete todos los campos obligatorios'
      );
      return;
    }

    // Obtener valores del formulario
    final formValues = _fbKey.currentState!.value;
    _weight = formValues['weight']?.toString().trim();
    _height = formValues['height']?.toString().trim();
    _actions_taken = formValues['actions_taken']?.toString().trim();

    if (_weight == null || _weight!.isEmpty || _height == null || _height!.isEmpty) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Por favor, complete los campos de peso y talla'
      );
      return;
    }

    if (_selectedChild?.id == null) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'No hay un infante seleccionado'
      );
      return;
    }

    // Mostrar loading
    customDialog.show();

    try {
      final request = CreateNutritionalAssessmentRequest(
        childId: _selectedChild!.id!,
        weight: _weight!,
        height: _height!,
        actionsTaken: _actions_taken,
      );

      final response = await MonitoringNutritionRepository().createEvaluation(
        request: request,
      );

      customDialog.hide();

      if (!response.success) {
        CustomSnackBar(context: Get.overlayContext!).show(
          message: response.message
        );
        return;
      }

      // Mostrar modal de éxito
      _showSuccessDialog();

    } catch (e) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Error inesperado al guardar la evaluación'
      );
    }
  }

  void _showSuccessDialog() {
    NDialog dialog = NDialog(
      title: Text(
        "Evaluación guardada",
        style: Theme.of(Get.overlayContext!).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/correct.gif', height: 90.h),
          SizedBox(height: 10.h),
          Text(
            "La evaluación nutricional ha sido guardada exitosamente.",
            style: Theme.of(Get.overlayContext!).textTheme.bodyMedium?.merge(
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
          onPressed: () {
            Get.back(); // Cerrar el modal
            
            // Recargar la lista antes de navegar
            try {
              final listController = Get.find<MonitoringNutritionListController>();
              listController.refreshEvaluations();
            } catch (e) {
              print('⚠️ No se pudo encontrar el controlador del listado: $e');
            }
            
            Get.offNamed(MonitoringNutritionListScreen.routeName); // Ir al listado
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
              color: Theme.of(Get.overlayContext!).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
    dialog.show(Get.overlayContext!, dismissable: false);
  }

  void clearForm() {
    _fbKey.currentState?.reset();
  }
}
