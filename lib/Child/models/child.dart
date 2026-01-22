import 'package:cuidado_infantil/Child/models/family_member.dart';
import 'package:flutter/material.dart';

class Child {
  final String? id;
  final String firstName;
  final String paternalLastName;
  final String? maternalLastName;
  final String gender;
  final DateTime? birthDate;
  final String address;
  final String state;
  final String city;
  final String? municipality;
  final bool hasInsurance;
  final String? insuranceDetails;
  final String? weight;
  final String? height;
  final bool hasAllergies;
  final String? allergiesDetails;
  final bool hasMedicalTreatment;
  final String? medicalTreatmentDetails;
  final bool hasPsychologicalTreatment;
  final String? psychologicalTreatmentDetails;
  final bool hasDeficit;
  final String? auditoryDeficit;
  final String? visualDeficit;
  final String? tactileDeficit;
  final String? motorDeficit;
  final bool hasDisease;
  final String? diseaseDetails;
  final String? nutritionalProblems;
  final String? outstandingSkills;
  final String? otherConsiderations;
  final List<FamilyMember> familyMembers;
  final String? guardianType;
  final String? housingType;
  final String? housingTenure;
  final String? housingStructure;
  final String? floorType;
  final String? finishingType;
  final String? bedrooms;
  final String? incidentHistory;
  final String? pets;
  final List<String> rooms;
  final List<String> basicServices;
  final String? transportMode;
  final String? travelTime;
  final DateTime? enrollmentDate;
  final String? roomId;
  final List<dynamic>? enrollmentFiles;
  final List<dynamic>? fileBirthCertificate;
  final List<dynamic>? fileAdmissionRequest;
  final List<dynamic>? fileCommitment;
  final List<dynamic>? fileVaccinationCard;
  final List<dynamic>? fileParentId;
  final List<dynamic>? fileUtilityBill;
  final List<dynamic>? fileHomeSketch;
  final List<dynamic>? filePickupAuthorization;
  final dynamic avatar;
  final String? avatarUrl;

  const Child({
    this.id,
    required this.firstName,
    required this.paternalLastName,
    this.maternalLastName,
    required this.gender,
    this.birthDate,
    required this.address,
    required this.state,
    required this.city,
    this.municipality,
    required this.hasInsurance,
    this.insuranceDetails,
    this.weight,
    this.height,
    required this.hasAllergies,
    this.allergiesDetails,
    required this.hasMedicalTreatment,
    this.medicalTreatmentDetails,
    required this.hasPsychologicalTreatment,
    this.psychologicalTreatmentDetails,
    required this.hasDeficit,
    this.auditoryDeficit,
    this.visualDeficit,
    this.tactileDeficit,
    this.motorDeficit,
    required this.hasDisease,
    this.diseaseDetails,
    this.nutritionalProblems,
    this.outstandingSkills,
    this.otherConsiderations,
    this.familyMembers = const [],
    this.guardianType,
    this.housingType,
    this.housingTenure,
    this.housingStructure,
    this.floorType,
    this.finishingType,
    this.bedrooms,
    this.incidentHistory,
    this.pets,
    this.rooms = const [],
    this.basicServices = const [],
    this.transportMode,
    this.travelTime,
    this.enrollmentDate,
    this.roomId,
    this.enrollmentFiles,
    this.fileBirthCertificate,
    this.fileAdmissionRequest,
    this.fileCommitment,
    this.fileVaccinationCard,
    this.fileParentId,
    this.fileUtilityBill,
    this.fileHomeSketch,
    this.filePickupAuthorization,
    this.avatar,
    this.avatarUrl,
  });

