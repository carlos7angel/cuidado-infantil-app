import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_development_details_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';
import 'package:cuidado_infantil/Monitoring/models/development_item.dart';
import 'package:cuidado_infantil/Monitoring/models/development_score.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_list_screen.dart';
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

class _MonitoringDevelopmentDetailsScreenState extends State<MonitoringDevelopmentDetailsScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // // Eliminar el controller anterior si existe para evitar reutilización de datos
    // if (Get.isRegistered<MonitoringDevelopmentDetailsController>()) {
    //   Get.delete<MonitoringDevelopmentDetailsController>();
    // }
    // // Crear una nueva instancia del controller
    Get.put(MonitoringDevelopmentDetailsController());
    
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    // // Eliminar el controller al salir de la pantalla para evitar reutilización
    // if (Get.isRegistered<MonitoringDevelopmentDetailsController>()) {
    //   Get.delete<MonitoringDevelopmentDetailsController>();
    // }
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
                        _buildEvaluationInfo(context, controller.evaluation!),

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
                        _buildGeneralStatus(context, controller.evaluation!),

                      SizedBox(height: 20.h),

                      // Scores por área con items históricos
                      if (controller.evaluation != null)
                        _buildScoresPanels(context, controller),

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

  Widget _buildEvaluationInfo(BuildContext context, ChildDevelopmentEvaluation evaluation) {
    return Container(
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
        padding: EdgeInsets.symmetric(vertical: 5.h),
        children: <Widget>[

          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            visualDensity: VisualDensity.compact,
            leading: Icon(UiIcons.cursor, color: Theme.of(context).colorScheme.secondary),
            title: Text(
              'Datos registrados en la evaluación',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),

          SizedBox(height: 0.h,),

          // Fecha de evaluación
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fecha evaluación',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    evaluation.evaluationDateReadable ?? evaluation.evaluationDate ?? 'N/A',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
                      SizedBox(height: 0.h,),
                      // Edad
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Edad',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                evaluation.formattedAge,
                                textAlign: TextAlign.end,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 0.h,),
                      // Overall Score
                      if (evaluation.overallScore != null)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Puntuación General',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildDonutChart(
                                      context,
                                      evaluation.overallScore!,
                                      evaluation.overallStatus ?? 'normal',
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${evaluation.overallScore!.toStringAsFixed(1)}%',
                                            textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          if (evaluation.overallStatus != null)
                                            Text(
                                              _getStatusLabel(evaluation.overallStatus!),
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: _getStatusColor(evaluation.overallStatus!),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
          SizedBox(height: 2.h,),
          // Notas
          if (evaluation.notes != null && evaluation.notes!.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        _showNotesDialog(context, evaluation.notes!);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(UiIcons.chat_1, size: 16.sp, color: Theme.of(context).colorScheme.secondary),
                          SizedBox(width: 5.w),
                          Text(
                            'Ver notas',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 7.5.h,)
        ],
      ),
    );
  }

  Widget _buildGeneralStatus(BuildContext context, ChildDevelopmentEvaluation evaluation) {
    final requiresAttention = evaluation.requiresAttention;
    final statusMessage = requiresAttention
        ? 'El infante requiere atención en su desarrollo'
        : 'El infante se encuentra dentro de los parámetros esperados';
    
    final statusColor = requiresAttention ? Colors.red : Colors.green;
    final statusLabel = requiresAttention ? 'Requiere Atención' : 'Normal';
    final statusIcon = requiresAttention ? Icons.warning_rounded : Icons.check_circle;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animación de ondas con icono a la izquierda
          Container(
            width: 90.w,
            height: 90.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        _buildContainer(80.w * _controller.value, statusColor),
                        _buildContainer(100.w * _controller.value, statusColor),
                        _buildContainer(120.w * _controller.value, statusColor),
                      ],
                    );
                  }
                ),
                Align(
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusIcon,
                      color: Colors.white.withOpacity(0.8),
                      size: 40.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          // Información del estado a la derecha
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado General',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  statusMessage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(double radius, Color color) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(1 - _controller.value),
      ),
    );
  }

  Widget _buildScoresPanels(BuildContext context, MonitoringDevelopmentDetailsController controller) {
    final evaluation = controller.evaluation!;
    
    // Definir los 4 grupos de scores
    final areas = ['MG', 'MF', 'AL', 'PS'];
    final areaLabels = {
      'MG': 'Motricidad Gruesa',
      'MF': 'Motricidad Fina',
      'AL': 'Área del Lenguaje',
      'PS': 'Personal Social',
    };
    
    final panels = areas.map((area) {
      final score = evaluation.getScore(area);
      return {
        'area': area,
        'title': areaLabels[area] ?? area,
        'score': score,
      };
    }).toList();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
        ],
      ),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.all(0),
        elevation: 0,
        expansionCallback: (int index, bool isOpen) {
          controller.togglePanel(index);
        },
        children: panels.asMap().entries.map((entry) {
          final index = entry.key;
          final panel = entry.value;
          final area = panel['area'] as String;
          final score = panel['score'] as DevelopmentScore?;
          
          final status = score?.status ?? 'normal';
          final iconData = _getStatusIcon(status);
          final iconColor = _getStatusColor(status);
          
          return ExpansionPanel(
            backgroundColor: Theme.of(context).primaryColor,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isOpen) {
              return Container(
                padding: EdgeInsets.only(left: 20.w, top: 15.h, bottom: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      iconData,
                      color: iconColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            panel['title'] as String,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyMedium?.merge(
                                TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          if (score != null)
                            Text(
                              'Score: ${score.rawScore ?? 'N/A'} - ${score.statusLabel ?? status}',
                              style: Theme.of(context).textTheme.bodySmall?.merge(
                                TextStyle(fontSize: 11.sp, color: iconColor),
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            isExpanded: controller.expandedPanels[index],
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r)
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: Colors.grey,
                  strokeWidth: 0.0,
                  radius: 10.r,
                ),
                child: Container(
                  // padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 15.w, right: 15.w),
                  padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                  child: score != null
                      ? Column(
                          children: [
                            // Información del score
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                                  margin: EdgeInsets.only(top: 0.h, bottom: 0.h),
                                  child: Text(
                                    'Score',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineMedium?.merge(TextStyle(fontSize: 14.sp)),
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  '${score.rawScore ?? 'N/A'}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineMedium?.merge(
                                    TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Icon(iconData, color: iconColor, size: 36.sp,),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //   padding: EdgeInsets.symmetric(horizontal: 0.w),
                                //   margin: EdgeInsets.only(top: 0.h, bottom: 0.h),
                                //   child: Text(
                                //     'Estado',
                                //     textAlign: TextAlign.center,
                                //     style: Theme.of(context).textTheme.headlineMedium?.merge(TextStyle(fontSize: 14.sp)),
                                //   ),
                                // ),
                                // SizedBox(width: 10.w,),
                                Text(
                                  score.statusLabel ?? status,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineMedium?.merge(
                                    TextStyle(fontSize: 16.sp, color: iconColor, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            if (score.statusDescription != null && score.statusDescription!.isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 35.w),
                                child: Text(
                                  score.statusDescription!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                            
                            // Items históricos
                            if (evaluation.itemsByArea != null && evaluation.itemsByArea!.containsKey(area)) ...[
                              SizedBox(height: 20.h),
                              Divider(),
                              SizedBox(height: 10.h),
                              Text(
                                'Items Evaluados',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              _buildItemsList(context, evaluation.itemsByArea![area]!),
                            ],
                          ]
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: Text('No hay información de score disponible'),
                          ),
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'medio_alto':
        return Icons.check_circle;
      case 'alerta':
      case 'alert':
        return Icons.warning_rounded;
      case 'medio':
        return Icons.info_outline;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'medio_alto':
        return Colors.green;
      case 'alerta':
      case 'alert':
        return Colors.red;
      case 'medio':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// Custom Painter para dibujar bordes punteados
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    final dashPath = _dashPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _dashPath(Path path, double dashWidth, double dashSpace) {
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

  Widget _buildItemsList(BuildContext context, DevelopmentItemsByArea areaData) {
    if (areaData.items.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            'No hay items registrados',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${areaData.total}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Logrados',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${areaData.achievedCount}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'No Logrados',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${areaData.notAchievedCount}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        // Tabla de items
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                  width: 1,
                ),
                verticalInside: BorderSide(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              columnWidths: {
                0: FixedColumnWidth(30.w), // Número
                1: FixedColumnWidth(80.w), // Edad
                2: FixedColumnWidth(180.w), // Descripción
                3: FixedColumnWidth(50.w), // Icono
              },
              children: [
                // Encabezado de la tabla
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  ),
                  children: [
                    _buildTableCell(context, '#', isHeader: true),
                    _buildTableCell(context, 'Edad', isHeader: true),
                    _buildTableCell(context, 'Descripción', isHeader: true),
                    _buildTableCell(context, 'Est.', isHeader: true),
                  ],
                ),
                // Filas de datos
                ...areaData.items.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(
                      color: item.achieved 
                          ? Colors.green.withOpacity(0.05) 
                          : Colors.red.withOpacity(0.05),
                    ),
                    children: [
                      _buildTableCell(
                        context,
                        item.itemNumber.toString(),
                        isHeader: false,
                      ),
                      _buildTableCell(
                        context,
                        item.ageRange != null ? item.ageRange!.formattedRange : 'N/A',
                        isHeader: false,
                      ),
                      _buildTableCell(
                        context,
                        item.description.isNotEmpty ? item.description : 'Sin descripción',
                        isHeader: false,
                        maxLines: 2,
                      ),
                      _buildTableCell(
                        context,
                        '',
                        isHeader: false,
                        icon: item.achieved ? Icons.check_circle : Icons.cancel,
                        iconColor: item.achieved ? Colors.green : Colors.red,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(
    BuildContext context,
    String text, {
    bool isHeader = false,
    IconData? icon,
    Color? iconColor,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: icon != null
          ? Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 24.sp,
              ),
            )
          : Text(
              text,
              style: isHeader
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    )
                  : Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                    ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  void _showNotesDialog(BuildContext context, String notes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Notas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonutChart(BuildContext context, double percentage, String status) {
    final color = _getStatusColor(status);
    final size = 60.w;
    final strokeWidth = 6.0;
    
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
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
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

