import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_development_details_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/development_item.dart';
import 'package:cuidado_infantil/Monitoring/models/development_score.dart';
import 'package:cuidado_infantil/Monitoring/ui/monitoring_ui_helpers.dart';

class DevelopmentScoresPanel extends StatelessWidget {
  final MonitoringDevelopmentDetailsController controller;

  const DevelopmentScoresPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
          final iconData = MonitoringUiHelpers.getStatusIcon(status);
          final iconColor = MonitoringUiHelpers.getStatusColor(status);
          
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
