import 'package:cuidado_infantil/Monitoring/models/vaccine.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_dose_info.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_progress.dart';

class VaccineInfo {
  final Vaccine vaccine;
  final List<VaccineDoseInfo> doses;
  final VaccineProgress progress;

  VaccineInfo({
    required this.vaccine,
    required this.doses,
    required this.progress,
  });

  factory VaccineInfo.fromJson(Map<String, dynamic> json) {
    return VaccineInfo(
      vaccine: Vaccine.fromJson(json['vaccine'] as Map<String, dynamic>),
      doses: (json['doses'] as List<dynamic>?)
          ?.map((doseJson) => VaccineDoseInfo.fromJson(doseJson as Map<String, dynamic>))
          .toList() ?? [],
      progress: VaccineProgress.fromJson(json['progress'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccine': vaccine.toJson(),
      'doses': doses.map((dose) => dose.toJson()).toList(),
      'progress': progress.toJson(),
    };
  }
}

