import 'package:flutter/material.dart';

class IncidentUiHelpers {
  static IconData getSeverityIcon(String? severityLevel) {
    switch (severityLevel?.toLowerCase()) {
      case 'leve':
        return Icons.info_outline;
      case 'moderado':
        return Icons.warning_amber_rounded;
      case 'grave':
        return Icons.error_outline;
      case 'critico':
        return Icons.dangerous;
      default:
        return Icons.info_outline;
    }
  }

  static IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'reportado':
        return Icons.flag_outlined;
      case 'en_revision':
        return Icons.search;
      case 'cerrado':
        return Icons.check_circle_outline;
      case 'escalado':
        return Icons.trending_up;
      case 'archivado':
        return Icons.archive_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
