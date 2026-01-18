import 'dart:io';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ChildService {
  
  // ============ Funciones de mapeo de valores enum ============
  // Normalizan y validan los valores antes de enviarlos al backend
  // Los valores del formulario ya están en el formato correcto, estas funciones
  // solo aseguran normalización (trim, manejo de null/vacío)
  
  static String? _mapGender(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapDeficitLevel(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapGuardianType(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapHousingType(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapHousingTenure(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapTransportType(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapTravelTime(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapKinship(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapMaritalStatus(String? value) => value?.trim().isEmpty == true ? null : value?.trim();
  static String? _mapIncomeType(String? value) => value?.trim().isEmpty == true ? null : value?.trim();

  /// Convierte un archivo (PlatformFile o String path) a MultipartFile
  static Future<MultipartFile?> _fileToMultipartFile(dynamic file, String filename) async {
    try {
      String? filePath;
      
      // Si es PlatformFile
      if (file is PlatformFile) {
        filePath = file.path;
        filename = file.name;
      }
      // Si es String (ruta del archivo)
      else if (file is String) {
        filePath = file;
      }
      // Si es File
      else if (file is File) {
        filePath = file.path;
      }
      else {
        print('⚠️ Tipo de archivo no reconocido: ${file.runtimeType}');
        return null;
      }

      if (filePath == null || filePath.isEmpty) {
        print('⚠️ Ruta de archivo vacía o nula');
        return null;
      }

      final fileObj = File(filePath);
      if (!await fileObj.exists()) {
        print('⚠️ El archivo no existe en la ruta: $filePath');
        return null;
      }

      return await MultipartFile.fromFile(
        filePath,
        filename: filename,
      );
    } catch (e) {
      print('❌ Error convirtiendo archivo a MultipartFile: $e');
      return null;
    }
  }

  ChildService._internal();
  static final ChildService _instance = ChildService._internal();
  static ChildService get instance => _instance;
  factory ChildService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getChildById({required String childId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/children/$childId', 
      headers: {
      'Authorization': 'Bearer $token',
      },
      queryParams: {
        'include': 'medical_record,social_record,family_members,active_enrollment',
      },

    );
    return response;
  }

  Future<ResponseRequest> createChild({required Child child}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final childcareCenter = StorageService.instance.getChildcareCenter();

    // Convertir el modelo Child completo a FormData
    Map<String, dynamic> formDataMap = await _childToFormData(child);

    // Añadir el childcare_center_id del storage
    if (childcareCenter?.id != null) {
      formDataMap['childcare_center_id'] = childcareCenter!.id!;
      print('🏢 DEBUG: childcare_center_id añadido: ${childcareCenter.id}');
    } else {
      print('⚠️  DEBUG: No se encontró childcare_center_id en storage');
    }

    FormData formData = FormData.fromMap(formDataMap);

    print('🔍 DEBUG: Enviando datos del niño:');
    formDataMap.forEach((key, value) {
      if (key == 'childcare_center_id') {
        print('  🏢 $key: $value'); // Resaltar el childcare_center_id
      } else {
        print('     $key: $value');
      }
    });

    final response = await _api.post('/children',
        data: formData,
        headers: {
          'Authorization': 'Bearer $token',
        }
    );

    print('📡 DEBUG: Respuesta de la API:');
    print('  Status: ${response.statusCode}');
    print('  Success: ${response.success}');
    print('  Message: ${response.message}');
    print('  Data: ${response.data}');

    return response;
  }

  Future<ResponseRequest> updateChild({required Child child, Map<String, List<dynamic>?>? originalFiles}) async {
    final token = StorageService.instance.getSession()?.accessToken;

    // Convertir el modelo Child completo a FormData
    // En modo actualización, solo se envían archivos nuevos (no los del backend)
    Map<String, dynamic> formDataMap = await _childToFormData(child, originalFiles: originalFiles);

    FormData formData = FormData.fromMap(formDataMap);

    print('🔍 DEBUG: Enviando datos del niño:');
    formDataMap.forEach((key, value) {
      if (key == 'childcare_center_id') {
        print('  🏢 $key: $value'); // Resaltar el childcare_center_id
      } else {
        print('     $key: $value');
      }
    });

    final response = await _api.post('/children/${child.id}', 
        data: formData, 
        headers: {
          'Authorization': 'Bearer $token',
        }
    );

    return response;
  }

  Future<ResponseRequest> getChildrenByChildcareCenter({required String childcareCenterId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get('/childcare-centers/$childcareCenterId/children', headers: {
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  /// Convierte el modelo Child a Map para FormData con TODOS los campos
  /// [originalFiles] son los archivos originales del backend (objetos Map) - solo se envían archivos nuevos
  Future<Map<String, dynamic>> _childToFormData(Child child, {Map<String, List<dynamic>?>? originalFiles}) async {
    Map<String, dynamic> data = {
      // ✅ Datos de identificación
      'first_name': child.firstName,
      'paternal_last_name': child.paternalLastName,
      'maternal_last_name': child.maternalLastName,
      'gender': _mapGender(child.gender),
      'birth_date': child.birthDate?.toIso8601String(),
      'address': child.address,
      'state': child.state,
      'city': child.city,

      // ✅ Datos médicos
      'has_insurance': child.hasInsurance ? '1' : '0',
      'insurance_details': child.insuranceDetails ?? '',
      'weight': child.weight ?? '',
      'height': child.height ?? '',
      'has_allergies': child.hasAllergies ? '1' : '0',
      'allergies_details': child.allergiesDetails ?? '',
      'has_medical_treatment': child.hasMedicalTreatment ? '1' : '0',
      'medical_treatment_details': child.medicalTreatmentDetails ?? '',
      'has_psychological_treatment': child.hasPsychologicalTreatment ? '1' : '0',
      'psychological_treatment_details': child.psychologicalTreatmentDetails ?? '',
      'has_deficit': child.hasDeficit ? '1' : '0',
      'deficit_auditory': _mapDeficitLevel(child.auditoryDeficit),
      'deficit_visual': _mapDeficitLevel(child.visualDeficit),
      'deficit_tactile': _mapDeficitLevel(child.tactileDeficit),
      'deficit_motor': _mapDeficitLevel(child.motorDeficit),
      'has_illness': child.hasDisease ? '1' : '0',
      'illness_details': child.diseaseDetails ?? '',
      'other_observations': child.otherConsiderations ?? '',
      'guardian_type': _mapGuardianType(child.guardianType),

      // ✅ Datos sociales
      'housing_type': _mapHousingType(child.housingType),
      'housing_tenure': _mapHousingTenure(child.housingTenure),
      'housing_wall_material': child.housingStructure ?? '', // Mapeado desde housing_structure
      'housing_floor_material': child.floorType ?? '', // Mapeado desde floor_type
      'housing_finish': child.finishingType ?? '', // Mapeado desde finishing_type
      'housing_bedrooms': child.bedrooms ?? '', // Mapeado desde bedrooms
      'transport_type': _mapTransportType(child.transportMode),
      'travel_time': _mapTravelTime(child.travelTime),

      // ✅ Datos de inscripción
      'enrollment_date': child.enrollmentDate?.toIso8601String(),
      'room_id': child.roomId,
    };

    // ✅ Enviar housing_rooms como array
    if (child.rooms.isNotEmpty) {
      for (int i = 0; i < child.rooms.length; i++) {
        data['housing_rooms[$i]'] = child.rooms[i];
      }
    }

    // ✅ Enviar housing_utilities como array
    if (child.basicServices.isNotEmpty) {
      for (int i = 0; i < child.basicServices.length; i++) {
        data['housing_utilities[$i]'] = child.basicServices[i];
      }
    }

    /// Verifica si un archivo es nuevo (PlatformFile) o viene del backend (Map)
    bool _isNewFile(dynamic file) {
      // Si es un Map, es un archivo del backend (no se envía en actualización)
      if (file is Map) return false;
      // Si es PlatformFile o File, es un archivo nuevo seleccionado
      return file.toString().contains('PlatformFile') || file.toString().contains('File');
    }

    // ✅ Archivos de inscripción - solo enviar si son nuevos (PlatformFile)
    if (child.enrollmentFiles != null && child.enrollmentFiles!.isNotEmpty) {
      List<MultipartFile> enrollmentMultipartFiles = [];
      for (int i = 0; i < child.enrollmentFiles!.length; i++) {
        final file = child.enrollmentFiles![i];
        // Solo procesar archivos nuevos (no los del backend)
        if (_isNewFile(file)) {
          final multipartFile = await _fileToMultipartFile(file, 'enrollment_file_$i.pdf');
          if (multipartFile != null) {
            enrollmentMultipartFiles.add(multipartFile);
          }
        }
      }
      if (enrollmentMultipartFiles.isNotEmpty) {
        data['enrollment_files[]'] = enrollmentMultipartFiles;
      }
    }

    // ✅ Certificado de nacimiento - solo enviar si es nuevo
    if (child.fileBirthCertificate != null && child.fileBirthCertificate!.isNotEmpty) {
      final file = child.fileBirthCertificate![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_birth_certificate.pdf');
        if (multipartFile != null) {
          data['file_birth_certificate'] = multipartFile;
        }
      }
    }

    // ✅ Archivos adicionales - solo enviar si son nuevos
    if (child.fileAdmissionRequest != null && child.fileAdmissionRequest!.isNotEmpty) {
      final file = child.fileAdmissionRequest![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_admission_request.pdf');
        if (multipartFile != null) {
          data['file_admission_request'] = multipartFile;
        }
      }
    }

    if (child.fileCommitment != null && child.fileCommitment!.isNotEmpty) {
      final file = child.fileCommitment![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_commitment.pdf');
        if (multipartFile != null) {
          data['file_commitment'] = multipartFile;
        }
      }
    }

    if (child.fileVaccinationCard != null && child.fileVaccinationCard!.isNotEmpty) {
      final file = child.fileVaccinationCard![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_vaccination_card.pdf');
        if (multipartFile != null) {
          data['file_vaccination_card'] = multipartFile;
        }
      }
    }

    if (child.fileParentId != null && child.fileParentId!.isNotEmpty) {
      final file = child.fileParentId![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_parent_id.pdf');
        if (multipartFile != null) {
          data['file_parent_id'] = multipartFile;
        }
      }
    }

    if (child.fileUtilityBill != null && child.fileUtilityBill!.isNotEmpty) {
      final file = child.fileUtilityBill![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_utility_bill.pdf');
        if (multipartFile != null) {
          data['file_utility_bill'] = multipartFile;
        }
      }
    }

    if (child.fileHomeSketch != null && child.fileHomeSketch!.isNotEmpty) {
      final file = child.fileHomeSketch![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_home_sketch.pdf');
        if (multipartFile != null) {
          data['file_home_sketch'] = multipartFile;
        }
      }
    }

    if (child.filePickupAuthorization != null && child.filePickupAuthorization!.isNotEmpty) {
      final file = child.filePickupAuthorization![0];
      if (_isNewFile(file)) {
        final multipartFile = await _fileToMultipartFile(file, 'file_pickup_authorization.pdf');
        if (multipartFile != null) {
          data['file_pickup_authorization'] = multipartFile;
        }
      }
    }

    if (child.avatar != null && _isNewFile(child.avatar)) {
      final multipartFile = await _fileToMultipartFile(child.avatar, 'avatar.jpg');
      if (multipartFile != null) {
        data['avatar'] = multipartFile;
      }
    }

    // ✅ Miembros de la familia
    if (child.familyMembers.isNotEmpty) {
      for (int i = 0; i < child.familyMembers.length; i++) {
        final member = child.familyMembers[i];
        data['family_members[$i][first_name]'] = member.firstName;
        data['family_members[$i][last_name]'] = member.lastName;
        data['family_members[$i][relationship]'] = _mapKinship(member.relationship);
        data['family_members[$i][gender]'] = _mapGender(member.gender);
        data['family_members[$i][education_level]'] = member.educationLevel;
        data['family_members[$i][marital_status]'] = _mapMaritalStatus(member.maritalStatus);
        data['family_members[$i][phone]'] = member.phone;
        if (member.profession != null && member.profession!.isNotEmpty) {
          data['family_members[$i][profession]'] = member.profession;
        }
        data['family_members[$i][has_income]'] = member.hasIncome ? '1' : '0';
        data['family_members[$i][workplace]'] = member.workplace;
        data['family_members[$i][income_type]'] = _mapIncomeType(member.incomeType);
        data['family_members[$i][income_total]'] = member.incomeTotal;
        if (member.birthDate != null) {
          data['family_members[$i][birth_date]'] = member.birthDate!.toIso8601String();
        }
      }
    }

    // Limpiar valores null para evitar enviar campos vacíos
    data.removeWhere((key, value) => value == null || (value is String && value.isEmpty));

    return data;
  }


}
