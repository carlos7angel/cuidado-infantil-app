class DevelopmentScore {
  final String? area;
  final String? areaLabel;
  final int? rawScore;
  final int? maxPossibleScore;
  final double? percentage;
  final String? status;
  final String? statusLabel;
  final String? statusDescription;
  final String? statusColor;
  final bool requiresAttention;

  DevelopmentScore({
    this.area,
    this.areaLabel,
    this.rawScore,
    this.maxPossibleScore,
    this.percentage,
    this.status,
    this.statusLabel,
    this.statusDescription,
    this.statusColor,
    this.requiresAttention = false,
  });

  factory DevelopmentScore.fromJson(Map<String, dynamic> json) {
    return DevelopmentScore(
      area: json['area']?.toString(),
      areaLabel: json['area_label']?.toString(),
      rawScore: json['raw_score'] is int 
          ? json['raw_score'] 
          : (json['raw_score'] != null ? int.tryParse(json['raw_score'].toString()) : null),
      maxPossibleScore: json['max_possible_score'] is int 
          ? json['max_possible_score'] 
          : (json['max_possible_score'] != null ? int.tryParse(json['max_possible_score'].toString()) : null),
      percentage: json['percentage'] is double 
          ? json['percentage'] 
          : (json['percentage'] != null ? double.tryParse(json['percentage'].toString()) : null),
      status: json['status']?.toString(),
      statusLabel: json['status_label']?.toString(),
      statusDescription: json['status_description']?.toString(),
      statusColor: json['status_color']?.toString(),
      requiresAttention: json['requires_attention'] == true || json['requires_attention'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'area_label': areaLabel,
      'raw_score': rawScore,
      'max_possible_score': maxPossibleScore,
      'percentage': percentage,
      'status': status,
      'status_label': statusLabel,
      'status_description': statusDescription,
      'status_color': statusColor,
      'requires_attention': requiresAttention,
    };
  }
}

