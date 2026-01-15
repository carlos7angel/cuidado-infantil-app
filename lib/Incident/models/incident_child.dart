class IncidentChild {
  final String? id;
  final String? firstName;
  final String? paternalLastName;
  final String? maternalLastName;
  final String? fullName;
  final String? gender;
  final String? birthDate;
  final int? age;
  final String? avatar;
  final String? language;
  final String? country;
  final String? state;
  final String? city;
  final String? address;

  IncidentChild({
    this.id,
    this.firstName,
    this.paternalLastName,
    this.maternalLastName,
    this.fullName,
    this.gender,
    this.birthDate,
    this.age,
    this.avatar,
    this.language,
    this.country,
    this.state,
    this.city,
    this.address,
  });

  factory IncidentChild.fromJson(Map<String, dynamic> json) {
    // El JSON viene con estructura: { "data": { "type": "Child", "id": "...", "general": {...} } }
    final general = json['general'] as Map<String, dynamic>? ?? json;
    
    return IncidentChild(
      id: json['id']?.toString(),
      firstName: general['first_name']?.toString(),
      paternalLastName: general['paternal_last_name']?.toString(),
      maternalLastName: general['maternal_last_name']?.toString(),
      fullName: general['full_name']?.toString(),
      gender: general['gender']?.toString(),
      birthDate: general['birth_date']?.toString(),
      age: general['age'] is int 
          ? general['age'] 
          : (general['age'] != null ? int.tryParse(general['age'].toString()) : null),
      avatar: general['avatar']?.toString(),
      language: general['language']?.toString(),
      country: general['country']?.toString(),
      state: general['state']?.toString(),
      city: general['city']?.toString(),
      address: general['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'paternal_last_name': paternalLastName,
      'maternal_last_name': maternalLastName,
      'full_name': fullName,
      'gender': gender,
      'birth_date': birthDate,
      'age': age,
      'avatar': avatar,
      'language': language,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
    };
  }
}

