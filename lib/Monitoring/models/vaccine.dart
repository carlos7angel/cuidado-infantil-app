class Vaccine {
  final String id;
  final String name;
  final String? description;
  final int totalDoses;
  final bool isRequired;

  Vaccine({
    required this.id,
    required this.name,
    this.description,
    required this.totalDoses,
    required this.isRequired,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      totalDoses: json['total_doses'] ?? 0,
      isRequired: json['is_required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'total_doses': totalDoses,
      'is_required': isRequired,
    };
  }
}

