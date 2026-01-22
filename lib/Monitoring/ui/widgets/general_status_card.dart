import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';

class GeneralStatusCard extends StatefulWidget {
  final ChildDevelopmentEvaluation evaluation;

  const GeneralStatusCard({
    super.key,
    required this.evaluation,
  });

  @override
  State<GeneralStatusCard> createState() => _GeneralStatusCardState();
}

class _GeneralStatusCardState extends State<GeneralStatusCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requiresAttention = widget.evaluation.requiresAttention;
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
}
