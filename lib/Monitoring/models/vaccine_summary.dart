class VaccineSummary {
  final int totalVaccines;
  final int totalDoses;
  final int appliedCount;
  final int pendingCount;
  final int overdueCount;
  final int upcomingCount;
  final int expiredCount;
  final double completionPercentage;

  VaccineSummary({
    required this.totalVaccines,
    required this.totalDoses,
    required this.appliedCount,
    required this.pendingCount,
    required this.overdueCount,
    required this.upcomingCount,
    required this.expiredCount,
    required this.completionPercentage,
  });

  factory VaccineSummary.fromJson(Map<String, dynamic> json) {
    return VaccineSummary(
      totalVaccines: json['total_vaccines'] ?? 0,
      totalDoses: json['total_doses'] ?? 0,
      appliedCount: json['applied_count'] ?? 0,
      pendingCount: json['pending_count'] ?? 0,
      overdueCount: json['overdue_count'] ?? 0,
      upcomingCount: json['upcoming_count'] ?? 0,
      expiredCount: json['expired_count'] ?? 0,
      completionPercentage: (json['completion_percentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_vaccines': totalVaccines,
      'total_doses': totalDoses,
      'applied_count': appliedCount,
      'pending_count': pendingCount,
      'overdue_count': overdueCount,
      'upcoming_count': upcomingCount,
      'expired_count': expiredCount,
      'completion_percentage': completionPercentage,
    };
  }
}

