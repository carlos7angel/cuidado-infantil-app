import 'package:cuidado_infantil/Monitoring/models/development_score.dart';
import 'package:cuidado_infantil/Monitoring/models/development_item.dart';

class AssessedBy {
  final String? id;
  final String? name;

  AssessedBy({
    this.id,
    this.name,
  });

  factory AssessedBy.fromJson(Map<String, dynamic> json) {
    return AssessedBy(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Measurements {
  final String? weight;
  final String? height;
  final String? weightFormatted;
  final String? heightFormatted;

  Measurements({
    this.weight,
    this.height,
    this.weightFormatted,
    this.heightFormatted,
  });

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      weightFormatted: json['weight_formatted']?.toString(),
      heightFormatted: json['height_formatted']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'weight_formatted': weightFormatted,
      'height_formatted': heightFormatted,
    };
  }
}

class ChildDevelopmentEvaluation {
  final String? type;
  final String? id;
  final String? childId;
  final String? evaluationDate;
  final String? evaluationDateReadable;
  final int? ageMonths;
  final String? ageReadable;
  final AssessedBy? assessedBy;
  final Measurements? measurements;
  final Map<String, DevelopmentScore> scores;
  final double? overallScore;
  final String? overallStatus;
  final bool requiresAttention;
  final List<String>? areasRequiringAttention;
  final String? actionsTaken;
  final String? notes;
  final String? nextEvaluationDate;
  final String? nextEvaluationDateReadable;
  final String? createdAt;
  final String? updatedAt;
  final String? readableCreatedAt;
  final String? readableUpdatedAt;
  final Map<String, DevelopmentItemsByArea>? itemsByArea;

  ChildDevelopmentEvaluation({
    this.type,
    this.id,
    this.childId,
    this.evaluationDate,
    this.evaluationDateReadable,
    this.ageMonths,
    this.ageReadable,
    this.assessedBy,
    this.measurements,
    this.scores = const {},
    this.overallScore,
    this.overallStatus,
    this.requiresAttention = false,
    this.areasRequiringAttention,
    this.actionsTaken,
    this.notes,
    this.nextEvaluationDate,
    this.nextEvaluationDateReadable,
    this.createdAt,
    this.updatedAt,
    this.readableCreatedAt,
    this.readableUpdatedAt,
    this.itemsByArea,
  });

  factory ChildDevelopmentEvaluation.fromJson(Map<String, dynamic> json) {
    // Parsear scores
    Map<String, DevelopmentScore> scoresMap = {};
    if (json['scores'] != null && json['scores'] is Map) {
      final scoresData = json['scores'] as Map<String, dynamic>;
      scoresData.forEach((key, value) {
        if (value is Map) {
          scoresMap[key] = DevelopmentScore.fromJson(value as Map<String, dynamic>);
        }
      });
    }

    // Parsear assessed_by
    AssessedBy? assessedBy;
    if (json['assessed_by'] != null && json['assessed_by'] is Map) {
      assessedBy = AssessedBy.fromJson(json['assessed_by'] as Map<String, dynamic>);
    }

    // Parsear measurements
    Measurements? measurements;
    if (json['measurements'] != null && json['measurements'] is Map) {
      measurements = Measurements.fromJson(json['measurements'] as Map<String, dynamic>);
    }

    // Parsear items_by_area
    Map<String, DevelopmentItemsByArea>? itemsByAreaMap;
    if (json['items_by_area'] != null && json['items_by_area'] is Map) {
      itemsByAreaMap = {};
      final itemsData = json['items_by_area'] as Map<String, dynamic>;
      itemsData.forEach((key, value) {
        if (value is Map) {
          itemsByAreaMap![key] = DevelopmentItemsByArea.fromJson(value as Map<String, dynamic>);
        }
      });
    }

    // Parsear areas_requiring_attention
    List<String>? areasRequiringAttention;
    if (json['areas_requiring_attention'] != null && json['areas_requiring_attention'] is List) {
      areasRequiringAttention = (json['areas_requiring_attention'] as List)
          .map((e) => e.toString())
          .toList();
    }

    return ChildDevelopmentEvaluation(
      type: json['type']?.toString(),
      id: json['id']?.toString(),
      childId: json['child_id']?.toString(),
      evaluationDate: json['evaluation_date']?.toString(),
      evaluationDateReadable: json['evaluation_date_readable']?.toString(),
      ageMonths: json['age_months'] is int 
          ? json['age_months'] 
          : (json['age_months'] != null ? int.tryParse(json['age_months'].toString()) : null),
      ageReadable: json['age_readable']?.toString(),
      assessedBy: assessedBy,
      measurements: measurements,
      scores: scoresMap,
      overallScore: json['overall_score'] is double 
          ? json['overall_score'] 
          : (json['overall_score'] != null ? double.tryParse(json['overall_score'].toString()) : null),
      overallStatus: json['overall_status']?.toString(),
      requiresAttention: json['requires_attention'] == true || json['requires_attention'] == 'true',
      areasRequiringAttention: areasRequiringAttention,
      actionsTaken: json['actions_taken']?.toString(),
      notes: json['notes']?.toString(),
      nextEvaluationDate: json['next_evaluation_date']?.toString(),
      nextEvaluationDateReadable: json['next_evaluation_date_readable']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      readableCreatedAt: json['readable_created_at']?.toString(),
      readableUpdatedAt: json['readable_updated_at']?.toString(),
      itemsByArea: itemsByAreaMap,
    );
  }

  Map<String, dynamic> toJson() {
    final scoresJson = <String, dynamic>{};
    scores.forEach((key, value) {
      scoresJson[key] = value.toJson();
    });

    final itemsByAreaJson = <String, dynamic>{};
    itemsByArea?.forEach((key, value) {
      itemsByAreaJson[key] = value.toJson();
    });

    return {
      'type': type,
      'id': id,
      'child_id': childId,
      'evaluation_date': evaluationDate,
      'evaluation_date_readable': evaluationDateReadable,
      'age_months': ageMonths,
      'age_readable': ageReadable,
      'assessed_by': assessedBy?.toJson(),
      'measurements': measurements?.toJson(),
      'scores': scoresJson,
      'overall_score': overallScore,
      'overall_status': overallStatus,
      'requires_attention': requiresAttention,
      'areas_requiring_attention': areasRequiringAttention,
      'actions_taken': actionsTaken,
      'notes': notes,
      'next_evaluation_date': nextEvaluationDate,
      'next_evaluation_date_readable': nextEvaluationDateReadable,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'readable_created_at': readableCreatedAt,
      'readable_updated_at': readableUpdatedAt,
      'items_by_area': itemsByAreaJson,
    };
  }

  /// Formatea la edad desde ageMonths al formato "X año(s) y Y mes(es)"
  String get formattedAge {
    if (ageMonths == null || ageMonths! <= 0) return 'N/A';
    
    final years = ageMonths! ~/ 12; // División entera para obtener años
    final months = ageMonths! % 12; // Residuo para obtener meses restantes
    
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

  /// Obtiene el score por su clave (MG, MF, AL, PS)
  DevelopmentScore? getScore(String key) {
    return scores[key];
  }

  /// Obtiene el raw score por su clave
  int? getRawScore(String key) {
    return scores[key]?.rawScore;
  }
}

