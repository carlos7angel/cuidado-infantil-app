class ChildVaccination {
  final String id;
  final String dateApplied;
  final String? registeredAt;
  final String? registeredAtReadable;
  final String? appliedAt;
  final String? notes;
  final double? daysSinceApplied;

  ChildVaccination({
    required this.id,
    required this.dateApplied,
    this.registeredAt,
    this.registeredAtReadable,
    this.appliedAt,
    this.notes,
    this.daysSinceApplied,
  });

  factory ChildVaccination.fromJson(Map<String, dynamic> json) {
    try {
      return ChildVaccination(
        id: json['id']?.toString() ?? '',
        dateApplied: json['date_applied']?.toString() ?? '',
        registeredAt: json['registered_at']?.toString(),
        registeredAtReadable: json['registered_at_readable']?.toString(),
        appliedAt: json['applied_at']?.toString(),
        notes: json['notes']?.toString(),
        daysSinceApplied: json['days_since_applied'] != null 
            ? (json['days_since_applied'] is int 
                ? (json['days_since_applied'] as int).toDouble() 
                : json['days_since_applied']?.toDouble())
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_applied': dateApplied,
      'registered_at': registeredAt,
      'registered_at_readable': registeredAtReadable,
      'applied_at': appliedAt,
      'notes': notes,
      'days_since_applied': daysSinceApplied,
    };
  }
}

