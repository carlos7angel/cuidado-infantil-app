import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class ChildIdentificationTab extends StatefulWidget {
  final ChildFormController controller;

  const ChildIdentificationTab({
    super.key,
    required this.controller,
  });

  @override
  State<ChildIdentificationTab> createState() => _ChildIdentificationTabState();
}

class _ChildIdentificationTabState extends State<ChildIdentificationTab> with AutomaticKeepAliveClientMixin {
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
                'Datos de identificación del infante',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Apellido Paterno: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'paternal_last_name',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(150),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('paternal_last_name', val),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Apellido Materno:'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'maternal_last_name',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(150),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                          // icon: Icon(
                          //   UiIcons.idCard,
                          //   color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                          // ),
                        ),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('maternal_last_name', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Nombre(s): *'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'first_name',
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.name,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(150),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.idCard,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                ),
              ),
              // initialValue: _.denunciationData.fullName,
              onChanged: (val) => widget.controller.updateChildField('first_name', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Género: *'),
          FormBuilderRadioGroup<String>(
            name: 'gender',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            orientation: OptionsOrientation.horizontal,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            options: const [
              FormBuilderFieldOption(value: 'masculino', child: Text('Hombre')),
              FormBuilderFieldOption(value: 'femenino', child: Text('Mujer')),
            ],
            onChanged: (val) => widget.controller.updateChildField('gender', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Fecha de nacimiento: *'),
          FormFieldShadow(
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Theme.of(context).colorScheme.secondary,
              ),
              child: FormBuilderDateTimePicker(
                name: 'birth_date',
                inputType: InputType.date,
                // firstDate: DateTime.now().subtract(Duration(days: 365 * 30)),
                lastDate: DateTime.now(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                format: DateFormat('dd/MM/yyyy'),
                style: Theme.of(context).textTheme.bodySmall,
                cancelText: 'Cancelar',
                confirmText: 'Aceptar',
                decoration: FormInputDecoration(
                  context: context,
                  // placeholder: 'dd/mm/aaaa',
                  icon: Icon(
                    UiIcons.calendar,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onChanged: (val) => widget.controller.updateChildField('birth_date', val),
                // initialValue: _.denunciationData.dateEvent != null ? _.denunciationData.dateEvent : null,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Dirección: *'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'address',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(600)
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.map,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('address', val),
              // initialValue: _.denunciationData.details,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Departamento: *'),
                    FormFieldShadow(
                      child: FormBuilderDropdown(
                        name: 'state',
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'La Paz', child: Text('La Paz')),
                          DropdownMenuItem(value: 'Cochabamba', child: Text('Cochabamba')),
                          DropdownMenuItem(value: 'Santa Cruz', child: Text('Santa Cruz')),
                          DropdownMenuItem(value: 'Oruro', child: Text('Oruro')),
                          DropdownMenuItem(value: 'Potosí', child: Text('Potosí')),
                          DropdownMenuItem(value: 'Chuquisaca', child: Text('Chuquisaca')),
                          DropdownMenuItem(value: 'Tarija', child: Text('Tarija')),
                          DropdownMenuItem(value: 'Beni', child: Text('Beni')),
                          DropdownMenuItem(value: 'Pando', child: Text('Pando')),
                        ],
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('state', val),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Ciudad: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'city',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(150),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('city', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}

