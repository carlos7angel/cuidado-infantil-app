class FamilyMember {
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String relationship;
  final String gender;
  final String educationLevel;
  final String maritalStatus;
  final String phone;
  final String? profession;
  final bool hasIncome;
  final String workplace;
  final String incomeType;
  final String incomeTotal;

  FamilyMember({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.relationship,
    required this.gender,
    required this.educationLevel,
    required this.maritalStatus,
    required this.phone,
    this.profession,
    required this.hasIncome,
    required this.workplace,
    required this.incomeType,
    required this.incomeTotal,
  });

  FamilyMember copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? relationship,
    String? gender,
    String? educationLevel,
    String? maritalStatus,
    String? phone,
    String? profession,
    bool? hasIncome,
    String? workplace,
    String? incomeType,
    String? incomeTotal,
  }) {
    return FamilyMember(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      relationship: relationship ?? this.relationship,
      gender: gender ?? this.gender,
      educationLevel: educationLevel ?? this.educationLevel,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      phone: phone ?? this.phone,
      profession: profession ?? this.profession,
      hasIncome: hasIncome ?? this.hasIncome,
      workplace: workplace ?? this.workplace,
      incomeType: incomeType ?? this.incomeType,
      incomeTotal: incomeTotal ?? this.incomeTotal,
    );
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    // El backend usa 'kinship' pero el modelo usa 'relationship'
    DateTime? birthDate;
    if (map['birth_date'] != null) {
      if (map['birth_date'] is DateTime) {
        birthDate = map['birth_date'];
      } else if (map['birth_date'] is String) {
        birthDate = DateTime.tryParse(map['birth_date']);
      }
    }
    
    return FamilyMember(
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      birthDate: birthDate,
      relationship: map['kinship'] ?? map['relationship'] ?? '', // Backend usa 'kinship'
      gender: map['gender'] ?? '',
      educationLevel: map['education_level'] ?? '',
      maritalStatus: map['marital_status'] ?? '',
      phone: map['phone'] ?? '',
      profession: map['profession'],
      hasIncome: map['has_income'] is bool ? map['has_income'] : (map['has_income'] == '1' || map['has_income'] == true),
      workplace: map['workplace'] ?? '',
      incomeType: map['income_type'] ?? '',
      // El backend puede retornar 'total_income' o 'income_total'
      incomeTotal: (map['total_income'] ?? map['income_total'])?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate?.toIso8601String(),
      'relationship': relationship,
      'gender': gender,
      'education_level': educationLevel,
      'marital_status': maritalStatus,
      'phone': phone,
      'profession': profession,
      'has_income': hasIncome,
      'workplace': workplace,
      'income_type': incomeType,
      'income_total': incomeTotal,
    };
  }
}

