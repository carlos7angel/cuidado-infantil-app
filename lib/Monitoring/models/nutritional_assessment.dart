class NutritionalAssessment {
  final String? type;
  final String? id;
  final String? childId;
  final String? assessmentDate;
  final int? ageInMonths;
  final String? ageReadable;
  final String? weight;
  final String? height;
  final String? headCircumference;
  final String? armCircumference;
  final double? bmi;
  final String? zWeightAge;
  final String? zHeightAge;
  final String? zWeightHeight;
  final String? zBmiAge;
  final String? statusWeightAge;
  final String? statusWeightAgeLabel;
  final String? statusWeightAgeInterpretation;
  final String? statusHeightAge;
  final String? statusHeightAgeLabel;
  final String? statusHeightAgeInterpretation;
  final String? statusWeightHeight;
  final String? statusWeightHeightLabel;
  final String? statusWeightHeightInterpretation;
  final String? statusBmiAge;
  final String? statusBmiAgeLabel;
  final String? statusBmiAgeInterpretation;
  final bool requiresAttention;
  final String? criticalStatus;
  final String? criticalStatusLabel;
  final String? observations;
  final String? recommendations;
  final String? nextAssessmentDate;
  final String? createdAt;
  final String? updatedAt;

  NutritionalAssessment({
    this.type,
    this.id,
    this.childId,
    this.assessmentDate,
    this.ageInMonths,
    this.ageReadable,
    this.weight,
    this.height,
    this.headCircumference,
    this.armCircumference,
    this.bmi,
    this.zWeightAge,
    this.zHeightAge,
    this.zWeightHeight,
    this.zBmiAge,
    this.statusWeightAge,
    this.statusWeightAgeLabel,
    this.statusWeightAgeInterpretation,
    this.statusHeightAge,
    this.statusHeightAgeLabel,
    this.statusHeightAgeInterpretation,
    this.statusWeightHeight,
    this.statusWeightHeightLabel,
    this.statusWeightHeightInterpretation,
    this.statusBmiAge,
    this.statusBmiAgeLabel,
    this.statusBmiAgeInterpretation,
    this.requiresAttention = false,
    this.criticalStatus,
    this.criticalStatusLabel,
    this.observations,
    this.recommendations,
    this.nextAssessmentDate,
    this.createdAt,
    this.updatedAt,
  });

  factory NutritionalAssessment.fromJson(Map<String, dynamic> json) {
    return NutritionalAssessment(
      type: json['type']?.toString(),
      id: json['id']?.toString(),
      childId: json['child_id']?.toString(),
      assessmentDate: json['assessment_date']?.toString(),
      ageInMonths: json['age_in_months'] is int 
          ? json['age_in_months'] 
          : (json['age_in_months'] != null ? int.tryParse(json['age_in_months'].toString()) : null),
      ageReadable: json['age_readable']?.toString(),
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      headCircumference: json['head_circumference']?.toString(),
      armCircumference: json['arm_circumference']?.toString(),
      bmi: json['bmi'] is double 
          ? json['bmi'] 
          : (json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null),
      zWeightAge: json['z_weight_age']?.toString(),
      zHeightAge: json['z_height_age']?.toString(),
      zWeightHeight: json['z_weight_height']?.toString(),
      zBmiAge: json['z_bmi_age']?.toString(),
      statusWeightAge: json['status_weight_age']?.toString(),
      statusWeightAgeLabel: json['status_weight_age_label']?.toString(),
      statusWeightAgeInterpretation: json['status_weight_age_interpretation']?.toString(),
      statusHeightAge: json['status_height_age']?.toString(),
      statusHeightAgeLabel: json['status_height_age_label']?.toString(),
      statusHeightAgeInterpretation: json['status_height_age_interpretation']?.toString(),
      statusWeightHeight: json['status_weight_height']?.toString(),
      statusWeightHeightLabel: json['status_weight_height_label']?.toString(),
      statusWeightHeightInterpretation: json['status_weight_height_interpretation']?.toString(),
      statusBmiAge: json['status_bmi_age']?.toString(),
      statusBmiAgeLabel: json['status_bmi_age_label']?.toString(),
      statusBmiAgeInterpretation: json['status_bmi_age_interpretation']?.toString(),
      requiresAttention: json['requires_attention'] == true || json['requires_attention'] == 'true',
      criticalStatus: json['critical_status']?.toString(),
      criticalStatusLabel: json['critical_status_label']?.toString(),
      observations: json['observations']?.toString(),
      recommendations: json['recommendations']?.toString(),
      nextAssessmentDate: json['next_assessment_date']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'child_id': childId,
      'assessment_date': assessmentDate,
      'age_in_months': ageInMonths,
      'age_readable': ageReadable,
      'weight': weight,
      'height': height,
      'head_circumference': headCircumference,
      'arm_circumference': armCircumference,
      'bmi': bmi,
      'z_weight_age': zWeightAge,
      'z_height_age': zHeightAge,
      'z_weight_height': zWeightHeight,
      'z_bmi_age': zBmiAge,
      'status_weight_age': statusWeightAge,
      'status_weight_age_label': statusWeightAgeLabel,
      'status_weight_age_interpretation': statusWeightAgeInterpretation,
      'status_height_age': statusHeightAge,
      'status_height_age_label': statusHeightAgeLabel,
      'status_height_age_interpretation': statusHeightAgeInterpretation,
      'status_weight_height': statusWeightHeight,
      'status_weight_height_label': statusWeightHeightLabel,
      'status_weight_height_interpretation': statusWeightHeightInterpretation,
      'status_bmi_age': statusBmiAge,
      'status_bmi_age_label': statusBmiAgeLabel,
      'status_bmi_age_interpretation': statusBmiAgeInterpretation,
      'requires_attention': requiresAttention,
      'critical_status': criticalStatus,
      'critical_status_label': criticalStatusLabel,
      'observations': observations,
      'recommendations': recommendations,
      'next_assessment_date': nextAssessmentDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Formatea la fecha de evaluación para mostrar
  String? get formattedAssessmentDate {
    if (assessmentDate == null) return null;
    try {
      final date = DateTime.parse(assessmentDate!);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return assessmentDate;
    }
  }

  /// Formatea la edad desde age_in_months al formato "X año(s) y Y mes(es)"
  String get formattedAge {
    if (ageInMonths == null || ageInMonths! <= 0) return 'N/A';
    
    final years = ageInMonths! ~/ 12; // División entera para obtener años
    final months = ageInMonths! % 12; // Residuo para obtener meses restantes
    
    if (years == 0) {
      return months == 1 ? '$months mes' : '$months meses';
    } else if (months == 0) {
      return years == 1 ? '$years año' : '$years años';
    } else {
      final yearText = years == 1 ? '$years año' : '$years años';
      final monthText = months == 1 ? '$months mes' : '$months meses';
      return '$yearText y $monthText';
    }
  }

  /// Obtiene la talla como entero (sin decimales)
  String? get heightAsInteger {
    if (height == null || height!.isEmpty) return null;
    try {
      final heightValue = double.tryParse(height!);
      if (heightValue == null) return height;
      return heightValue.toInt().toString();
    } catch (e) {
      return height;
    }
  }
}

