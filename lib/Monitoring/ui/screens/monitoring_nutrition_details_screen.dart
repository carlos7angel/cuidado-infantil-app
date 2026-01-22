import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_nutrition_details_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/nutritional_assessment.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/dashed_border_painter.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/nutrition_child_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonitoringNutritionDetailsScreen extends StatefulWidget {
  static final String routeName = '/monitoring_nutrition_details';
  const MonitoringNutritionDetailsScreen({super.key});

  @override
  State<MonitoringNutritionDetailsScreen> createState() => _MonitoringNutritionDetailsScreenState();
}

class _MonitoringNutritionDetailsScreenState extends State<MonitoringNutritionDetailsScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Get.put(MonitoringNutritionDetailsController());
    
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonitoringNutritionDetailsController>(
      init: MonitoringNutritionDetailsController(),
      builder: (controller) {
        return Scaffold(
          key: _scaffoldKey,
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              "Evaluación Nutricional",
              size: 20.sp,
              weight: FontWeight.w600,
            ),
            actions: <Widget>[

            ],
          ),
          body: SingleChildScrollView(
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
                  if (controller.child != null) ... [

                    NutritionChildDetailsCard(child: controller.child!)
                  ]
                  else ... [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      child: Center(child: Text('No hay información del infante disponible')),
                    ),
                  ],

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

                        if (controller.assessment != null) ...[
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
                                    controller.assessment!.formattedAge,
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
                          // Peso
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Peso',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    controller.assessment!.weight != null ? '${controller.assessment!.weight} Kg' : 'N/A',
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
                          // Talla/Longitud
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Talla/Longitud',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    controller.assessment!.heightAsInteger != null ? '${controller.assessment!.heightAsInteger} cm' : 'N/A',
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
                          // BMI
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'IMC',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    controller.assessment!.bmi != null ? controller.assessment!.bmi!.toStringAsFixed(2) : 'N/A',
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

                          if (controller.assessment!.actionsTaken != null && controller.assessment!.actionsTaken!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Acciones tomadas',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    controller.assessment!.actionsTaken!,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                        ] else ...[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(child: Text('No hay datos de evaluación disponibles')),
                          ),
                        ],
                        SizedBox(height: 5.h,)
                      ],
                    ),
                  ),

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
                  if (controller.assessment != null)
                    _buildGeneralStatus(context, controller.assessment!),

                  SizedBox(height: 20.h),

                  // SizedBox(height: 15),

                  // Z-Scores ExpansionPanelList
                  if (controller.assessment != null)
                    _buildZScorePanels(context, controller),

                  SizedBox(height: 25.h),

                ],
              ),
            ),
          ),
        );
      }
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


  Widget _buildGeneralStatus(BuildContext context, NutritionalAssessment assessment) {
    final requiresAttention = assessment.requiresAttention;
    final statusLabel = assessment.criticalStatusLabel ?? assessment.criticalStatus ?? 'Normal';
    final statusMessage = requiresAttention
        ? 'El infante requiere atención nutricional'
        : 'El infante se encuentra dentro de los parámetros promedio aceptables';
    
    final statusColor = requiresAttention ? Colors.red : Colors.green;
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
          // Animación de ondas y icono a la izquierda
          SizedBox(
            width: 90.w,
            height: 90.w,
            child: AnimatedBuilder(
              animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _buildContainer(80.w * _controller.value, statusColor),
                    _buildContainer(100.w * _controller.value, statusColor),
                    _buildContainer(120.w * _controller.value, statusColor),
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
                );
              }
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildZScorePanels(BuildContext context, MonitoringNutritionDetailsController controller) {
    final assessment = controller.assessment!;
    
    // Definir los 4 grupos de z-scores
    final panels = [
      {
        'title': 'Peso para la edad', // 'Weight For Age',
        'zScore': assessment.zWeightAge ?? 'N/A',
        'status': assessment.statusWeightAge ?? 'normal',
        'statusLabel': assessment.statusWeightAgeLabel ?? 'Normal',
        'interpretation': assessment.statusWeightAgeInterpretation ?? 'Sin interpretación',
      },
      {
        'title': 'Longitud/Talla para la edad', // 'Length/Height For Age',
        'zScore': assessment.zHeightAge ?? 'N/A',
        'status': assessment.statusHeightAge ?? 'normal',
        'statusLabel': assessment.statusHeightAgeLabel ?? 'Normal',
        'interpretation': assessment.statusHeightAgeInterpretation ?? 'Sin interpretación',
      },
      {
        'title': 'Peso para la longitud/talla', // 'Weight for Length/Height',
        'zScore': assessment.zWeightHeight ?? 'N/A',
        'status': assessment.statusWeightHeight ?? 'normal',
        'statusLabel': assessment.statusWeightHeightLabel ?? 'Normal',
        'interpretation': assessment.statusWeightHeightInterpretation ?? 'Sin interpretación',
      },
      {
        'title': 'IMC para la edad', // 'BMI for Age',
        'zScore': assessment.zBmiAge ?? 'N/A',
        'status': assessment.statusBmiAge ?? 'normal',
        'statusLabel': assessment.statusBmiAgeLabel ?? 'Normal',
        'interpretation': assessment.statusBmiAgeInterpretation ?? 'Sin interpretación',
      },
    ];
    
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
          final status = panel['status'] as String;
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
                          Text(
                            panel['statusLabel'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.merge(
                              TextStyle(fontSize: 12.sp, color: iconColor),
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
                  strokeWidth: 1.0,
                  radius: 10.r,
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 15.h, bottom: 15.h, left: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        margin: EdgeInsets.only(top: 0.h, bottom: 0.h),
                        child: Text(
                          'Z-score',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.merge(TextStyle(fontSize: 14.sp)),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Text(
                        panel['zScore'] as String,
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
                        panel['statusLabel'] as String,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.merge(
                          TextStyle(fontSize: 16.sp, color: iconColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    child: Text(
                      panel['interpretation'] as String,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ]
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
      // Normal - verde
      case 'normal':
        return Icons.check_circle;
      
      // Valores altos/sobrepeso/obesidad - warning
      case 'muy_alto':
      case 'alto':
      case 'obesidad':
      case 'sobrepeso':
        return Icons.warning_rounded;
      
      // Riesgo de sobrepeso - info/warning
      case 'riesgo_sobrepeso':
        return Icons.info_outline;
      
      // Valores bajos/desnutrición - warning/error
      case 'bajo_peso':
      case 'bajo_peso_severo':
        return Icons.warning_rounded;
      
      // Riesgo de desnutrición - info
      case 'riesgo_desnutricion':
        return Icons.info_outline;
      
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      // Normal - verde
      case 'normal':
        return Colors.green;
      
      // Valores muy altos/obesidad/bajo peso severo - rojo (crítico)
      case 'muy_alto':
      case 'obesidad':
      case 'bajo_peso_severo':
        return Colors.red;
      
      // Valores altos/sobrepeso/bajo peso - naranja (atención)
      case 'alto':
      case 'sobrepeso':
      case 'bajo_peso':
        return Colors.orange;
      
      // Riesgos - amarillo (precaución)
      case 'riesgo_sobrepeso':
      case 'riesgo_desnutricion':
        return Colors.amber;
      
      default:
        return Colors.grey;
    }
  }

}

// Moved to lib/Monitoring/ui/widgets/dashed_border_painter.dart
