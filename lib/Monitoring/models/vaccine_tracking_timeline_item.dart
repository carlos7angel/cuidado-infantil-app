class VaccineTrackingTimelineItem {
  final String date;
  final String? registeredAt;
  final String? registeredAtReadable;
  final String vaccineName;
  final int doseNumber;
  final String status;
  final String? appliedAt;
  final String vaccineDoseId;

  VaccineTrackingTimelineItem({
    required this.date,
    this.registeredAt,
    this.registeredAtReadable,
    required this.vaccineName,
    required this.doseNumber,
    required this.status,
    this.appliedAt,
    required this.vaccineDoseId,
  });

  factory VaccineTrackingTimelineItem.fromJson(Map<String, dynamic> json) {
    return VaccineTrackingTimelineItem(
      date: json['date'] ?? '',
      registeredAt: json['registered_at'],
      registeredAtReadable: json['registered_at_readable'],
      vaccineName: json['vaccine_name'] ?? '',
      doseNumber: json['dose_number'] ?? 0,
      status: json['status'] ?? '',
      appliedAt: json['applied_at'],
      vaccineDoseId: json['vaccine_dose_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'registered_at': registeredAt,
      'registered_at_readable': registeredAtReadable,
      'vaccine_name': vaccineName,
      'dose_number': doseNumber,
      'status': status,
      'applied_at': appliedAt,
      'vaccine_dose_id': vaccineDoseId,
    };
  }
}

