import 'package:cuidado_infantil/Child/ui/screens/child_list_screen.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:get/get.dart';

class ChildSuccessScreen extends StatelessWidget {
  static final String routeName = '/child_success';
  const ChildSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navegar a la lista de infantes y limpiar el stack
          Get.offAllNamed(ChildListScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
            onPressed: () {
              // Navegar a la lista de infantes y limpiar el stack
              Get.offAllNamed(ChildListScreen.routeName);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: GradientText(
            config.PRIMARY_GRADIENT,
            "Registro Nuevo",
            size: 24.sp,
            weight: FontWeight.w600,
          ),
          actions: <Widget>[

          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            children: [
              SizedBox(height: 50.h,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GradientText(
                      config.PRIMARY_GRADIENT,
                      "Infante registrado".toUpperCase(),
                      size: 30.sp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h,),

              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                // height: config.App(context).appHeight(60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                Colors.green,
                                Colors.green.withOpacity(0.2),
                              ])),
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                            size: 60.sp,
                          ),
                        ),
                        Positioned(
                          right: -30.w,
                          bottom: -50.h,
                          child: Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(150.r),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20.w,
                          top: -50.h,
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150.r),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      'La información del infante ha sido registrada satisfactoriamente',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                        'Ya puede acceder a la información del infante y realizar el seguimiento, evaluación y monitereo correspondiente.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400 ),
                    ),

                    SizedBox(height: 50.h),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.w),
                        backgroundColor: Theme.of(context).focusColor.withOpacity(0.15),
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        // Navegar a la lista de infantes y limpiar el stack
                        Get.offAllNamed(ChildListScreen.routeName);
                      },
                      child: Text(
                        'Lista de Infantes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
