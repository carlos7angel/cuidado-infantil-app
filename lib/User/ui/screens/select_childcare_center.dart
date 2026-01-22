import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/User/controllers/select_childcare_center_controller.dart';
import 'package:cuidado_infantil/User/models/childcare_center_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectChildcareCenterScreen extends StatelessWidget {
  static final String routeName = '/select-childcare';
  
  const SelectChildcareCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectChildcareCenterController>(
      init: SelectChildcareCenterController(),
      builder: (controller) {
        return PopScope(
          canPop: true,
          child: Scaffold(
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
                "Centros de Cuidado",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: _buildBody(context, controller),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SelectChildcareCenterController controller) {
    if (controller.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              controller.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => controller.reloadData(),
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (controller.childcareCenters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(UiIcons.layers, size: 48.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No tienes centros de cuidado asignados',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.reloadData(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  UiIcons.layers,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Selecciona el Centro disponible',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // subtitle: Text(
                //   'Selecciona el centro que deseas administrar',
                //   style: Theme.of(context).textTheme.bodySmall,
                // ),
              ),
            ),
            SizedBox(height: 15.h),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.childcareCenters.length,
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final center = controller.childcareCenters[index];
                final isSelected = controller.isSelected(center);
                return _buildChildcareCenterItem(context, controller, center, isSelected);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildcareCenterItem(
    BuildContext context,
    SelectChildcareCenterController controller,
    ChildcareCenter center,
    bool isSelected,
  ) {
    return InkWell(
      onTap: isSelected ? null : () => controller.selectChildcareCenter(center),
      child: Container(
        color: isSelected 
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
            : Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            // Icono del centro
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0),
                border: isSelected
                    ? Border.all(width: 2.w, color: Theme.of(context).colorScheme.secondary)
                    : null,
              ),
              child: Icon(
                UiIcons.home,
                color: Theme.of(context).colorScheme.secondary,
                size: 24.sp,
              ),
              // child: CachedImage(
              //   image: 'assets/images/build.png',
              //   isRound: true,
              //   radius: 60.r,
              //   color: Theme.of(context).primaryColor,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(width: 15.w),
            // Información del centro
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.name ?? 'Sin nombre',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (center.municipality != null || center.state != null)
                    Text(
                      [center.municipality, center.state]
                          .where((e) => e != null)
                          .join(', '),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: config.AppColors.gray99Color(1),
                      ),
                    ),
                  if (center.address != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      center.address!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: config.AppColors.gray99Color(0.8),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 10.w),
            // Indicador de selección
            if (isSelected)
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.secondary,
              //     borderRadius: BorderRadius.circular(12.r),
              //   ),
              //   child: Text(
              //     'Actual',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 11.sp,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // )
              Icon(UiIcons.checked, color: Theme.of(context).colorScheme.secondary,)
            else
              Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).hintColor,
              ),
          ],
        ),
      ),
    );
  }
}

