import 'package:cuidado_infantil/Child/controllers/child_options_controller.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChildEnrollmentDetailsScreen extends StatelessWidget {
  static final String routeName = '/child_enrollment_details';
  
  const ChildEnrollmentDetailsScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'No especificado';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getFileName(dynamic file) {
    if (file == null) return 'No especificado';
    if (file is Map) {
      return file['original_name'] ?? file['name'] ?? 'Archivo';
    }
    return file.toString();
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
                  leading: Icon(UiIcons.edit, color: Theme.of(context).colorScheme.secondary),
                  title: Text(
                    'Ficha de Inscripción',
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
                          'Fecha de inscripción',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatDate(child.enrollmentDate),
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
                          'Grupo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          child.roomId ?? 'No especificado',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                if (child.fileAdmissionRequest != null && child.fileAdmissionRequest!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Carta de solicitud de admisión',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileAdmissionRequest!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.fileCommitment != null && child.fileCommitment!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Compromiso',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileCommitment!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.fileBirthCertificate != null && child.fileBirthCertificate!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Certificado de nacimiento',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileBirthCertificate!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.fileVaccinationCard != null && child.fileVaccinationCard!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Carnet de vacunas',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileVaccinationCard!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.fileParentId != null && child.fileParentId!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Documento de identidad del padre/madre',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileParentId!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.fileUtilityBill != null && child.fileUtilityBill!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Recibo de agua y luz',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileUtilityBill!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.fileHomeSketch != null && child.fileHomeSketch!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Croquis del domicilio actual',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.fileHomeSketch!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (child.filePickupAuthorization != null && child.filePickupAuthorization!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Autorización de recojo',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _getFileName(child.filePickupAuthorization!.first),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Theme.of(context).focusColor, fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 20.h),
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
              title: Text('Ficha de Inscripción'),
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
                      'Ficha de Inscripción',
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
