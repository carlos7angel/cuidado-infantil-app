import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_nutrition_form_controller.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/nutrition_child_card.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/nutrition_child_details_card.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonitoringNutritionFormScreen extends StatefulWidget {
  static final String routeName = '/monitoring_nutrition_form';
  const MonitoringNutritionFormScreen({super.key});

  @override
  State<MonitoringNutritionFormScreen> createState() => _MonitoringNutritionFormScreenState();
}

class _MonitoringNutritionFormScreenState extends State<MonitoringNutritionFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonitoringNutritionFormController>(
      init: MonitoringNutritionFormController(),
      builder: (controller) {
        final selectedChild = controller.selectedChild;
        
        if (selectedChild == null) {
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
                "Nuevo Seguimiento",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: Center(
              child: Text('No hay un infante seleccionado'),
            ),
          );
        }

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
                "Nuevo Seguimiento",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: FormBuilder(
              key: controller.fbKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.h),
                    // Card del Child
                    NutritionChildDetailsCard(child: selectedChild),
                    SizedBox(height: 20.h),
                    // Sección de datos del seguimiento
                    Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          visualDensity: VisualDensity.compact,
                          leading: Icon(
                            UiIcons.inbox,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 24,
                          ),
                          title: Text(
                            'Datos del seguimiento de nutrición',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Fecha de registro (solo lectura) - fecha actual
                        LabelForm(text: 'Fecha de Registro:'),
                        FormFieldShadow(
                          child: FormBuilderTextField(
                            name: 'registration_date',
                            style: Theme.of(context).textTheme.bodySmall,
                            enabled: false,
                            readOnly: true,
                            initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            decoration: FormInputDecoration(
                              context: context,
                              icon: Icon(
                                UiIcons.calendar,
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Edad en meses (solo lectura)
                        LabelForm(text: 'Edad a la fecha:'),
                        FormFieldShadow(
                          child: FormBuilderTextField(
                            name: 'age_months',
                            style: Theme.of(context).textTheme.bodySmall,
                            enabled: false,
                            readOnly: true,
                            initialValue: controller.getFormattedAgeInMonths(),
                            decoration: FormInputDecoration(
                              context: context,
                              icon: Icon(
                                UiIcons.calendar,
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Peso y Talla (editables)
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
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(errorText: 'Campo requerido'),
                                        FormBuilderValidators.numeric(errorText: 'Debe ser un número'),
                                      ]),
                                      decoration: FormInputDecoration(context: context),
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
                                  LabelForm(text: 'Talla (cm): *'),
                                  FormFieldShadow(
                                    child: FormBuilderTextField(
                                      name: 'height',
                                      style: Theme.of(context).textTheme.bodySmall,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(errorText: 'Campo requerido'),
                                        FormBuilderValidators.numeric(errorText: 'Debe ser un número'),
                                      ]),
                                      decoration: FormInputDecoration(context: context),
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
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => controller.saveEvaluation(),
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
        );
      },
    );
  }
}