  Child copyWith({
    String? id,
    String? firstName,
    String? paternalLastName,
    String? maternalLastName,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? state,
    String? city,
    String? municipality,
    bool? hasInsurance,
    String? insuranceDetails,
    String? weight,
    String? height,
    bool? hasAllergies,
    String? allergiesDetails,
    bool? hasMedicalTreatment,
    String? medicalTreatmentDetails,
    bool? hasPsychologicalTreatment,
    String? psychologicalTreatmentDetails,
    bool? hasDeficit,
    String? auditoryDeficit,
    String? visualDeficit,
    String? tactileDeficit,
    String? motorDeficit,
    bool? hasDisease,
    String? diseaseDetails,
    String? nutritionalProblems,
    String? outstandingSkills,
    String? otherConsiderations,
    List<FamilyMember>? familyMembers,
    String? guardianType,
    String? housingType,
    String? housingTenure,
    String? housingStructure,
    String? floorType,
    String? finishingType,
    String? bedrooms,
    String? incidentHistory,
    String? pets,
    List<String>? rooms,
    List<String>? basicServices,
    String? transportMode,
    String? travelTime,
    DateTime? enrollmentDate,
    String? roomId,
    List<dynamic>? enrollmentFiles,
    List<dynamic>? fileBirthCertificate,
    List<dynamic>? fileAdmissionRequest,
    List<dynamic>? fileCommitment,
    List<dynamic>? fileVaccinationCard,
    List<dynamic>? fileParentId,
    List<dynamic>? fileUtilityBill,
    List<dynamic>? fileHomeSketch,
    List<dynamic>? filePickupAuthorization,
    dynamic avatar,
    String? avatarUrl,
  }) {
    return Child(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      paternalLastName: paternalLastName ?? this.paternalLastName,
      maternalLastName: maternalLastName ?? this.maternalLastName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      state: state ?? this.state,
      city: city ?? this.city,
      municipality: municipality ?? this.municipality,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      insuranceDetails: insuranceDetails ?? this.insuranceDetails,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      hasAllergies: hasAllergies ?? this.hasAllergies,
      allergiesDetails: allergiesDetails ?? this.allergiesDetails,
      hasMedicalTreatment: hasMedicalTreatment ?? this.hasMedicalTreatment,
      medicalTreatmentDetails: medicalTreatmentDetails ?? this.medicalTreatmentDetails,
      hasPsychologicalTreatment: hasPsychologicalTreatment ?? this.hasPsychologicalTreatment,
      psychologicalTreatmentDetails: psychologicalTreatmentDetails ?? this.psychologicalTreatmentDetails,
      hasDeficit: hasDeficit ?? this.hasDeficit,
      auditoryDeficit: auditoryDeficit ?? this.auditoryDeficit,
      visualDeficit: visualDeficit ?? this.visualDeficit,
      tactileDeficit: tactileDeficit ?? this.tactileDeficit,
      motorDeficit: motorDeficit ?? this.motorDeficit,
      hasDisease: hasDisease ?? this.hasDisease,
      diseaseDetails: diseaseDetails ?? this.diseaseDetails,
      nutritionalProblems: nutritionalProblems ?? this.nutritionalProblems,
      outstandingSkills: outstandingSkills ?? this.outstandingSkills,
      otherConsiderations: otherConsiderations ?? this.otherConsiderations,
      familyMembers: familyMembers ?? this.familyMembers,
      guardianType: guardianType ?? this.guardianType,
      housingType: housingType ?? this.housingType,
      housingTenure: housingTenure ?? this.housingTenure,
      housingStructure: housingStructure ?? this.housingStructure,
      floorType: floorType ?? this.floorType,
      finishingType: finishingType ?? this.finishingType,
      bedrooms: bedrooms ?? this.bedrooms,
      incidentHistory: incidentHistory ?? this.incidentHistory,
      pets: pets ?? this.pets,
      rooms: rooms ?? this.rooms,
      basicServices: basicServices ?? this.basicServices,
      transportMode: transportMode ?? this.transportMode,
      travelTime: travelTime ?? this.travelTime,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      roomId: roomId ?? this.roomId,
      enrollmentFiles: enrollmentFiles ?? this.enrollmentFiles,
      fileBirthCertificate: fileBirthCertificate ?? this.fileBirthCertificate,
      fileAdmissionRequest: fileAdmissionRequest ?? this.fileAdmissionRequest,
      fileCommitment: fileCommitment ?? this.fileCommitment,
      fileVaccinationCard: fileVaccinationCard ?? this.fileVaccinationCard,
      fileParentId: fileParentId ?? this.fileParentId,
      fileUtilityBill: fileUtilityBill ?? this.fileUtilityBill,
      fileHomeSketch: fileHomeSketch ?? this.fileHomeSketch,
      filePickupAuthorization: filePickupAuthorization ?? this.filePickupAuthorization,
      avatar: avatar ?? this.avatar,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  /// Crea una instancia vacía del modelo para inicialización.
  factory Child.empty() {
    return const Child(
      firstName: '',
      paternalLastName: '',
      gender: '',
      address: '',
      state: '',
      city: '',
      hasInsurance: false,
      hasAllergies: false,
      hasMedicalTreatment: false,
      hasPsychologicalTreatment: false,
      hasDeficit: false,
      hasDisease: false,
      familyMembers: [],
      rooms: [],
      basicServices: [],
    );
  }

  /// Obtiene las iniciales: primera letra del apellido paterno + primera letra del nombre
  String getInitials() {
    String paternalInitial = '';
    String firstNameInitial = '';
    
    if (paternalLastName.isNotEmpty) {
      paternalInitial = paternalLastName.trim()[0].toUpperCase();
    }
    
    if (firstName.isNotEmpty) {
      firstNameInitial = firstName.trim()[0].toUpperCase();
    }
    
    // Si no hay iniciales, retornar '?'
    if (paternalInitial.isEmpty && firstNameInitial.isEmpty) {
      return '?';
    }
    
    return paternalInitial + firstNameInitial;
  }

  /// Obtiene el nombre completo ordenado: apellido paterno + apellido materno + nombres
  String getFullName() {
    List<String> parts = [];
    
    if (paternalLastName.isNotEmpty) {
      parts.add(paternalLastName);
    }
    
    if (maternalLastName != null && maternalLastName!.isNotEmpty) {
      parts.add(maternalLastName!);
    }
    
    if (firstName.isNotEmpty) {
      parts.add(firstName);
    }
    
    return parts.join(' ');
  }

  /// Obtiene el género formateado como texto legible
  /// Retorna "Masculino", "Femenino" o "No especificado"
  String getGenderReadable() {
    return Child.formatGender(gender);
  }

  /// Método estático para formatear el género desde un valor string
  static String formatGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return 'No especificado';
    }
    
    final genderLower = gender.toLowerCase().trim();
    
    // Valores en español
    if (genderLower == 'masculino') {
      return 'Masculino';
    } else if (genderLower == 'femenino') {
      return 'Femenino';
    }
    
    // Si no coincide con ningún valor conocido, retornar el valor original
    return gender;
  }

