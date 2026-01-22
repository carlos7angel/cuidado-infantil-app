import 'package:cuidado_infantil/Child/models/family_member.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class FamilyMemberDialog extends StatefulWidget {
  final FamilyMember? member;
  final void Function(FamilyMember) onSave;

  const FamilyMemberDialog({
    super.key,
    this.member,
    required this.onSave,
  });

  @override
  State<FamilyMemberDialog> createState() => _FamilyMemberDialogState();
}

class _FamilyMemberDialogState extends State<FamilyMemberDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late bool _hasIncome;

  @override
  void initState() {
    _hasIncome = widget.member?.hasIncome ?? false;
    super.initState();
  }

  void _clearIncomeFields() {
    _formKey.currentState?.fields['workplace']?.didChange('');
    _formKey.currentState?.fields['income_type']?.didChange('');
    _formKey.currentState?.fields['income_total']?.didChange('');
  }

  @override
  Widget build(BuildContext context) {

    var width = (MediaQuery.of(context).size.width).w;

    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10.h, top: 10.h, left: 10.w,right: 10.w),
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: 1 * MediaQuery.of(context).size.height,
        ),
        child: Container(
          width: width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.member == null ? 'Nuevo familiar' : 'Editar familiar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 20.h,
                    bottom: 20.h + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'first_name': widget.member?.firstName ?? '',
                      'last_name': widget.member?.lastName ?? '',
                      'birth_date': widget.member?.birthDate,
                      'relationship': widget.member?.relationship ?? '',
                      'gender': widget.member?.gender ?? '',
                      'education_level': widget.member?.educationLevel ?? '',
                      'marital_status': widget.member?.maritalStatus ?? '',
                      'phone': widget.member?.phone ?? '',
                      'profession': widget.member?.profession ?? '',
                      'has_income': widget.member?.hasIncome ?? false,
                      'workplace': widget.member?.workplace ?? '',
                      'income_type': widget.member?.incomeType ?? '',
                      'income_total': widget.member?.incomeTotal ?? '',
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelForm(text: 'Nombres *'),
                        FormFieldShadow(
                          child: FormBuilderTextField(
                            name: 'first_name',
                            style: Theme.of(context).textTheme.bodySmall,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.maxLength(150),
                            ]),
                            decoration: FormInputDecoration(context: context),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Apellidos *'),
                        FormFieldShadow(
                          child: FormBuilderTextField(
                            name: 'last_name',
                            style: Theme.of(context).textTheme.bodySmall,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.maxLength(150),
                            ]),
                            decoration: FormInputDecoration(context: context),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Fecha de nacimiento'),
                        FormFieldShadow(
                          child: FormBuilderDateTimePicker(
                            name: 'birth_date',
                            inputType: InputType.date,
                            lastDate: DateTime.now(),
                            format: DateFormat('dd/MM/yyyy'),
                            decoration: FormInputDecoration(context: context),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Relación de familia *'),
                        FormFieldShadow(
                          child: FormBuilderDropdown(
                            name: 'relationship',
                            style: Theme.of(context).textTheme.bodySmall,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: FormInputDecoration(context: context),
                            items: const [
                              DropdownMenuItem(value: 'madre', child: Text('Madre')),
                              DropdownMenuItem(value: 'padre', child: Text('Padre')),
                              DropdownMenuItem(value: 'hermano', child: Text('Hermano')),
                              DropdownMenuItem(value: 'abuela', child: Text('Abuela')),
                              DropdownMenuItem(value: 'abuelo', child: Text('Abuelo')),
                              DropdownMenuItem(value: 'tio', child: Text('Tío')),
                              DropdownMenuItem(value: 'tia', child: Text('Tía')),
                              DropdownMenuItem(value: 'primo', child: Text('Primo')),
                              DropdownMenuItem(value: 'padrastro', child: Text('Padrastro')),
                              DropdownMenuItem(value: 'madrastra', child: Text('Madrastra')),
                              DropdownMenuItem(value: 'otro', child: Text('Otro')),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Género *'),
                        FormFieldShadow(
                          child: FormBuilderDropdown(
                            name: 'gender',
                            style: Theme.of(context).textTheme.bodySmall,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: FormInputDecoration(context: context),
                            items: const [
                              DropdownMenuItem(value: 'masculino', child: Text('Hombre')),
                              DropdownMenuItem(value: 'femenino', child: Text('Mujer')),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Nivel de educación *'),
                        FormFieldShadow(
                          child: FormBuilderDropdown(
                            name: 'education_level',
                            style: Theme.of(context).textTheme.bodySmall,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: FormInputDecoration(context: context),
                            items: const [
                              DropdownMenuItem(value: 'primaria', child: Text('Primaria')),
                              DropdownMenuItem(value: 'secundaria', child: Text('Secundaria')),
                              DropdownMenuItem(value: 'tecnico', child: Text('Técnico')),
                              DropdownMenuItem(value: 'ninguno', child: Text('Ninguno')),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Estado civil *'),
                        FormFieldShadow(
                          child: FormBuilderDropdown(
                            name: 'marital_status',
                            style: Theme.of(context).textTheme.bodySmall,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: FormInputDecoration(context: context),
                            items: const [
                              DropdownMenuItem(value: 'soltero', child: Text('Soltero')),
                              DropdownMenuItem(value: 'casado', child: Text('Casado')),
                              DropdownMenuItem(value: 'divorciado', child: Text('Divorciado')),
                              DropdownMenuItem(value: 'viudo', child: Text('Viudo')),
                              DropdownMenuItem(value: 'concubino', child: Text('Concubino')),
                              DropdownMenuItem(value: 'separado', child: Text('Separado')),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Celular'),
                        FormFieldShadow(
                          child: FormBuilderTextField(
                            name: 'phone',
                            style: Theme.of(context).textTheme.bodySmall,
                            keyboardType: TextInputType.phone,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.maxLength(20, checkNullOrEmpty: false),
                            ]),
                            decoration: FormInputDecoration(context: context),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: 'Profesión u ocupación'),
                        FormFieldShadow(
                          child: FormBuilderTextField(
                            name: 'profession',
                            style: Theme.of(context).textTheme.bodySmall,
                            keyboardType: TextInputType.text,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.maxLength(150, checkNullOrEmpty: false),
                            ]),
                            decoration: FormInputDecoration(context: context),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        LabelForm(text: '¿Tiene ingresos? *'),
                        FormBuilderRadioGroup<bool>(
                          name: 'has_income',
                          orientation: OptionsOrientation.horizontal,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChanged: (val) {
                            final has = val ?? false;
                            setState(() {
                              _hasIncome = has;
                            });
                            if (!has) {
                              _clearIncomeFields();
                            }
                          },
                          options: const [
                            FormBuilderFieldOption(value: true, child: Text('Sí')),
                            FormBuilderFieldOption(value: false, child: Text('No')),
                          ],
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            border: InputBorder.none,
                          ),
                        ),
                        if (_hasIncome) ...[
                          SizedBox(height: 15.h),
                          LabelForm(text: 'Lugar de trabajo'),
                          FormFieldShadow(
                            child: FormBuilderTextField(
                              name: 'workplace',
                              style: Theme.of(context).textTheme.bodySmall,
                              decoration: FormInputDecoration(context: context),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          LabelForm(text: 'Tipo de ingreso'),
                          FormFieldShadow(
                            child: FormBuilderDropdown(
                              name: 'income_type',
                              style: Theme.of(context).textTheme.bodySmall,
                              decoration: FormInputDecoration(context: context),
                              items: const [
                                DropdownMenuItem(value: 'diario', child: Text('Diario')),
                                DropdownMenuItem(value: 'semanal', child: Text('Semanal')),
                                DropdownMenuItem(value: 'quincenal', child: Text('Quincenal')),
                                DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.h),
                          LabelForm(text: 'Total de ingresos'),
                          FormFieldShadow(
                            child: FormBuilderTextField(
                              name: 'income_total',
                              style: Theme.of(context).textTheme.bodySmall,
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.maxLength(20),
                              ]),
                              decoration: FormInputDecoration(context: context),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ] else
                          SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 70.w),
                      shape: StadiumBorder(),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 0
                    ),
                    onPressed: () {
                      final formState = _formKey.currentState;
                      if (formState == null) return;
                      if (!formState.saveAndValidate()) return;
                      final values = formState.value;
                      final newMember = FamilyMember(
                        firstName: values['first_name'] ?? '',
                        lastName: values['last_name'] ?? '',
                        birthDate: values['birth_date'],
                        relationship: values['relationship'] ?? '',
                        gender: values['gender'] ?? '',
                        educationLevel: values['education_level'] ?? '',
                        maritalStatus: values['marital_status'] ?? '',
                        phone: values['phone'] ?? '',
                        profession: values['profession'] ?? '',
                        hasIncome: values['has_income'] ?? false,
                        workplace: values['workplace'] ?? '',
                        incomeType: values['income_type'] ?? '',
                        incomeTotal: values['income_total'] ?? '',
                      );
                      widget.onSave(newMember);
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.member == null ? 'Agregar' : 'Guardar cambios', style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

