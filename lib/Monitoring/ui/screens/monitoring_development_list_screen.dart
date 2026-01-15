import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/empty_list.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_development_list_controller.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_options_screen.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_details_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MonitoringDevelopmentListScreen extends StatefulWidget {
  static final String routeName = '/monitoring_development_list';
  const MonitoringDevelopmentListScreen({super.key});

  @override
  State<MonitoringDevelopmentListScreen> createState() => _MonitoringDevelopmentListScreenState();
}

class _MonitoringDevelopmentListScreenState extends State<MonitoringDevelopmentListScreen> {
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
      child: GetBuilder<MonitoringDevelopmentListController>(
        init: MonitoringDevelopmentListController(),
        builder: (controller) {
          return Scaffold(
            key: _scaffoldKey,
            body: RefreshIndicator(
              onRefresh: () async {
                final controller = Get.find<MonitoringDevelopmentListController>();
                await controller.refreshEvaluations();
              },
              child: GetBuilder<MonitoringDevelopmentListController>(
                id: 'development_list',
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
                            'Evaluaciones de Desarrollo',
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
                                Container(
                                  child: Center(
                                    child: EmptyList(
                                      message: 'No hay evaluaciones de desarrollo registradas',
                                      icon: UiIcons.folder_1,
                                    )
                                  ),
                                )
                              else
                                ...controller.evaluations.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final evaluation = entry.value;
                                  // Numeración descendente: el primer item (más reciente) tiene el número más alto
                                  final totalEvaluations = controller.evaluations.length;
                                  final numeroDescendente = totalEvaluations - index;
                                  return _buildEvaluationCard(context, evaluation, numeroDescendente);
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
                Get.toNamed(MonitoringDevelopmentFormScreen.routeName);
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: StadiumBorder(side: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary.withOpacity(0))),
              child: Icon(Icons.add_outlined, color: Colors.white),
            ),
          );
        },
      )
    );
  }

  Widget _buildEvaluationCard(BuildContext context, ChildDevelopmentEvaluation evaluation, int index) {
    // Obtener los scores
    final mgScore = evaluation.getRawScore('MG');
    final mfScore = evaluation.getRawScore('MF');
    final alScore = evaluation.getRawScore('AL');
    final psScore = evaluation.getRawScore('PS');
    
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
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Get.toNamed(
                  MonitoringDevelopmentDetailsScreen.routeName,
                  arguments: {'evaluation': evaluation},
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Donut chart con overall_score
                    _buildDonutChart(
                      context,
                      evaluation.overallScore ?? 0.0,
                      evaluation.overallStatus ?? 'normal',
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Evaluación #$index',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontSize: 18.sp
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Text('Fecha evaluación: ',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),),
                                        Text(
                                          evaluation.evaluationDateReadable ?? evaluation.evaluationDate ?? 'N/A',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Text('Edad: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                        Text(
                                          evaluation.formattedAge,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                        ),
                                      ]
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Text('Puntajes: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                        if (mgScore != null)
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.w),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('MG: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                                                Text('$mgScore', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                        if (mfScore != null)
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.w),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('MF: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                                                Text('$mfScore', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                        if (alScore != null)
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.w),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('AL: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                                                Text('$alScore', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                        if (psScore != null)
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.w),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('PS: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                                                Text('$psScore', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                      ]
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Estado general: ',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SizedBox(width: 5.w),
                                              Container(
                                                width: 10.w,
                                                height: 10.w,
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(evaluation.overallStatus ?? 'normal'),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Flexible(
                                                child: Text(
                                                  _getStatusLabel(evaluation.overallStatus ?? 'normal'),
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
    );
  }

  Widget _buildDonutChart(BuildContext context, double percentage, String status) {
    final color = _getStatusColor(status);
    final size = 70.w;
    final strokeWidth = 8.0;
    
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fondo
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).hintColor.withOpacity(0.2),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Círculo de progreso
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Porcentaje en el centro
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              // Text(
              //   _getStatusLabel(status),
              //   style: TextStyle(
              //     fontSize: 9.sp,
              //     fontWeight: FontWeight.w500,
              //     color: Theme.of(context).hintColor,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alerta':
      case 'alert':
        return Colors.red;
      case 'medio_bajo':
      case 'medio_alto':
      case 'medio':
        return Colors.orange;
      case 'normal':
      case 'alto':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'alerta':
      case 'alert':
        return 'Alerta';
      case 'medio_bajo':
        return 'Medio Bajo';
      case 'medio_alto':
        return 'Medio Alto';
      case 'medio':
        return 'Medio';
      case 'normal':
        return 'Normal';
      case 'alto':
        return 'Alto';
      default:
        return status;
    }
  }
}

// Delegate para el título fijo en el SliverPersistentHeader
class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTitleDelegate({required this.child});

  @override
  double get minExtent {
    // Calcular el tamaño real: padding vertical (15.h * 2 = 30.h) + altura del contenido (~24.h para icono/texto)
    // Total aproximado: 54.h
    return 54.h;
  }

  @override
  double get maxExtent {
    // Mismo tamaño que minExtent para que no se encoja (pinned header)
    return 54.h;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: maxExtent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: overlapsContent
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTitleDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

