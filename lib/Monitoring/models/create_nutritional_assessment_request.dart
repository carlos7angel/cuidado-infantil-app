class CreateNutritionalAssessmentRequest {
  final String childId;
  final String weight;
  final String height;
  final String? actionsTaken;

  CreateNutritionalAssessmentRequest({
    required this.childId,
    required this.weight,
    required this.height,
    this.actionsTaken,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      if (actionsTaken != null && actionsTaken!.isNotEmpty) 'actions_taken': actionsTaken,
    };
  }
}

