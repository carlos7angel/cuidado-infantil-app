import 'package:cuidado_infantil/Monitoring/models/vaccine_dose.dart';
import 'package:cuidado_infantil/Monitoring/models/child_vaccination.dart';

class VaccineDoseInfo {
  final VaccineDose dose;
  final String status; // applied, overdue, upcoming, expired
  final String statusLabel;
  final String statusColor; // success, warning, danger, info
  final String ageStatus; // expired, overdue, too_young, on_time
  final String ageStatusLabel;
  final ChildVaccination? childVaccination;
  final int? daysOverdue;
  final int? monthsUntilAvailable;

  VaccineDoseInfo({
    required this.dose,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.ageStatus,
    required this.ageStatusLabel,
    this.childVaccination,
    this.daysOverdue,
    this.monthsUntilAvailable,
  });

  factory VaccineDoseInfo.fromJson(Map<String, dynamic> json) {
    try {
      ChildVaccination? childVaccination;
      
      // Manejar child_vaccination de manera más robusta
      if (json['child_vaccination'] != null) {
        try {
          if (json['child_vaccination'] is Map) {
            childVaccination = ChildVaccination.fromJson(json['child_vaccination'] as Map<String, dynamic>);
          }
        } catch (e) {
          // Ignorar error de parseo
        }
      }
      
      return VaccineDoseInfo(
        dose: VaccineDose.fromJson(json['dose'] as Map<String, dynamic>),
        status: json['status']?.toString() ?? '',
        statusLabel: json['status_label']?.toString() ?? '',
        statusColor: json['status_color']?.toString() ?? '',
        ageStatus: json['age_status']?.toString() ?? '',
        ageStatusLabel: json['age_status_label']?.toString() ?? '',
        childVaccination: childVaccination,
        daysOverdue: json['days_overdue'] is int ? json['days_overdue'] as int : (json['days_overdue'] != null ? int.tryParse(json['days_overdue'].toString()) : null),
        monthsUntilAvailable: json['months_until_available'] is int ? json['months_until_available'] as int : (json['months_until_available'] != null ? int.tryParse(json['months_until_available'].toString()) : null),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'dose': dose.toJson(),
      'status': status,
      'status_label': statusLabel,
      'status_color': statusColor,
      'age_status': ageStatus,
      'age_status_label': ageStatusLabel,
      'child_vaccination': childVaccination?.toJson(),
      'days_overdue': daysOverdue,
      'months_until_available': monthsUntilAvailable,
    };
  }
}

