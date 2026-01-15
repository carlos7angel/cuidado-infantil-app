import 'package:cuidado_infantil/Monitoring/models/vaccine_info.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_summary.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_tracking_timeline_item.dart';

class VaccineTrackingChildInfo {
  final String id;
  final String name;
  final int ageInMonths;
  final String ageReadable;
  final String birthDate;

  VaccineTrackingChildInfo({
    required this.id,
    required this.name,
    required this.ageInMonths,
    required this.ageReadable,
    required this.birthDate,
  });

  factory VaccineTrackingChildInfo.fromJson(Map<String, dynamic> json) {
    return VaccineTrackingChildInfo(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      ageInMonths: json['age_in_months'] ?? 0,
      ageReadable: json['age_readable'] ?? '',
      birthDate: json['birth_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age_in_months': ageInMonths,
      'age_readable': ageReadable,
      'birth_date': birthDate,
    };
  }
}

class VaccineTrackingResponse {
  final VaccineTrackingChildInfo child;
  final VaccineSummary summary;
  final List<VaccineInfo> vaccines;
  final List<VaccineTrackingTimelineItem> timeline;

  VaccineTrackingResponse({
    required this.child,
    required this.summary,
    required this.vaccines,
    required this.timeline,
  });

  factory VaccineTrackingResponse.fromJson(Map<String, dynamic> json) {
    return VaccineTrackingResponse(
      child: VaccineTrackingChildInfo.fromJson(json['child'] as Map<String, dynamic>),
      summary: VaccineSummary.fromJson(json['summary'] as Map<String, dynamic>),
      vaccines: (json['vaccines'] as List<dynamic>?)
          ?.map((vaccineJson) => VaccineInfo.fromJson(vaccineJson as Map<String, dynamic>))
          .toList() ?? [],
      timeline: (json['timeline'] as List<dynamic>?)
          ?.map((timelineJson) => VaccineTrackingTimelineItem.fromJson(timelineJson as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'child': child.toJson(),
      'summary': summary.toJson(),
      'vaccines': vaccines.map((vaccine) => vaccine.toJson()).toList(),
      'timeline': timeline.map((item) => item.toJson()).toList(),
    };
  }
}

