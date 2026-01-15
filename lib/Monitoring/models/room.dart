class Room {
  final String id;
  final String name;
  final String? description;
  final int? capacity;
  final bool isActive;

  const Room({
    required this.id,
    required this.name,
    this.description,
    this.capacity,
    this.isActive = true,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      capacity: map['capacity'],
      isActive: map['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'capacity': capacity,
      'is_active': isActive,
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Room && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
