import 'package:flutter/material.dart';

class MonitoringUiHelpers {
  static Color getStatusColor(String status) {
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

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'medio_alto':
      case 'alto':
        return Icons.check_circle;
      case 'alerta':
      case 'alert':
        return Icons.warning_rounded;
      case 'medio':
      case 'medio_bajo':
        return Icons.info_outline;
      default:
        return Icons.info;
    }
  }

  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'alerta':
      case 'alert':
        return 'Alerta';
      case 'medio_bajo':
        return 'Medio Bajo';
      case 'medio':
        return 'Medio';
      case 'medio_alto':
        return 'Medio Alto';
      case 'normal':
        return 'Normal';
      case 'alto':
        return 'Alto';
      default:
        return status;
    }
  }
}
