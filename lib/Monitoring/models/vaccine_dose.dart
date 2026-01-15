class VaccineDose {
  final String id;
  final int doseNumber;
  final int recommendedAgeMonths;
  final int? minAgeMonths;
  final int? maxAgeMonths;
  final String recommendedAgeReadable;
  final String ageRangeReadable;
  final String? description;

  VaccineDose({
    required this.id,
    required this.doseNumber,
    required this.recommendedAgeMonths,
    this.minAgeMonths,
    this.maxAgeMonths,
    required this.recommendedAgeReadable,
    required this.ageRangeReadable,
    this.description,
  });

  factory VaccineDose.fromJson(Map<String, dynamic> json) {
    return VaccineDose(
      id: json['id']?.toString() ?? '',
      doseNumber: json['dose_number'] ?? 0,
      recommendedAgeMonths: json['recommended_age_months'] ?? 0,
      minAgeMonths: json['min_age_months'],
      maxAgeMonths: json['max_age_months'],
      recommendedAgeReadable: json['recommended_age_readable'] ?? '',
      ageRangeReadable: json['age_range_readable'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dose_number': doseNumber,
      'recommended_age_months': recommendedAgeMonths,
      'min_age_months': minAgeMonths,
      'max_age_months': maxAgeMonths,
      'recommended_age_readable': recommendedAgeReadable,
      'age_range_readable': ageRangeReadable,
      'description': description,
    };
  }
}