  /// Calcula y retorna la edad del infante en años y meses
  String getAge() {
    return Child.calculateAgeFromDate(birthDate);
  }

  /// Método estático para calcular la edad en meses desde una fecha de nacimiento
  static int? calculateAgeInMonths(
    DateTime? birthDate, {
    bool roundUp = true,
  }) {
    if (birthDate == null) {
      return null;
    }

    final now = DateTime.now();
    final birth = birthDate;
    
    // Calcular años completos
    int years = now.year - birth.year;
    
    // Calcular meses completos dentro del año actual
    int months = now.month - birth.month;
    
    // Ajustar si el mes actual es anterior al mes de nacimiento
    if (months < 0) {
      years--;
      months += 12;
    }
    
    // Si el día actual es menor al día de nacimiento, no hemos completado el mes actual
    // Restar un mes completo
    if (now.day < birth.day) {
      months--;
      if (months < 0) {
        years--;
        months += 12;
      }
    }

    // Calcular meses completos totales
    int completeMonths = (years * 12) + months;
    
    double monthFraction = 0.0;
    
    if (now.day < birth.day) {
      int daysInPreviousMonth = DateTime(now.year, now.month, 0).day;
      int daysFromLastBirthday = (daysInPreviousMonth - birth.day + 1) + now.day;
      int daysInPreviousMonthForFraction = daysInPreviousMonth;
      monthFraction = daysFromLastBirthday / daysInPreviousMonthForFraction;
    } else if (now.day > birth.day) {
      int daysInCurrentMonth = DateTime(now.year, now.month + 1, 0).day;
      int daysPassed = now.day - birth.day;
      monthFraction = daysPassed / daysInCurrentMonth;
    }
    double totalMonths = completeMonths + monthFraction;
    
    // Redondear según el parámetro roundUp
    return roundUp ? totalMonths.ceil() : totalMonths.floor();
  }

