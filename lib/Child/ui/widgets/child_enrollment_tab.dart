import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Child/ui/widgets/existing_file_field.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChildEnrollmentTab extends StatefulWidget {
  final ChildFormController controller;

  const ChildEnrollmentTab({
    super.key,
    required this.controller,
  });

  @override
  State<ChildEnrollmentTab> createState() => _ChildEnrollmentTabState();
}

class _ChildEnrollmentTabState extends State<ChildEnrollmentTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              visualDensity: VisualDensity.compact,
              leading: Icon(
                UiIcons.inbox,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Datos de inscripción',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Fecha de inscripción: *'),
          FormFieldShadow(
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Theme.of(context).colorScheme.secondary,
              ),
              child: FormBuilderDateTimePicker(
                name: 'enrollment_date',
                inputType: InputType.date,
                initialValue: DateTime.now(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                format: DateFormat('dd/MM/yyyy'),
                style: Theme.of(context).textTheme.bodySmall,
                cancelText: 'Cancelar',
                confirmText: 'Aceptar',
                decoration: FormInputDecoration(
                  context: context,
                  icon: Icon(
                    UiIcons.calendar,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onChanged: (val) => widget.controller.updateChildField('enrollment_date', val),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Grupo: *'),
          FormFieldShadow(
            child: Obx(() {
              final ctrl = widget.controller;
              return FormBuilderDropdown<String>(
                name: 'room_id',
                style: Theme.of(context).textTheme.bodySmall,
                decoration: FormInputDecoration(
                  context: context,
                  icon: Icon(
                    UiIcons.share,
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                  ),
                ),
                enabled: !ctrl.isLoadingRooms,
                items: ctrl.rooms.map((room) => DropdownMenuItem(
                    value: room.id,
                    child: Text(room.name),
                  )).toList(),
                validator: FormBuilderValidators.required(),
                onChanged: (val) => widget.controller.updateChildField('room_id', val),
                hint: ctrl.isLoadingRooms
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Cargando grupos...', style: TextStyle(fontSize: 12)),
                      ],
                    )
                  : Text('Selecciona un grupo'),
              );
            }),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              visualDensity: VisualDensity.compact,
              leading: Icon(
                UiIcons.inbox,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Documentos',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Carta de solicitud de admisión:'),
          ExistingFileField(
            name: 'file_admission_request',
            label: 'Carta de solicitud de admisión',
            existingFiles: widget.controller.originalFiles['file_admission_request'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_admission_request', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Compromiso:'),
          ExistingFileField(
            name: 'file_commitment',
            label: 'Compromiso',
            existingFiles: widget.controller.originalFiles['file_commitment'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_commitment', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Certificado de nacimiento:'),
          ExistingFileField(
            name: 'file_birth_certificate',
            label: 'Certificado de nacimiento',
            existingFiles: widget.controller.originalFiles['file_birth_certificate'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_birth_certificate', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Carnet de vacunas:'),
          ExistingFileField(
            name: 'file_vaccination_card',
            label: 'Carnet de vacunas',
            existingFiles: widget.controller.originalFiles['file_vaccination_card'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_vaccination_card', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Documento de identidad del padre/madre:'),
          ExistingFileField(
            name: 'file_parent_id',
            label: 'Documento de identidad del padre/madre',
            existingFiles: widget.controller.originalFiles['file_parent_id'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_parent_id', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Recibo de agua y luz:'),
          ExistingFileField(
            name: 'file_utility_bill',
            label: 'Recibo de agua y luz',
            existingFiles: widget.controller.originalFiles['file_utility_bill'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_utility_bill', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Croquis del domicilio actual:'),
          ExistingFileField(
            name: 'file_home_sketch',
            label: 'Croquis del domicilio actual',
            existingFiles: widget.controller.originalFiles['file_home_sketch'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_home_sketch', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Autorización de recojo:'),
          ExistingFileField(
            name: 'file_pickup_authorization',
            label: 'Autorización de recojo',
            existingFiles: widget.controller.originalFiles['file_pickup_authorization'],
            maxFiles: 1,
            allowedExtensions: ['pdf'],
            onChanged: (val) => widget.controller.updateChildField('file_pickup_authorization', val),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}





