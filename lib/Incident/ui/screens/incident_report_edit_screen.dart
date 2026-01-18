import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:cuidado_infantil/Incident/controllers/incident_report_edit_controller.dart';
import 'package:cuidado_infantil/Incident/ui/widgets/incident_child_details_card.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IncidentReportEditScreen extends StatefulWidget {
  static final String routeName = '/incident_report_edit';
  const IncidentReportEditScreen({super.key});

  @override
  State<IncidentReportEditScreen> createState() => _IncidentReportEditScreenState();
}

class _IncidentReportEditScreenState extends State<IncidentReportEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IncidentReportEditController>(
      init: IncidentReportEditController(),
      builder: (controller) {
        if (controller.incidentReport == null) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: GradientText(
                config.PRIMARY_GRADIENT,
                "Editar Incidente",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: Center(
              child: Text('No se encontró el reporte'),
            ),
          );
        }

        final report = controller.incidentReport!;
        final severityColor = _parseColor(report.severityColor ?? '#9E9E9E');
        final statusColor = _getStatusColor(report.status);

        return PopScope(
          canPop: true,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: GradientText(
                config.PRIMARY_GRADIENT,
                "Editar Incidente",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: GetBuilder<IncidentReportEditController>(
              id: 'form_validation',
              builder: (controller) {
                return FormBuilder(
                  key: controller.fbKey,
                  autovalidateMode: controller.hasAttemptedSave
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5.h),

                        // Card del Child si existe
                        if (report.child != null) ...[
                          IncidentChildDetailsCard(child: report.child!),
                          SizedBox(height: 20.h),
                        ],

                        // Información del reporte (solo lectura)
                        _buildReportInfoCard(context, report, severityColor, statusColor),

                        SizedBox(height: 20.h),

                        // Campos editables
                        _buildEditableFields(context, controller),

                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: GetBuilder<IncidentReportEditController>(
              builder: (controller) => Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => controller.saveIncidentReport(),
                      child: Container(
                        height: 50.h,
                        width: 150.w,
                        padding: EdgeInsets.only(left: 15.w),
                        decoration: BoxDecoration(
                          gradient: config.PRIMARY_GRADIENT,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(100.r))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(UiIcons.cursor, size: 20.sp, color: Colors.white),
                            Container(margin: EdgeInsets.only(left: 10.w)),
                            Text(
                              'Actualizar',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportInfoCard(BuildContext context, report, Color severityColor, Color statusColor) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (report.severityLevel != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    report.severityLabel ?? 'N/A',
                    style: TextStyle(
                      color: severityColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  report.statusLabel ?? 'N/A',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          _buildInfoRow(context, 'Código', report.code ?? 'N/A'),
          SizedBox(height: 10.h),
          _buildInfoRow(context, 'Tipo', report.typeLabel ?? 'N/A'),
          SizedBox(height: 10.h),
          if (report.incidentDateTimeReadable != null)
            _buildInfoRow(context, 'Fecha y Hora', report.incidentDateTimeReadable!),
          if (report.reportedAtReadable != null) ...[
            SizedBox(height: 10.h),
            _buildInfoRow(context, 'Reportado el', report.reportedAtReadable!),
          ],
        ],
      ),
    );
  }

  Widget _buildEditableFields(BuildContext context, IncidentReportEditController controller) {
    final report = controller.incidentReport!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Descripción
        LabelForm(text: 'Descripción:'),
        FormFieldShadow(
          child: FormBuilderTextField(
            name: 'description',
            initialValue: report.description ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 4,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: FormInputDecoration(
              context: context,
              placeholder: 'Describe el incidente...',
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Acciones tomadas
        LabelForm(text: 'Acciones Tomadas:'),
        FormFieldShadow(
          child: FormBuilderTextField(
            name: 'actions_taken',
            initialValue: report.actionsTaken ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: FormInputDecoration(
              context: context,
              placeholder: 'Describe las acciones que se tomaron...',
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Comentarios adicionales
        LabelForm(text: 'Comentarios Adicionales:'),
        FormFieldShadow(
          child: FormBuilderTextField(
            name: 'additional_comments',
            initialValue: report.additionalComments ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: FormInputDecoration(
              context: context,
              placeholder: 'Comentarios adicionales sobre el incidente...',
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Seguimiento
        LabelForm(text: 'Seguimiento:'),
        FormFieldShadow(
          child: FormBuilderTextField(
            name: 'follow_up_notes',
            initialValue: report.followUpNotes ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: FormInputDecoration(
              context: context,
              placeholder: 'Información de seguimiento del caso...',
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Notificación a autoridades
        LabelForm(text: 'Notificación a Autoridades:'),
        FormFieldShadow(
          child: FormBuilderTextField(
            name: 'authority_notification_details',
            initialValue: report.authorityNotificationDetails ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: FormInputDecoration(
              context: context,
              placeholder: 'Detalles de notificación a autoridades...',
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).hintColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (e) {
      // Si falla, retornar gris por defecto
    }
    return Colors.grey;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'reportado':
        return Colors.blue;
      case 'en_revision':
        return Colors.orange;
      case 'cerrado':
        return Colors.green;
      case 'escalado':
        return Colors.red;
      case 'archivado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
