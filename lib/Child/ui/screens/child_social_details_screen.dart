import 'package:cuidado_infantil/Child/controllers/child_options_controller.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChildSocialDetailsScreen extends StatelessWidget {
  static final String routeName = '/child_social_details';
  
  const ChildSocialDetailsScreen({super.key});

  String _formatGuardianType(String? value) {
    if (value == null || value.isEmpty) return 'No especificado';
    switch (value.toLowerCase()) {
      case 'madre':
        return 'Madre';
      case 'padre':
        return 'Padre';
      case 'ambos':
        return 'Ambos';
      case 'tutor':
        return 'Tutor';
      case 'hermano':
        return 'Hermano';
      case 'abuelos':
        return 'Abuelos';
      case 'tios':
        return 'Tíos';
      case 'otro':
      case 'otros':
        return 'Otro';
      default:
        return value;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No especificado';
    return DateFormat('dd/MM/yyyy').format(date);
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
                  leading: Icon(UiIcons.home, color: Theme.of(context).colorScheme.secondary),
                  title: Text(
                    'Ficha social',
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
                          'Infante a cargo de',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatGuardianType(child.guardianType),
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
                          'Tipo de vivienda',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.housingType ?? 'No especificado',
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
                          'Tenencia de vivienda',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.housingTenure ?? 'No especificado',
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
                          'Estructura de vivienda',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.housingStructure ?? 'No especificado',
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
                          'Tipo de piso',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.floorType ?? 'No especificado',
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
                          'Tipo de acabado',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.finishingType ?? 'No especificado',
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
                          'Número de dormitorios',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.bedrooms ?? 'No especificado',
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
                          'Medio de transporte',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.transportMode ?? 'No especificado',
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
                          'Tiempo de viaje',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.travelTime ?? 'No especificado',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),

          // Miembros de la familia
          if (child.familyMembers.isNotEmpty) ...[
            SizedBox(height: 20.h),
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
                    leading: Icon(UiIcons.users, color: Theme.of(context).colorScheme.secondary),
                    title: Text(
                      'Miembros de la familia',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  ...child.familyMembers.map((member) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Nombre',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${member.firstName} ${member.lastName}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (member.relationship.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Relación',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    member.relationship,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (member.gender.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Género',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    member.gender,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (member.birthDate != null)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Fecha de nacimiento',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _formatDate(member.birthDate),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (member.educationLevel.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Nivel educativo',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    member.educationLevel,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (member.profession != null && member.profession!.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Profesión',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    member.profession!,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (member.phone.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Teléfono',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    member.phone,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (member != child.familyMembers.last)
                          Divider(height: 20.h),
                      ],
                    );
                  }).toList(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
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
              title: Text('Ficha Social'),
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
                      'Ficha Social',
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
