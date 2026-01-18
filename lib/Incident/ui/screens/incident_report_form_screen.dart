import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:cuidado_infantil/Incident/controllers/incident_report_form_controller.dart';
import 'package:cuidado_infantil/Incident/ui/widgets/child_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class IncidentReportFormScreen extends StatefulWidget {
  static final String routeName = '/incident_report_form';
  const IncidentReportFormScreen({super.key});

  @override
  State<IncidentReportFormScreen> createState() => _IncidentReportFormScreenState();
}

class _IncidentReportFormScreenState extends State<IncidentReportFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IncidentReportFormController>(
      init: IncidentReportFormController(),
      builder: (controller) {
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
                "Nuevo Reporte de Incidente",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: GetBuilder<IncidentReportFormController>(
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
                    
                    // Selector de Child
                    LabelForm(text: 'Niño: *'),
                    GetBuilder<IncidentReportFormController>(
                      id: 'selected_child',
                      builder: (controller) {
                        final selectedChild = controller.selectedChild;
                        final room = controller.getRoomById(selectedChild?.roomId);
                        
                        return FormFieldShadow(
                          child: FormBuilderField<String>(
                            name: 'child_id',
                            validator: FormBuilderValidators.required(errorText: 'Campo requerido'),
                            builder: (FormFieldState<String> field) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ChildSelectorDialog(
                                      children: controller.children,
                                      selectedChild: controller.selectedChild,
                                      getRoomName: (roomId) => controller.getRoomById(roomId)?.name,
                                      onChildSelected: (child) {
                                        controller.setSelectedChild(child);
                                        field.didChange(child.id);
                                        field.validate();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                  child: Row(
                                    children: [
                                      if (selectedChild != null)
                                        CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: _getAvatarColor(selectedChild.id ?? ''),
                                          child: Text(
                                            selectedChild.getInitials(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      else
                                        Icon(
                                          UiIcons.user_1,
                                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                                          size: 24.sp,
                                        ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: selectedChild == null
                                            ? Text(
                                                'Selecciona un niño',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).hintColor,
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    selectedChild.getFullName(),
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  if (room != null)
                                                    Text(
                                                      'Grupo: ${room.name}',
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Theme.of(context).hintColor,
                                                      ),
                                                    ),
                                                  if (selectedChild.birthDate != null)
                                                    Text(
                                                      'Nacimiento: ${_formatDate(selectedChild.birthDate!)}',
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Theme.of(context).hintColor,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Tipo de incidente
                    LabelForm(text: 'Tipo de Incidente: *'),
                    FormFieldShadow(
                      child: FormBuilderDropdown<String>(
                        name: 'type',
                        style: Theme.of(context).textTheme.bodySmall,
                        decoration: FormInputDecoration(
                          context: context,
                          icon: Icon(
                            UiIcons.inbox,
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'accidente', child: Text('Accidente')),
                          DropdownMenuItem(value: 'conducta_inapropiada', child: Text('Conducta Inapropiada')),
                          DropdownMenuItem(value: 'lesion_fisica', child: Text('Lesión Física')),
                          DropdownMenuItem(value: 'negligencia', child: Text('Negligencia')),
                          DropdownMenuItem(value: 'maltrato_psicologico', child: Text('Maltrato Psicológico')),
                          DropdownMenuItem(value: 'maltrato_fisico', child: Text('Maltrato Físico')),
                          DropdownMenuItem(value: 'otro', child: Text('Otro')),
                        ],
                        validator: FormBuilderValidators.required(errorText: 'Campo requerido'),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Descripción
                    LabelForm(text: 'Descripción: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'description',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 4,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Campo requerido'),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Describe el incidente...',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Fecha del incidente
                    LabelForm(text: 'Fecha del Incidente: *'),
                    FormFieldShadow(
                      child: FormBuilderDateTimePicker(
                        name: 'incident_date',
                        style: Theme.of(context).textTheme.bodySmall,
                        inputType: InputType.date,
                        format: DateFormat('yyyy-MM-dd'),
                        decoration: FormInputDecoration(
                          context: context,
                          icon: Icon(
                            UiIcons.calendar,
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                          ),
                        ),
                        validator: FormBuilderValidators.required(errorText: 'Campo requerido'),
                        lastDate: DateTime.now(),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Hora del incidente
                    LabelForm(text: 'Hora del Incidente: *'),
                    FormFieldShadow(
                      child: FormBuilderDateTimePicker(
                        name: 'incident_time',
                        style: Theme.of(context).textTheme.bodySmall,
                        inputType: InputType.time,
                        format: DateFormat('HH:mm'),
                        decoration: FormInputDecoration(
                          context: context,
                          icon: Icon(
                            UiIcons.alarmClock,
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                          ),
                        ),
                        validator: FormBuilderValidators.required(errorText: 'Campo requerido'),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Ubicación del incidente
                    LabelForm(text: 'Ubicación del Incidente: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'incident_location',
                        style: Theme.of(context).textTheme.bodySmall,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Campo requerido'),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Ej: En el centro en el patio de atrás',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Personas involucradas
                    LabelForm(text: 'Personas Involucradas: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'people_involved',
                        style: Theme.of(context).textTheme.bodySmall,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Campo requerido'),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Ej: Otros niños',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Testigos
                    LabelForm(text: 'Testigos:'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'witnesses',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Ej: Profesora María, Auxiliar Juan',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ¿Hay evidencia?
                    FormFieldShadow(
                      child: GetBuilder<IncidentReportFormController>(
                        id: 'has_evidence',
                        builder: (controller) {
                          return CheckboxListTile(
                            title: Text('¿Hay evidencia?'),
                            value: controller.hasEvidence,
                            activeColor: Theme.of(context).colorScheme.secondary,
                            checkColor: Colors.white,
                            onChanged: (value) {
                              controller.setHasEvidence(value ?? false);
                            },
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Descripción de evidencia (solo si has_evidence es true)
                    GetBuilder<IncidentReportFormController>(
                      id: 'has_evidence',
                      builder: (controller) {
                        if (!controller.hasEvidence) {
                          return SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelForm(text: 'Descripción de la Evidencia:'),
                            FormFieldShadow(
                              child: FormBuilderTextField(
                                name: 'evidence_description',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 3,
                                autovalidateMode: controller.hasAttemptedSave
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                decoration: FormInputDecoration(
                                  context: context,
                                  placeholder: 'Describe la evidencia...',
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        );
                      },
                    ),

                    // Archivos de evidencia (solo si has_evidence es true)
                    GetBuilder<IncidentReportFormController>(
                      id: 'has_evidence',
                      builder: (controller) {
                        if (!controller.hasEvidence) {
                          return SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelForm(text: 'Archivos de Evidencia (Imágenes):'),
                            GetBuilder<IncidentReportFormController>(
                              id: 'evidence_files',
                              builder: (controller) {
                                return Column(
                                  children: [
                                    // Botón para agregar archivos
                                    FormFieldShadow(
                                      child: FormBuilderFilePicker(
                                        name: 'evidence_files',
                                        maxFiles: 10,
                                        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          border: InputBorder.none,
                                        ),
                                        previewImages: true,
                                        typeSelectors: [
                                          TypeSelector(
                                            type: FileType.custom,
                                            selector: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 25.w),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.add_photo_alternate,
                                                    color: Theme.of(context).colorScheme.secondary,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text('Agregar Imágenes'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          // Limpiar archivos previos y agregar todos los nuevos
                                          controller.clearEvidenceFiles();
                                          if (value != null) {
                                            for (var file in value) {
                                              controller.addEvidenceFile(file);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                          ],
                        );
                      },
                    ),

                    // Acciones tomadas
                    LabelForm(text: 'Acciones Tomadas:'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'actions_taken',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 4,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Describe las acciones que se tomaron...',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Reportado a
                    LabelForm(text: 'Reportado a:'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'escalated_to',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Indique a quién se reportó el incidente...',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Comentarios adicionales
                    LabelForm(text: 'Comentarios Adicionales:'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'additional_comments',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 4,
                        autovalidateMode: controller.hasAttemptedSave
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        decoration: FormInputDecoration(
                          context: context,
                          placeholder: 'Comentarios adicionales sobre el incidente...',
                        ),
                      ),
                    ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: GetBuilder<IncidentReportFormController>(
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
                            'Guardar',
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

  Color _getAvatarColor(String childId) {
    final colors = [
      Color(0xFF3498DB), Color(0xFF2ECC71), Color(0xFFE74C3C),
      Color(0xFF9B59B6), Color(0xFFF39C12), Color(0xFF1ABC9C),
      Color(0xFFE67E22), Color(0xFFE74C3C), Color(0xFF95A5A6),
    ];
    if (childId.isEmpty) return colors[0];
    final hash = childId.hashCode;
    final index = hash.abs() % colors.length;
    return colors[index].withAlpha(255);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

}

