class VaccineProgress {
  final int applied;
  final int total;
  final double percentage;
  final bool isComplete;

  VaccineProgress({
    required this.applied,
    required this.total,
    required this.percentage,
    required this.isComplete,
  });

  factory VaccineProgress.fromJson(Map<String, dynamic> json) {
    return VaccineProgress(
      applied: json['applied'] ?? 0,
      total: json['total'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      isComplete: json['is_complete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applied': applied,
      'total': total,
      'percentage': percentage,
      'is_complete': isComplete,
    };
  }
}

