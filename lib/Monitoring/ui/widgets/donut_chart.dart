import 'package:cuidado_infantil/Monitoring/ui/monitoring_ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonutChart extends StatelessWidget {
  final double percentage;
  final String status;
  final double size;
  final double strokeWidth;

  const DonutChart({
    super.key,
    required this.percentage,
    required this.status,
    this.size = 60.0,
    this.strokeWidth = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = MonitoringUiHelpers.getStatusColor(status);
    final finalSize = size.w;

    return Container(
      width: finalSize,
      height: finalSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fondo
          SizedBox(
            width: finalSize,
            height: finalSize,
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
            width: finalSize,
            height: finalSize,
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
}
