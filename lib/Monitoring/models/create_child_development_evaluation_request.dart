class CreateChildDevelopmentEvaluationRequest {
  final String childId;
  final List<String> items;
  final String? notes;
  final String? actionsTaken;

  CreateChildDevelopmentEvaluationRequest({
    required this.childId,
    required this.items,
    this.notes,
    this.actionsTaken,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (actionsTaken != null && actionsTaken!.isNotEmpty) 'actions_taken': actionsTaken,
    };
  }
}