  /// Método estático para calcular la edad desde una fecha de nacimiento
  static String calculateAgeFromDate(DateTime? birthDate) {
    // Usar el método calculateAgeInMonths para obtener la edad en meses
    final ageInMonths = calculateAgeInMonths(birthDate);
    if (ageInMonths == null) {
      return 'Edad no especificada';
    }
    
    // Si tiene menos de 12 meses, retornar solo meses
    if (ageInMonths < 12) {
      return "$ageInMonths ${ageInMonths == 1 ? 'mes' : 'meses'}";
    }
    
    // Calcular años y meses restantes (similar a intdiv y % en PHP)
    int calculatedYears = ageInMonths ~/ 12; // División entera
    int remainingMonths = ageInMonths % 12;  // Resto
    
    // Si no hay meses restantes, retornar solo años
    if (remainingMonths == 0) {
      return "$calculatedYears ${calculatedYears == 1 ? 'año' : 'años'}";
    }
    
    // Retornar años y meses con "y" entre ellos
    return "$calculatedYears ${calculatedYears == 1 ? 'año' : 'años'} y $remainingMonths ${remainingMonths == 1 ? 'mes' : 'meses'}";
  }

  /// Obtiene la ruta de la imagen del avatar según el género del infante
  String getAvatarImage() {
    // 1. Si tenemos una URL válida del backend, usarla
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return avatarUrl!;
    }

