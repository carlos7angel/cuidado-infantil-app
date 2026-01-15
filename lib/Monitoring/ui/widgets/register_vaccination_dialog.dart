import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_dose_info.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class RegisterVaccinationDialog extends StatefulWidget {
  final VaccineInfo vaccine;
  final VaccineDoseInfo doseInfo;
  final Future<bool> Function({
    required String vaccineDoseId,
    required String dateApplied,
    required String appliedAt,
    String? notes,
  }) onRegister;
  final VoidCallback? onSuccess;

  const RegisterVaccinationDialog({
    super.key,
    required this.vaccine,
    required this.doseInfo,
    required this.onRegister,
    this.onSuccess,
  });

  @override
  State<RegisterVaccinationDialog> createState() => _RegisterVaccinationDialogState();
}

class _RegisterVaccinationDialogState extends State<RegisterVaccinationDialog> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = (MediaQuery.of(context).size.width).w;

    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10.h, top: 10.h, left: 10.w, right: 10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Icon(
            UiIcons.shield,
            color: Theme.of(context).colorScheme.secondary,
            size: 24.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Registrar Vacuna',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: width * 0.9,
        constraints: BoxConstraints(
          maxHeight: height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Información de la vacuna y dosis
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        UiIcons.information,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Información de la vacuna',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Tipo de vacuna: ${widget.vaccine.vaccine.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Dosis: ${widget.doseInfo.dose.doseNumber}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (widget.doseInfo.dose.description != null && widget.doseInfo.dose.description!.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    Text(
                      widget.doseInfo.dose.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Divider(height: 1, color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 20.h,
                  bottom: 10.h + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelForm(text: 'Fecha de aplicación *'),
                      FormFieldShadow(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Theme.of(context).colorScheme.secondary,
                          ),
                          child: FormBuilderDateTimePicker(
                            name: 'date_applied',
                            inputType: InputType.date,
                            lastDate: DateTime.now(),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            format: DateFormat('yyyy-MM-dd'),
                            style: Theme.of(context).textTheme.bodySmall,
                            cancelText: 'Cancelar',
                            confirmText: 'Aceptar',
                            decoration: FormInputDecoration(
                              context: context,
                              icon: Icon(
                                UiIcons.calendar,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ).copyWith(
                              errorMaxLines: 5,
                              errorStyle: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      LabelForm(text: 'Lugar de aplicación *'),
                      FormFieldShadow(
                        child: FormBuilderTextField(
                          name: 'applied_at',
                          style: Theme.of(context).textTheme.bodySmall,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.maxLength(255),
                          ]),
                          decoration: FormInputDecoration(
                            context: context,
                            icon: Icon(
                              UiIcons.map,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ).copyWith(
                            errorMaxLines: 5,
                            errorStyle: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      LabelForm(text: 'Notas (opcional)'),
                      FormFieldShadow(
                        child: FormBuilderTextField(
                          name: 'notes',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          validator: (value) {
                            if (value != null && value.isNotEmpty && value.length > 500) {
                              return 'Las notas no pueden exceder 500 caracteres';
                            }
                            return null;
                          },
                          decoration: FormInputDecoration(
                            context: context,
                            icon: Icon(
                              UiIcons.message,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ).copyWith(
                            errorMaxLines: 5,
                            errorStyle: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).primaryColor,
            shape: StadiumBorder(),
            elevation: 0,
          ),
          onPressed: _isLoading ? null : _handleRegister,
          child: _isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                )
              : Text(
                  'Registrar',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    final formState = _formKey.currentState;
    if (formState == null) return;
    
    if (!formState.saveAndValidate()) return;
    
    final values = formState.value;
    final dateApplied = values['date_applied'] as DateTime?;
    final appliedAt = values['applied_at'] as String?;
    final notes = values['notes'] as String?;

    if (dateApplied == null || appliedAt == null || appliedAt.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Formatear la fecha en formato yyyy-MM-dd
    final dateFormatted = DateFormat('yyyy-MM-dd').format(dateApplied);

    final success = await widget.onRegister(
      vaccineDoseId: widget.doseInfo.dose.id,
      dateApplied: dateFormatted,
      appliedAt: appliedAt,
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      // Cerrar el diálogo del formulario primero
      Navigator.of(context).pop();
      // Esperar un momento para que el diálogo se cierre completamente antes de mostrar el modal de éxito
      Future.delayed(Duration(milliseconds: 200), () {
        widget.onSuccess?.call();
      });
    }
  }
}

