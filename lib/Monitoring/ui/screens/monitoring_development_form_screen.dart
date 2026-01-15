import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_development_form_controller.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/nutrition_child_details_card.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonitoringDevelopmentFormScreen extends StatefulWidget {
  static final String routeName = '/monitoring_development_form';
  const MonitoringDevelopmentFormScreen({super.key});

  @override
  State<MonitoringDevelopmentFormScreen> createState() => _MonitoringDevelopmentFormScreenState();
}

class _MonitoringDevelopmentFormScreenState extends State<MonitoringDevelopmentFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonitoringDevelopmentFormController>(
      init: MonitoringDevelopmentFormController(),
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
                "Nueva Evaluación",
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
                "Nueva Evaluación",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: GetBuilder<MonitoringDevelopmentFormController>(
              id: 'development_form',
              builder: (controller) {
                if (controller.loadingItems) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return FormBuilder(
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
                                'Datos de la evaluación',
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

                            // Notas (opcional)
                            LabelForm(text: 'Notas (opcional):'),
                            FormFieldShadow(
                              child: FormBuilderTextField(
                                name: 'notes',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 3,
                                decoration: FormInputDecoration(
                                  context: context,
                                  placeholder: 'Ingrese observaciones adicionales...',
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // Items de desarrollo agrupados por área
                            if (controller.developmentItems != null)
                              _buildDevelopmentItems(context, controller)
                            else
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: Text(
                                    'No hay items de desarrollo disponibles',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                              ),

                            SizedBox(height: 50.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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

  Widget _buildDevelopmentItems(BuildContext context, MonitoringDevelopmentFormController controller) {
    final itemsResponse = controller.developmentItems!;
    final areas = ['MG', 'MF', 'AL', 'PS'];
    final areaLabels = {
      'MG': 'Motricidad Gruesa',
      'MF': 'Motricidad Fina',
      'AL': 'Área del Lenguaje',
      'PS': 'Personal Social',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            'Items de Desarrollo',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          margin: EdgeInsets.only(bottom: 15.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.secondary,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Marque los indicadores de desarrollo que el infante ha alcanzado según su área correspondiente. Puede expandir cada área para ver los items disponibles.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        ...areas.map((area) {
          final areaData = itemsResponse.itemsByArea[area];
          if (areaData == null || areaData.items.isEmpty) {
            return SizedBox.shrink();
          }

          final selectedCount = controller.getSelectedCountByArea(area);
          final totalCount = controller.getTotalCountByArea(area);

          return Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45.withOpacity(0.1),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                )
              ],
            ),
            child: ExpansionTile(
              title: Text(
                areaLabels[area] ?? area,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '$selectedCount de $totalCount items seleccionados',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              leading: Icon(
                Icons.check_circle_outline,
                color: selectedCount > 0 
                    ? Colors.green 
                    : Theme.of(context).hintColor,
              ),
              children: areaData.items.map((item) {
                final isSelected = controller.isItemSelected(item.developmentItemId);
                return CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  checkColor: Colors.white,
                  title: Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: item.ageRange != null
                      ? Text(
                          'Edad: ${item.ageRange!.formattedRange}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        )
                      : null,
                  value: isSelected,
                  onChanged: (value) {
                    controller.toggleItem(item.developmentItemId);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}

