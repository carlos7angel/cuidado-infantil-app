import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Monitoring/models/child_development_evaluation.dart';
import 'package:cuidado_infantil/Monitoring/ui/monitoring_ui_helpers.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvaluationInfoCard extends StatelessWidget {
  final ChildDevelopmentEvaluation evaluation;

  const EvaluationInfoCard({
    super.key,
    required this.evaluation,
  });

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

  @override
  Widget build(BuildContext context) {
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
                        DonutChart(
                          percentage: evaluation.overallScore!,
                          status: evaluation.overallStatus ?? 'normal',
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
                                  MonitoringUiHelpers.getStatusLabel(evaluation.overallStatus!),
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: MonitoringUiHelpers.getStatusColor(evaluation.overallStatus!),
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

          if (evaluation.actionsTaken != null && evaluation.actionsTaken!.isNotEmpty)
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
                    evaluation.actionsTaken!,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
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
}
