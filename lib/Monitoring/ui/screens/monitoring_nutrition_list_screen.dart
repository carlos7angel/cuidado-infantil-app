import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/empty_list.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_nutrition_list_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/nutritional_assessment.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_details_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_form_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MonitoringNutritionListScreen extends StatefulWidget {
  static final String routeName = '/monitoring_nutrition_list';
  const MonitoringNutritionListScreen({super.key});

  @override
  State<MonitoringNutritionListScreen> createState() => _MonitoringNutritionListScreenState();
}

class _MonitoringNutritionListScreenState extends State<MonitoringNutritionListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offNamed(MonitoringChildOptionsScreen.routeName);
        }
      },
      child: GetBuilder<MonitoringNutritionListController>(
        init: MonitoringNutritionListController(),
        builder: (controller) {
          return Scaffold(
            key: _scaffoldKey,
            body: RefreshIndicator(
            onRefresh: () async {
              final controller = Get.find<MonitoringNutritionListController>();
              await controller.refreshEvaluations();
            },
            child: GetBuilder<MonitoringNutritionListController>(
              id: 'nutrition_list',
              builder: (controller) {
                return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    title: SliverAppBarTitle(
                      child: Container(
                        padding: EdgeInsets.only(left: 5.w),
                        child: GradientText(
                          config.GRAY_LIGHT_GRADIENT_BUBBLE,
                          'Seguimiento Nutricional',
                          size: 18.sp,
                          weight: FontWeight.w600,
                          align: TextAlign.left,
                        ),
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp,),
                      onPressed: () => Get.offNamed(MonitoringChildOptionsScreen.routeName),
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
                                gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                  Theme.of(context).colorScheme.secondary,
                                  Theme.of(context).primaryColor.withOpacity(0.5),
                                ])),
                            child: Container(
                              margin: EdgeInsets.only(top: AppBar().preferredSize.height),
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20.h,),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                                      child: CardChild()
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

                  // Título fijo usando SliverPersistentHeader
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTitleDelegate(
                      context: context,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                        child: Row(
                          children: [
                            Icon(
                              UiIcons.inbox,
                              color: Theme.of(context).hintColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Lista de Evaluaciones',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Padding para toda la lista
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            if (controller.loading)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 50.h),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (controller.evaluations.isEmpty)
                              EmptyList(
                                message: 'No hay evaluaciones nutricionales registradas',
                                icon: UiIcons.folder_1,
                              )
                            else
                              ...controller.evaluations.asMap().entries.map((entry) {
                                final index = entry.key;
                                final assessment = entry.value;
                                // Numeración descendente: el primer item (más reciente) tiene el número más alto
                                final totalEvaluations = controller.evaluations.length;
                                final numeroDescendente = totalEvaluations - index;
                                return _buildAssessmentCard(context, assessment, numeroDescendente);
                              }),
                          ]
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Get.toNamed(MonitoringNutritionFormScreen.routeName);
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: StadiumBorder(side: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary.withOpacity(0))),
            child: Icon(Icons.add_outlined, color: Colors.white),
          ),
        );
        },
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, NutritionalAssessment assessment, int numeroSeguimiento) {
    // Parsear la fecha de evaluación
    DateTime? evaluationDate;
    if (assessment.assessmentDate != null) {
      try {
        evaluationDate = DateTime.parse(assessment.assessmentDate!);
      } catch (e) {
        // Si falla el parseo, usar la fecha actual
        evaluationDate = DateTime.now();
      }
    } else {
      evaluationDate = DateTime.now();
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black45.withOpacity(0.15),
              offset: Offset(2.0, 4.0),
              blurRadius: 8,
            )
          ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              left: -65.w,
              top: -55.h,
              child: Container(
                width: 130.w,
                height: 130.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [config.AppColors.mainColor(0.95), config.AppColors.mainColor(0.15)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(
                        MonitoringNutritionDetailsScreen.routeName,
                        arguments: {'assessment': assessment},
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                      decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Widget de calendario estilo hoja de cuaderno
                          _buildCalendarWidget(context, evaluationDate),
                          SizedBox(width: 15.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                // Título con numeración descendente
                                Text(
                                  'Seguimiento #$numeroSeguimiento',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 18.sp
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text('Fecha registro: ',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),),
                                              Text(
                                                assessment.formattedAssessmentDate ?? assessment.assessmentDate ?? 'N/A',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3.h,),
                                          Row(
                                            children: [
                                              Text('Peso: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                              Flexible(
                                                child: Text(
                                                  assessment.weight != null ? '${assessment.weight} Kg' : 'N/A',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 15.w,),
                                              Text('Longitud/Talla: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                              Flexible(
                                                child: Text(
                                                  assessment.heightAsInteger != null ? '${assessment.heightAsInteger} cm' : 'N/A',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ]
                                          ),
                                          SizedBox(height: 3.h,),
                                          Row(
                                              children: [
                                                Text('Edad: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                                Text(
                                                  assessment.formattedAge,
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                                ),
                                              ]
                                          ),
                                          SizedBox(height: 3.h,),
                                          Row(
                                              children: [
                                                Text('Estado general: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                                Flexible(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(width: 5.w),
                                                      Container(
                                                        width: 10.w,
                                                        height: 10.w,
                                                        decoration: BoxDecoration(
                                                          color: assessment.requiresAttention ? Colors.red : Colors.green,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Flexible(
                                                        child: Text(
                                                          assessment.criticalStatusLabel ?? assessment.criticalStatus ?? 'Normal',
                                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarWidget(BuildContext context, DateTime date) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    final month = months[date.month - 1];
    final day = date.day;

    return Container(
      width: 70.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, 2), blurRadius: 4)
        ],
      ),
      child: Stack(
        children: [
          // Espiral del cuaderno (lado izquierdo)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Column(
                children: List.generate(10, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Contenido del calendario
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 6.h, bottom: 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de calendario arriba
                Icon(
                  Icons.calendar_today,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(height: 3.h),
                // Mes en tres letras
                Text(
                  month,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                // Día numeral
                Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Delegate para el título fijo en el SliverPersistentHeader
class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final BuildContext context;
  final double height;

  _SliverTitleDelegate({required this.child, required this.context})
      : height = 60.h; // Aumentado para asegurar espacio suficiente

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTitleDelegate oldDelegate) {
    return true; // Siempre reconstruir para asegurar que el child y las dimensiones se actualicen
  }
}

