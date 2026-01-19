import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ChildMedicalTab extends StatefulWidget {
  final ChildFormController controller;

  const ChildMedicalTab({
    super.key,
    required this.controller,
  });

  @override
  State<ChildMedicalTab> createState() => _ChildMedicalTabState();
}

class _ChildMedicalTabState extends State<ChildMedicalTab> with AutomaticKeepAliveClientMixin {
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
                'Datos médicos del infante',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: '¿Tiene seguro?: *'),
          FormBuilderRadioGroup(
            name: 'has_insurance',
            orientation: OptionsOrientation.horizontal,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            onChanged: (val) => widget.controller.updateChildField('has_insurance', val),
            options: [
              FormBuilderFieldOption(value: '1', child: Text('Si')),
              FormBuilderFieldOption(value: '0', child: Text('No')),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              border: InputBorder.none,
            )
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Detalle del Seguro:'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'insurance_details',
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.name,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(150, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.shield,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                ),
              ),
              // initialValue: _.denunciationData.fullName,
              onChanged: (val) => widget.controller.updateChildField('insurance_details', val),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Peso (Kg): *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'weight',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        decoration: FormInputDecoration(context: context),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('weight', val),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Altura (cm): *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'height',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        decoration: FormInputDecoration(context: context),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('height', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LabelForm(text: '¿Tiene alergias?:'),
          FormBuilderRadioGroup(
              name: 'has_allergies',
              orientation: OptionsOrientation.horizontal,
              onChanged: (val) => widget.controller.updateChildField('has_allergies', val),
              options: [
                FormBuilderFieldOption(value: '1', child: Text('Si')),
                FormBuilderFieldOption(value: '0', child: Text('No')),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                border: InputBorder.none,
              )
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Describa las alergias: '),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'allergies_details',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              //   FormBuilderValidators.maxLength(600)
              // ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('allergies_details', val),
              // initialValue: _.denunciationData.details,
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Presenta tratamiento médico:'),
          FormBuilderRadioGroup(
            name: 'has_medical_treatment',
            orientation: OptionsOrientation.horizontal,
            onChanged: (val) => widget.controller.updateChildField('has_medical_treatment', val),
            options: [
              FormBuilderFieldOption(value: '1', child: Text('Si')),
              FormBuilderFieldOption(value: '0', child: Text('No')),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              border: InputBorder.none,
            )
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Especificar tratamiento médico:'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'medical_treatment_details',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('medical_treatment_details', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Presenta tratamiento psicológico:'),
          FormBuilderRadioGroup(
            name: 'has_psychological_treatment',
            orientation: OptionsOrientation.horizontal,
            onChanged: (val) => widget.controller.updateChildField('has_psychological_treatment', val),
            options: [
              FormBuilderFieldOption(value: '1', child: Text('Si')),
              FormBuilderFieldOption(value: '0', child: Text('No')),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              border: InputBorder.none,
            )
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Especificar tratamiento psicológico:'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'psychological_treatment_details',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('psychological_treatment_details', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Presenta déficit de grado:'),
          FormBuilderRadioGroup(
            name: 'has_deficit',
            orientation: OptionsOrientation.horizontal,
            onChanged: (val) => widget.controller.updateChildField('has_deficit', val),
            options: [
              FormBuilderFieldOption(value: '1', child: Text('Si')),
              FormBuilderFieldOption(value: '0', child: Text('No')),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              border: InputBorder.none,
            )
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Déficit auditivo:'),
                    FormFieldShadow(
                      child: FormBuilderDropdown(
                        name: 'deficit_auditory',
                        style: Theme.of(context).textTheme.bodySmall,
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'alto', child: Text('Alto')),
                          DropdownMenuItem(value: 'medio', child: Text('Medio')),
                          DropdownMenuItem(value: 'bajo', child: Text('Bajo')),
                        ],
                        onChanged: (val) => widget.controller.updateChildField('deficit_auditory', val),
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
                    LabelForm(text: 'Déficit visual:'),
                    FormFieldShadow(
                      child: FormBuilderDropdown(
                        name: 'deficit_visual',
                        style: Theme.of(context).textTheme.bodySmall,
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'alto', child: Text('Alto')),
                          DropdownMenuItem(value: 'medio', child: Text('Medio')),
                          DropdownMenuItem(value: 'bajo', child: Text('Bajo')),
                        ],
                        onChanged: (val) => widget.controller.updateChildField('deficit_visual', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Déficit táctil:'),
                    FormFieldShadow(
                      child: FormBuilderDropdown(
                        name: 'deficit_tactile',
                        style: Theme.of(context).textTheme.bodySmall,
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'alto', child: Text('Alto')),
                          DropdownMenuItem(value: 'medio', child: Text('Medio')),
                          DropdownMenuItem(value: 'bajo', child: Text('Bajo')),
                        ],
                        onChanged: (val) => widget.controller.updateChildField('deficit_tactile', val),
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
                    LabelForm(text: 'Déficit motor:'),
                    FormFieldShadow(
                      child: FormBuilderDropdown(
                        name: 'deficit_motor',
                        style: Theme.of(context).textTheme.bodySmall,
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'alto', child: Text('Alto')),
                          DropdownMenuItem(value: 'medio', child: Text('Medio')),
                          DropdownMenuItem(value: 'bajo', child: Text('Bajo')),
                        ],
                        onChanged: (val) => widget.controller.updateChildField('deficit_motor', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Presenta enfermedad tipo:'),
          FormBuilderRadioGroup(
            name: 'has_illness',
            orientation: OptionsOrientation.horizontal,
            onChanged: (val) => widget.controller.updateChildField('has_illness', val),
            options: [
              FormBuilderFieldOption(value: '1', child: Text('Si')),
              FormBuilderFieldOption(value: '0', child: Text('No')),
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              border: InputBorder.none,
            )
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Especificar características de la enfermedad:'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'illness_details',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('illness_details', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Problemas de nutrición'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'nutritional_problems',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('nutritional_problems', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Habilidades destacadas'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'outstanding_skills',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('outstanding_skills', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Otras consideraciones:'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'other_observations',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('other_observations', val),
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}

