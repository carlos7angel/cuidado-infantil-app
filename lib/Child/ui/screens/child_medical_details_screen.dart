import 'package:cuidado_infantil/Child/controllers/child_options_controller.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChildMedicalDetailsScreen extends StatelessWidget {
  static final String routeName = '/child_medical_details';
  
  const ChildMedicalDetailsScreen({super.key});

  String _formatYesNo(bool? value) {
    if (value == null) return 'No especificado';
    return value ? 'Sí' : 'No';
  }

  String _formatDeficit(String? value) {
    if (value == null || value.isEmpty) return 'No especificado';
    switch (value.toLowerCase()) {
      case 'alto':
        return 'Alto';
      case 'medio':
        return 'Medio';
      case 'bajo':
        return 'Bajo';
      default:
        return value;
    }
  }

  Widget _buildContent(BuildContext context, Child child) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              children: <Widget>[

                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  visualDensity: VisualDensity.compact,
                  leading: Icon(UiIcons.heart, color: Theme.of(context).colorScheme.secondary),
                  title: Text(
                    'Ficha médica',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),

                SizedBox(height: 15.h,),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '¿Tiene seguro?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatYesNo(child.hasInsurance),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.hasInsurance == true && child.insuranceDetails != null && child.insuranceDetails!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Detalles del seguro',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            child.insuranceDetails!,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Peso (kg)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.weight ?? 'No especificado',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Altura (cm)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.height ?? 'No especificado',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '¿Tiene alergias?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatYesNo(child.hasAllergies),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.hasAllergies == true && child.allergiesDetails != null && child.allergiesDetails!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Detalles de alergias',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            child.allergiesDetails!,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Presenta tratamiento médico',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatYesNo(child.hasMedicalTreatment),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.hasMedicalTreatment == true && child.medicalTreatmentDetails != null && child.medicalTreatmentDetails!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Especificar tratamiento médico',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            child.medicalTreatmentDetails!,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Presenta tratamiento psicológico',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatYesNo(child.hasPsychologicalTreatment),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.hasPsychologicalTreatment == true && child.psychologicalTreatmentDetails != null && child.psychologicalTreatmentDetails!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Especificar tratamiento psicológico',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            child.psychologicalTreatmentDetails!,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Presenta déficit de grado',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatYesNo(child.hasDeficit),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.hasDeficit == true) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Déficit auditivo',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _formatDeficit(child.auditoryDeficit),
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Déficit visual',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _formatDeficit(child.visualDeficit),
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Déficit táctil',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _formatDeficit(child.tactileDeficit),
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Déficit motor',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _formatDeficit(child.motorDeficit),
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Presenta enfermedad tipo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatYesNo(child.hasDisease),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.hasDisease == true && child.diseaseDetails != null && child.diseaseDetails!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Especificar características de la enfermedad',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            child.diseaseDetails!,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.otherConsiderations != null && child.otherConsiderations!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Otras consideraciones',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            child.otherConsiderations!,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 20.h,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChildOptionsController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (controller.child == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp),
                onPressed: () => Get.back(),
              ),
              title: Text('Ficha Médica'),
            ),
            body: Center(
              child: Text('No se encontraron datos del infante'),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                title: SliverAppBarTitle(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      'Ficha Médica',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp),
                  onPressed: () => Get.back(),
                ),
                actions: <Widget>[],
                backgroundColor: Theme.of(context).colorScheme.secondary,
                expandedHeight: 180.h,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).primaryColor.withOpacity(0.5),
                            ]
                          )
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: AppBar().preferredSize.height),
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0),
                                child: CardChild(child: controller.child)
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: -60.w,
                        bottom: 10.h,
                        child: Container(
                          width: 300.w,
                          height: 300.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(300.r),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30.w,
                        top: -80.h,
                        child: Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(150.r),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildContent(context, controller.child!),
              ),
            ],
          ),
        );
      },
    );
  }
}
