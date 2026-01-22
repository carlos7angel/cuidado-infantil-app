import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_development_details_controller.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_list_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/development_scores_panel.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/evaluation_info_card.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/general_status_card.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/nutrition_child_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonitoringDevelopmentDetailsScreen extends StatefulWidget {
  static final String routeName = '/monitoring_development_details';
  const MonitoringDevelopmentDetailsScreen({super.key});

  @override
  State<MonitoringDevelopmentDetailsScreen> createState() => _MonitoringDevelopmentDetailsScreenState();
}

class _MonitoringDevelopmentDetailsScreenState extends State<MonitoringDevelopmentDetailsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Get.put(MonitoringDevelopmentDetailsController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonitoringDevelopmentDetailsController>(
      builder: (controller) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
              onPressed: () => Get.toNamed(MonitoringDevelopmentListScreen.routeName),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: GradientText(
              config.PRIMARY_GRADIENT,
              "Evaluación Desarrollo Infantil",
              size: 18.sp,
              weight: FontWeight.w600,
            ),
            actions: <Widget>[
              SizedBox.shrink()
            ],
          ),
          body: GetBuilder<MonitoringDevelopmentDetailsController>(
            id: 'development_details',
            builder: (controller) {
              if (controller.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      Container(
                          width: 100.r,
                          height: 100.r,
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.child != null 
                                ? controller.child!.getAvatarColor()
                                : Colors.grey.withOpacity(0.2),
                          ),
                          child: CachedImage(
                            image: controller.child != null 
                                ? controller.child!.getAvatarImage()
                                : 'assets/images/anonymous_user.png',
                            isRound: true,
                            radius: 80.r,
                            color: Colors.transparent,
                          )
                      ),

                      SizedBox(height: 15.h,),

                      // Card del Child
                      if (controller.child != null)
                        NutritionChildDetailsCard(child: controller.child!)
                      else
                        Container(
                          padding: EdgeInsets.all(20.w),
                          child: Center(child: Text('No hay información del infante disponible')),
                        ),

                      SizedBox(height: 20.h),

                      // Información de la evaluación
                      if (controller.evaluation != null)
                        EvaluationInfoCard(evaluation: controller.evaluation!),

                      SizedBox(height: 25.h),

                      Container(
                        child: Text(
                          'Resultados',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Estado General
                      if (controller.evaluation != null)
                        GeneralStatusCard(evaluation: controller.evaluation!),

                      SizedBox(height: 20.h),

                      // Scores por área con items históricos
                      if (controller.evaluation != null)
                        DevelopmentScoresPanel(controller: controller),

                      SizedBox(height: 25.h),

                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}