    // 2. Si avatar es un String (ruta local o URL legacy), usarlo
    final value = avatar;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty && trimmed.toLowerCase() != 'null') {
        return trimmed;
      }
    }

    // 3. Fallback al género
    return Child.getAvatarImageByGender(gender);
  }

  /// Método estático para obtener la ruta de la imagen del avatar según el género
  static String getAvatarImageByGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return 'assets/images/anonymous_user.png';
    }
    
    final genderLower = gender.toLowerCase().trim();
    
    if (genderLower == 'masculino') {
      return 'assets/images/boy_1.png';
    } else if (genderLower == 'femenino') {
      return 'assets/images/girl_1.png';
    }
    
    return 'assets/images/anonymous_user.png';
  }

  /// Obtiene el color del avatar según el género del infante
  Color getAvatarColor() {
    return Child.getAvatarColorByGender(gender);
  }

  /// Método estático para obtener el color del avatar según el género
  static Color getAvatarColorByGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return Colors.grey.withOpacity(0.2);
    }
    
    final genderLower = gender.toLowerCase().trim();
    
    if (genderLower == 'masculino') {
      return Colors.blue.withOpacity(0.2);
    } else if (genderLower == 'femenino') {
      return Colors.pinkAccent.withOpacity(0.2);
    }
    
    return Colors.grey.withOpacity(0.2);
  }

  /// Construye el modelo desde un mapa proveniente del API.
  factory Child.fromMap(Map<String, dynamic> map) {
    bool _parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v == '1' || v.toLowerCase() == 'true';
      return false;
    }

    DateTime? _parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) {
        return DateTime.tryParse(v);
      }
      return null;
    }

    List<String> _parseStringList(dynamic v) {
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Manejar estructura anidada del API (data.general, data.medical_record.data, etc.)
    Map<String, dynamic> general = map['general'] as Map<String, dynamic>? ?? {};
    Map<String, dynamic> medicalRecord = (map['medical_record'] as Map<String, dynamic>?)?['data'] as Map<String, dynamic>? ?? {};
    Map<String, dynamic> socialRecord = (map['social_record'] as Map<String, dynamic>?)?['data'] as Map<String, dynamic>? ?? {};
    Map<String, dynamic> activeEnrollment = (map['active_enrollment'] as Map<String, dynamic>?)?['data'] as Map<String, dynamic>? ?? {};
    List<dynamic> familyMembersData = (map['family_members'] as Map<String, dynamic>?)?['data'] as List<dynamic>? ?? [];

    // Parsear housing y transport desde social_record
    Map<String, dynamic> housing = socialRecord['housing'] as Map<String, dynamic>? ?? {};
    Map<String, dynamic> transport = socialRecord['transport'] as Map<String, dynamic>? ?? {};

    // Parsear archivos desde active_enrollment
    Map<String, dynamic>? fileAdmissionRequest = activeEnrollment['file_admission_request'] as Map<String, dynamic>?;
    Map<String, dynamic>? fileCommitment = activeEnrollment['file_commitment'] as Map<String, dynamic>?;
    Map<String, dynamic>? fileBirthCertificate = activeEnrollment['file_birth_certificate'] as Map<String, dynamic>?;
    Map<String, dynamic>? fileVaccinationCard = activeEnrollment['file_vaccination_card'] as Map<String, dynamic>?;
    Map<String, dynamic>? fileParentId = activeEnrollment['file_parent_id'] as Map<String, dynamic>?;
    Map<String, dynamic>? fileUtilityBill = activeEnrollment['file_utility_bill'] as Map<String, dynamic>?;
    Map<String, dynamic>? fileHomeSketch = activeEnrollment['file_home_sketch'] as Map<String, dynamic>?;
    Map<String, dynamic>? filePickupAuthorization = activeEnrollment['file_pickup_authorization'] as Map<String, dynamic>?;

    return Child(
      id: map['id']?.toString(),
      firstName: general['first_name'] ?? map['first_name'] ?? '',
      paternalLastName: general['paternal_last_name'] ?? map['paternal_last_name'] ?? '',
      maternalLastName: general['maternal_last_name'] ?? map['maternal_last_name'],
      gender: general['gender'] ?? map['gender'] ?? '',
      birthDate: _parseDate(general['birth_date'] ?? map['birth_date']),
      address: general['address'] ?? map['address'] ?? '',
      state: general['state'] ?? map['state'] ?? '',
      city: general['city'] ?? map['city'] ?? '',
      municipality: general['municipality'] ?? map['municipality'],
      hasInsurance: _parseBool(medicalRecord['has_insurance'] ?? map['has_insurance']),
      insuranceDetails: medicalRecord['insurance_details'] ?? map['insurance_details'],
      weight: medicalRecord['weight']?.toString() ?? map['weight']?.toString(),
      height: medicalRecord['height']?.toString() ?? map['height']?.toString(),
      hasAllergies: _parseBool(medicalRecord['has_allergies'] ?? map['has_allergies']),
      allergiesDetails: medicalRecord['allergies_details'] ?? map['allergies_details'],
      hasMedicalTreatment: _parseBool(medicalRecord['has_medical_treatment'] ?? map['has_medical_treatment']),
      medicalTreatmentDetails: medicalRecord['medical_treatment_details'] ?? map['medical_treatment_details'],
      hasPsychologicalTreatment: _parseBool(medicalRecord['has_psychological_treatment'] ?? map['has_psychological_treatment']),
      psychologicalTreatmentDetails: medicalRecord['psychological_treatment_details'] ?? map['psychological_treatment_details'],
      hasDeficit: _parseBool(medicalRecord['has_deficit'] ?? map['has_deficit']),
      auditoryDeficit: medicalRecord['deficit_auditory']?.toString() ?? map['deficit_auditory']?.toString(),
      visualDeficit: medicalRecord['deficit_visual']?.toString() ?? map['deficit_visual']?.toString(),
      tactileDeficit: medicalRecord['deficit_tactile']?.toString() ?? map['deficit_tactile']?.toString(),
      motorDeficit: medicalRecord['deficit_motor']?.toString() ?? map['deficit_motor']?.toString(),
      hasDisease: _parseBool(medicalRecord['has_illness'] ?? map['has_illness']),
      diseaseDetails: medicalRecord['illness_details'] ?? map['illness_details'],
      nutritionalProblems: medicalRecord['nutritional_problems'] ?? map['nutritional_problems'],
      outstandingSkills: medicalRecord['outstanding_skills'] ?? map['outstanding_skills'],
      otherConsiderations: medicalRecord['other_observations'] ?? map['other_observations'],
      guardianType: socialRecord['guardian_type']?.toString() ?? map['guardian_type']?.toString(),
      familyMembers: familyMembersData
          .map((e) => FamilyMember.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      housingType: housing['type']?.toString() ?? map['housing_type']?.toString(),
      housingTenure: housing['tenure']?.toString() ?? map['housing_tenure']?.toString(),
      housingStructure: housing['wall_material']?.toString() ?? map['housing_structure']?.toString(),
      floorType: housing['floor_material']?.toString() ?? map['floor_type']?.toString(),
      finishingType: housing['finish']?.toString() ?? map['finishing_type']?.toString(),
      bedrooms: housing['bedrooms']?.toString() ?? map['bedrooms']?.toString(),
      incidentHistory: socialRecord['incident_history']?.toString() ?? map['incident_history']?.toString(),
      pets: socialRecord['pets']?.toString() ?? map['pets']?.toString(),
      rooms: _parseStringList(housing['rooms'] ?? map['rooms']),
      basicServices: _parseStringList(housing['utilities'] ?? map['basic_services']),
      transportMode: transport['type']?.toString() ?? map['transport_type']?.toString(),
      travelTime: transport['travel_time']?.toString() ?? map['travel_time']?.toString(),
      enrollmentDate: _parseDate(activeEnrollment['enrollment_date'] ?? map['enrollment_date']),
      roomId: activeEnrollment['room_id']?.toString() ?? map['room_id']?.toString(),
      enrollmentFiles: map['enrollment_files'] as List<dynamic>?,
      fileBirthCertificate: fileBirthCertificate != null ? [fileBirthCertificate] : (map['file_birth_certificate'] as List<dynamic>?),
      fileAdmissionRequest: fileAdmissionRequest != null ? [fileAdmissionRequest] : (map['file_admission_request'] as List<dynamic>?),
      fileCommitment: fileCommitment != null ? [fileCommitment] : (map['file_commitment'] as List<dynamic>?),
      fileVaccinationCard: fileVaccinationCard != null ? [fileVaccinationCard] : (map['file_vaccination_card'] as List<dynamic>?),
      fileParentId: fileParentId != null ? [fileParentId] : (map['file_parent_id'] as List<dynamic>?),
      fileUtilityBill: fileUtilityBill != null ? [fileUtilityBill] : (map['file_utility_bill'] as List<dynamic>?),
      fileHomeSketch: fileHomeSketch != null ? [fileHomeSketch] : (map['file_home_sketch'] as List<dynamic>?),
      filePickupAuthorization: filePickupAuthorization != null ? [filePickupAuthorization] : (map['file_pickup_authorization'] as List<dynamic>?),
      avatar: null, // El avatar viene en avatarUrl, dejamos este campo solo para nuevos archivos locales
      avatarUrl: general['avatar_url'] ?? map['avatar_url'],
    );
  }

  /// Crea el modelo a partir de los valores actuales del formulario.
  factory Child.fromForm(Map<String, dynamic> values, {String? id}) {
    bool _parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v == '1' || v.toLowerCase() == 'true';
      return false;
    }

    List<String> _parseStringList(dynamic v) {
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return [];
    }

    return Child(
      id: id ?? values['id']?.toString(),
      firstName: values['first_name'] ?? '',
      paternalLastName: values['paternal_last_name'] ?? '',
      maternalLastName: values['maternal_last_name'],
      gender: values['gender'] ?? '',
      birthDate: values['birth_date'],
      address: values['address'] ?? '',
      state: values['state'] ?? '',
      city: values['city'] ?? '',
      municipality: values['municipality'],
      hasInsurance: _parseBool(values['has_insurance']),
      insuranceDetails: values['insurance_details'],
      weight: values['weight']?.toString(),
      height: values['height']?.toString(),
      hasAllergies: _parseBool(values['has_allergies']),
      allergiesDetails: values['allergies_details'],
      hasMedicalTreatment: _parseBool(values['has_medical_treatment']),
      medicalTreatmentDetails: values['medical_treatment_details'],
      hasPsychologicalTreatment: _parseBool(values['has_psychological_treatment']),
      psychologicalTreatmentDetails: values['psychological_treatment_details'],
      hasDeficit: _parseBool(values['has_deficit']),
      auditoryDeficit: values['deficit_auditory']?.toString(),
      visualDeficit: values['deficit_visual']?.toString(),
      tactileDeficit: values['deficit_tactile']?.toString(),
      motorDeficit: values['deficit_motor']?.toString(),
      hasDisease: _parseBool(values['has_illness']),
      diseaseDetails: values['illness_details'],
      nutritionalProblems: values['nutritional_problems'],
      outstandingSkills: values['outstanding_skills'],
      otherConsiderations: values['other_observations'],
      guardianType: values['guardian_type']?.toString(),
      familyMembers: (values['family_members'] as List<dynamic>? ?? [])
          .map((e) => e is FamilyMember ? e : FamilyMember.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      housingType: values['housing_type']?.toString(),
      housingTenure: values['housing_tenure']?.toString(),
      housingStructure: values['housing_structure']?.toString(),
      floorType: values['floor_type']?.toString(),
      finishingType: values['finishing_type']?.toString(),
      bedrooms: values['bedrooms']?.toString(),
      incidentHistory: values['incident_history']?.toString(),
      pets: values['pets']?.toString(),
      rooms: _parseStringList(values['rooms']),
      basicServices: _parseStringList(values['basic_services']),
      transportMode: values['transport_type']?.toString(),
      travelTime: values['travel_time']?.toString(),
      enrollmentDate: values['enrollment_date'],
      roomId: values['room_id']?.toString(),
      enrollmentFiles: values['file_picker'] as List<dynamic>?,
      fileBirthCertificate: values['file_birth_certificate'] as List<dynamic>?,
      fileAdmissionRequest: values['file_admission_request'] as List<dynamic>?,
      fileCommitment: values['file_commitment'] as List<dynamic>?,
      fileVaccinationCard: values['file_vaccination_card'] as List<dynamic>?,
      fileParentId: values['file_parent_id'] as List<dynamic>?,
      fileUtilityBill: values['file_utility_bill'] as List<dynamic>?,
      fileHomeSketch: values['file_home_sketch'] as List<dynamic>?,
      filePickupAuthorization: values['file_pickup_authorization'] as List<dynamic>?,
      avatar: values['avatar'] ?? '',
      avatarUrl: values['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    dynamic _sanitizeFileField(dynamic value) {
      if (value == null) return null;
      if (value is String || value is num || value is bool) return value;
      
      // Lists need to be processed recursively
      if (value is List) {
        final list = value.map((e) => _sanitizeFileField(e)).where((e) => e != null).toList();
        return list.isEmpty ? null : list;
      }

      // Maps need to be processed recursively too
      if (value is Map) {
        final map = <String, dynamic>{};
        value.forEach((k, v) {
          final sanitized = _sanitizeFileField(v);
          if (sanitized != null) {
            map[k.toString()] = sanitized;
          }
        });
        return map.isEmpty ? null : map;
      }

      // Any other type (File, PlatformFile, etc.) is not encodable for JSON storage
      // print('Sanitizing excluded type: ${value.runtimeType}');
      return null;
    }

    return {
      'id': id,
      'first_name': firstName,
      'paternal_last_name': paternalLastName,
      'maternal_last_name': maternalLastName,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String(),
      'address': address,
      'state': state,
      'city': city,
      'municipality': municipality,
      'has_insurance': hasInsurance,
      'insurance_details': insuranceDetails,
      'weight': weight,
      'height': height,
      'has_allergies': hasAllergies,
      'allergies_details': allergiesDetails,
      'has_medical_treatment': hasMedicalTreatment,
      'medical_treatment_details': medicalTreatmentDetails,
      'has_psychological_treatment': hasPsychologicalTreatment,
      'psychological_treatment_details': psychologicalTreatmentDetails,
      'has_deficit': hasDeficit,
      'deficit_auditory': auditoryDeficit,
      'deficit_visual': visualDeficit,
      'deficit_tactile': tactileDeficit,
      'deficit_motor': motorDeficit,
      'has_illness': hasDisease,
      'illness_details': diseaseDetails,
      'nutritional_problems': nutritionalProblems,
      'outstanding_skills': outstandingSkills,
      'other_observations': otherConsiderations,
      'guardian_type': guardianType,
      'family_members': familyMembers.map((e) => e.toMap()).toList(),
      'housing_type': housingType,
      'housing_tenure': housingTenure,
      'housing_structure': housingStructure,
      'floor_type': floorType,
      'finishing_type': finishingType,
      'bedrooms': bedrooms,
      'incident_history': incidentHistory,
      'pets': pets,
      'rooms': rooms,
      'basic_services': basicServices,
      'transport_type': transportMode,
      'travel_time': travelTime,
      'enrollment_date': enrollmentDate?.toIso8601String(),
      'room_id': roomId,
      'enrollment_files': _sanitizeFileField(enrollmentFiles),
      'file_birth_certificate': _sanitizeFileField(fileBirthCertificate),
      'file_admission_request': _sanitizeFileField(fileAdmissionRequest),
      'file_commitment': _sanitizeFileField(fileCommitment),
      'file_vaccination_card': _sanitizeFileField(fileVaccinationCard),
      'file_parent_id': _sanitizeFileField(fileParentId),
      'file_utility_bill': _sanitizeFileField(fileUtilityBill),
      'file_home_sketch': _sanitizeFileField(fileHomeSketch),
      'file_pickup_authorization': _sanitizeFileField(filePickupAuthorization),
      'avatar': _sanitizeFileField(avatar),
      'avatar_url': avatarUrl,
    };
  }

  /// Filtra archivos que vienen del backend (objetos Map) para que no se pasen al formulario
  /// El formulario solo acepta PlatformFile, no objetos Map del backend
  static List<dynamic>? _filterFilesForForm(List<dynamic>? files) {
    if (files == null || files.isEmpty) return null;
    // Si los archivos son objetos Map (vienen del backend), retornar null
    // Solo retornar archivos si son PlatformFile o File (archivos locales seleccionados)
    final filtered = files.where((file) {
      // Si es un Map, es un archivo del backend, no lo incluimos
      if (file is Map) return false;
      // Solo incluir si es PlatformFile o File
      return file.toString().contains('PlatformFile') || file.toString().contains('File');
    }).toList();
    return filtered.isEmpty ? null : filtered;
  }

  /// Mapa listo para rellenar el FormBuilder (sin convertir fechas a string).
  Map<String, dynamic> toFormMap() {
    return {
      'id': id,
      'first_name': firstName,
      'paternal_last_name': paternalLastName,
      'maternal_last_name': maternalLastName,
      'gender': gender,
      'birth_date': birthDate,
      'address': address,
      'state': state,
      'city': city,
      'municipality': municipality,
      'has_insurance': hasInsurance ? '1' : '0',
      'insurance_details': insuranceDetails,
      'weight': weight,
      'height': height,
      'has_allergies': hasAllergies ? '1' : '0',
      'allergies_details': allergiesDetails,
      'has_medical_treatment': hasMedicalTreatment ? '1' : '0',
      'medical_treatment_details': medicalTreatmentDetails,
      'has_psychological_treatment': hasPsychologicalTreatment ? '1' : '0',
      'psychological_treatment_details': psychologicalTreatmentDetails,
      'has_deficit': hasDeficit ? '1' : '0',
      'deficit_auditory': auditoryDeficit,
      'deficit_visual': visualDeficit,
      'deficit_tactile': tactileDeficit,
      'deficit_motor': motorDeficit,
      'has_illness': hasDisease ? '1' : '0',
      'illness_details': diseaseDetails,
      'nutritional_problems': nutritionalProblems,
      'outstanding_skills': outstandingSkills,
      'other_observations': otherConsiderations,
      'guardian_type': guardianType,
      'family_members': familyMembers,
      'housing_type': housingType,
      'housing_tenure': housingTenure,
      'housing_structure': housingStructure,
      'floor_type': floorType,
      'finishing_type': finishingType,
      'bedrooms': bedrooms,
      'incident_history': incidentHistory,
      'pets': pets,
      'rooms': rooms,
      'basic_services': basicServices,
      'transport_type': transportMode,
      'travel_time': travelTime,
      'enrollment_date': enrollmentDate,
      'room_id': roomId,
      // Filtrar archivos del backend (objetos Map) - el formulario solo acepta PlatformFile
      'file_picker': _filterFilesForForm(enrollmentFiles),
      'file_birth_certificate': _filterFilesForForm(fileBirthCertificate),
      'file_admission_request': _filterFilesForForm(fileAdmissionRequest),
      'file_commitment': _filterFilesForForm(fileCommitment),
      'file_vaccination_card': _filterFilesForForm(fileVaccinationCard),
      'file_parent_id': _filterFilesForForm(fileParentId),
      'file_utility_bill': _filterFilesForForm(fileUtilityBill),
      'file_home_sketch': _filterFilesForForm(fileHomeSketch),
      'file_pickup_authorization': _filterFilesForForm(filePickupAuthorization),
      'avatar': avatar,
    };
  }
}


