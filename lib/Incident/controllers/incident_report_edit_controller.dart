import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Incident/models/incident_report.dart';
import 'package:cuidado_infantil/Incident/models/update_incident_report_request.dart';
import 'package:cuidado_infantil/Incident/repositories/incident_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class IncidentReportEditController extends GetxController {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;

  IncidentReport? _incidentReport;
  IncidentReport? get incidentReport => _incidentReport;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  bool _hasAttemptedSave = false;
  bool get hasAttemptedSave => _hasAttemptedSave;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is IncidentReport) {
      _incidentReport = args;
    }
  }

  Future<void> saveIncidentReport() async {
    // Marcar que se ha intentado guardar
    _hasAttemptedSave = true;
    update(['form_validation']);

    // Validar el formulario
    if (_fbKey.currentState?.saveAndValidate() != true) {
      return;
    }

    final formData = _fbKey.currentState!.value;
    
    _isSaving = true;
    update(['saving']);

    final overlayContext = Get.overlayContext;
    CustomDialog? customDialog;
    if (overlayContext != null) {
      customDialog = CustomDialog(context: overlayContext);
      customDialog.show();
    }

    try {
      final request = UpdateIncidentReportRequest(
        description: formData['description'] as String,
        actionsTaken: formData['actions_taken']?.toString(),
        additionalComments: formData['additional_comments']?.toString(),
        followUpNotes: formData['follow_up_notes']?.toString(),
        authorityNotificationDetails: formData['authority_notification_details']?.toString(),
      );

      final response = await IncidentReportRepository().updateIncidentReport(
        incidentReportId: _incidentReport!.id!,
        request: request,
      );

      // Ocultar dialog siempre, sin importar el resultado
      if (customDialog != null) {
        customDialog.hide();
      }

      if (!response.success) {
        CustomSnackBar(context: Get.overlayContext!).show(
          message: 'Error al actualizar el reporte: ${response.message}'
        );
        _isSaving = false;
        update(['saving']);
        return;
      }

      _showSuccessDialog();
    } catch (e) {
      // Ocultar dialog en caso de excepción
      if (customDialog != null) {
        customDialog.hide();
      }

      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Error al actualizar el reporte: $e'
      );
      _isSaving = false;
      update(['saving']);
    }
  }

  void _showSuccessDialog() {
    // Asegurarse de que el CustomDialog esté completamente cerrado
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      final customDialog = CustomDialog(context: overlayContext);
      customDialog.hide();
    }

    // Mostrar el modal de éxito en el próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.overlayContext;
      if (context == null) {
        return;
      }

      NDialog dialog = NDialog(
        title: Text(
          "Reporte actualizado",
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
              "El reporte de incidente ha sido actualizado exitosamente.",
              style: Theme.of(context).textTheme.bodyMedium?.merge(
                TextStyle(color: Color(0xFF666666), fontSize: 13.sp)
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
              // Cerrar el modal de éxito
              Navigator.of(context).pop();

              // Navegar de vuelta al detalle del incidente (refrescar)
              Get.offNamedUntil(
                '/incident_report_details',
                (route) => route.settings.name == '/incident_report_list',
                arguments: _incidentReport!.id,
              );
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
              ),
            ),
          ),
        ],
      );
      dialog.show(context, dismissable: false);
    });
  }
}
