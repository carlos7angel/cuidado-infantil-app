import 'package:cuidado_infantil/Child/controllers/child_options_controller.dart';
import 'package:cuidado_infantil/Child/repositories/child_repository.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_success_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_options_screen.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/repositories/childcare_center_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/models/family_member.dart';
import 'package:cuidado_infantil/Monitoring/models/room.dart';

class ChildFormController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    // Cargar rooms automáticamente al inicializar el controlador
    loadRooms();
  }

  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;
  set fbKey (GlobalKey<FormBuilderState> value) { _fbKey = value; }

  /// Instancia del modelo Child que se mantiene sincronizada con el formulario.
  Child? _currentChild;
  Child? get currentChild => _currentChild;

  dynamic avatar;

  /// Archivos originales del backend (para mostrar en modo edición)
  Map<String, List<dynamic>?> _originalFiles = {};
  Map<String, List<dynamic>?> get originalFiles => _originalFiles;

  /// Valores iniciales del formulario para edición.
  Map<String, dynamic> _initialValues = {};
  Map<String, dynamic> get initialValues => _initialValues;

  /// Identificador del infante cuando se edita.
  String? childId;
  bool isEditing = false;

  final RxBool _isSaving = false.obs;
  bool get isSaving => _isSaving.value;

  final RxBool _hasAttemptedSave = false.obs;
  bool get hasAttemptedSave => _hasAttemptedSave.value;

  final RxList<FamilyMember> _familyMembers = <FamilyMember>[].obs;
  
  /// Mapeo de campos a índices de tabs
  /// Tab 0: Ficha de Identificación
  /// Tab 1: Ficha Médica
  /// Tab 2: Ficha Social
  /// Tab 3: Ficha de Inscripción
  static const Map<int, Set<String>> _tabFields = {
    0: {
      'first_name', 'paternal_last_name', 'maternal_last_name', 
      'gender', 'birth_date', 'address', 'state', 'city', 'municipality'
    },
    1: {
      'has_insurance', 'insurance_details', 'weight', 'height',
      'has_allergies', 'allergies_details', 'has_medical_treatment',
      'medical_treatment_details', 'has_psychological_treatment',
      'psychological_treatment_details', 'has_deficit', 'deficit_auditory',
      'deficit_visual', 'deficit_tactile', 'deficit_motor', 'has_illness',
      'illness_details', 'nutritional_problems', 'outstanding_skills', 'other_observations'
    },
    2: {
      'guardian_type', 'housing_type', 'housing_tenure', 'housing_structure',
      'floor_type', 'finishing_type', 'bedrooms', 'rooms', 'basic_services', 'incident_history', 'pets',
      'transport_type', 'travel_time'
    },
    3: {
      'enrollment_date', 'room_id', 'file_admission_request', 'file_commitment',
      'file_birth_certificate', 'file_vaccination_card', 'file_parent_id',
      'file_utility_bill', 'file_home_sketch', 'file_pickup_authorization'
    },
  };

  /// Mapeo de campos requeridos por tab (campos que tienen validación required)
  static const Map<int, Set<String>> _requiredFields = {
    0: {
      'first_name', 'paternal_last_name', 'maternal_last_name', 
      'gender', 'birth_date', 'address', 'state', 'city'
    },
    1: {
      'has_insurance', 'weight', 'height'
    },
    2: {
      'guardian_type'
    },
    3: {
      'enrollment_date', 'room_id'
    },
  };

  static const Map<int, String> _tabNames = {
    0: 'Ficha de Identificación',
    1: 'Ficha Médica',
    2: 'Ficha Social',
    3: 'Ficha de Inscripción',
  };
  List<FamilyMember> get familyMembers => _familyMembers;

  final RxList<Room> _rooms = <Room>[].obs;
  List<Room> get rooms => _rooms;

  final RxBool _isLoadingRooms = false.obs;
  bool get isLoadingRooms => _isLoadingRooms.value;

  /// Obtiene el room seleccionado actualmente
  Room? getSelectedRoom(String? roomId) {
    if (roomId == null) return null;
    return _rooms.firstWhereOrNull((room) => room.id == roomId);
  }

  /// Refresca la lista de rooms (útil para forzar recarga)
  Future<void> refreshRooms() async {
    _rooms.clear();
    await loadRooms();
  }

  void addFamilyMember(FamilyMember member) {
    _familyMembers.add(member);
    update(['family_members']);
  }

  void updateFamilyMember(int index, FamilyMember member) {
    if (index >= 0 && index < _familyMembers.length) {
      _familyMembers[index] = member;
      update(['family_members']);
    }
  }

  void removeFamilyMember(int index) {
    if (index >= 0 && index < _familyMembers.length) {
      _familyMembers.removeAt(index);
      update(['family_members']);
    }
  }

  void setAvatar(dynamic file) {
    avatar = file;
    if (_currentChild == null) _currentChild = Child.empty();
    _currentChild = _currentChild!.copyWith(avatar: file);
    update(['form_child']);
  }

  /// Carga los grupos/rooms desde el endpoint
  Future<void> loadRooms() async {
    if (_rooms.isNotEmpty) return;

    _isLoadingRooms.value = true;
    update(['rooms_dropdown']);

    // Usar el servicio para cargar rooms
    final response = await ChildcareCenterRepository().getCurrentChildcareCenter();
    if (!response.success) {
      CustomSnackBar(context: Get.overlayContext!).show(message: 'No se pudieron cargar los grups. ${response.message}');
      return;
    }

    final childcareCenterData = response.data['data'] as Map<String, dynamic>;
    final roomsData = childcareCenterData['active_rooms']?['data'] as List?;
    List<Room> rooms = [];
    if (roomsData != null && roomsData.isNotEmpty) {
      rooms = roomsData.map((json) => Room.fromMap(json)).toList();
    }
    _rooms.assignAll(rooms);

    _isLoadingRooms.value = false;
    update(['rooms_dropdown']);
  }

  /// Permite cargar datos existentes para modo edición.
  Future<void> setInitialData(Map<String, dynamic> data, {List<FamilyMember>? members, String? id, Child? child}) async {
    if (child != null) {
      _currentChild = child;
      _initialValues = child.toFormMap();
      childId = child.id;
      _familyMembers
        ..clear()
        ..addAll(child.familyMembers);
      
      // Guardar archivos originales del backend para mostrarlos en el formulario
      _originalFiles = {
        'file_admission_request': child.fileAdmissionRequest,
        'file_commitment': child.fileCommitment,
        'file_birth_certificate': child.fileBirthCertificate,
        'file_vaccination_card': child.fileVaccinationCard,
        'file_parent_id': child.fileParentId,
        'file_utility_bill': child.fileUtilityBill,
        'file_home_sketch': child.fileHomeSketch,
        'file_pickup_authorization': child.filePickupAuthorization,
        'file_picker': child.enrollmentFiles,
      };
    } else {
      // Si no hay Child, crear uno vacío y poblar desde el Map
      _currentChild = Child.empty();
      _initialValues = {...data};
      // Si no hay fecha de inscripción, establecer la fecha de hoy
      if (!_initialValues.containsKey('enrollment_date') || _initialValues['enrollment_date'] == null) {
        _initialValues['enrollment_date'] = DateTime.now();
      }
      childId = id ?? data['id'] as String?;
      if (members != null) {
        _familyMembers
          ..clear()
          ..addAll(members);
      }
      // Actualizar el currentChild con los datos del Map
      _updateChildFromFormData(data);
    }
    isEditing = childId != null;

    update(['family_members']);

    // Asegurar que las rooms se carguen antes de establecer el valor inicial del room_id
    if (_rooms.isEmpty) {
      await loadRooms();
    }

    // Si hay un room_id en initialValues, verificar que esté en la lista de rooms
    if (_initialValues.containsKey('room_id') && _initialValues['room_id'] != null) {
      final roomId = _initialValues['room_id'].toString();
      final roomExists = _rooms.any((room) => room.id == roomId);
      if (!roomExists) {
        // Si el room no existe en la lista, remover el valor inicial temporalmente
        // El usuario tendrá que seleccionarlo manualmente
        print('⚠️ WARNING: room_id $roomId no encontrado en la lista de rooms');
        _initialValues['room_id'] = null;
      }
    }

    // Aplica los valores al formulario cuando esté disponible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_fbKey.currentState != null && _initialValues.isNotEmpty) {
        _fbKey.currentState?.patchValue(_initialValues);
      }
    });
    update(['form_child', 'rooms_dropdown']);
  }

  /// Actualiza el currentChild con datos del formulario.
  /// Solo actualiza campos que están presentes en formData (preserva los demás)
  void _updateChildFromFormData(Map<String, dynamic> formData) {
    if (_currentChild == null) _currentChild = Child.empty();

    // Helper para obtener valor solo si está presente en formData
    T? _getIfPresent<T>(String key, T? Function(dynamic) converter) {
      if (formData.containsKey(key)) {
        return converter(formData[key]);
      }
      return null; // copyWith preservará el valor existente
    }

    _currentChild = _currentChild!.copyWith(
      id: childId ?? _currentChild!.id,
      // Solo actualizar campos que están presentes en formData
      // copyWith preservará los valores existentes si el parámetro es null
      firstName: _getIfPresent('first_name', (v) => v as String?),
      paternalLastName: _getIfPresent('paternal_last_name', (v) => v as String?),
      maternalLastName: _getIfPresent('maternal_last_name', (v) => v as String?),
      gender: _getIfPresent('gender', (v) => v as String?),
      birthDate: _getIfPresent('birth_date', (v) => v as DateTime?),
      address: _getIfPresent('address', (v) => v as String?),
      state: _getIfPresent('state', (v) => v as String?),
      city: _getIfPresent('city', (v) => v as String?),
      municipality: _getIfPresent('municipality', (v) => v as String?),
      hasInsurance: _getIfPresent('has_insurance', (v) => v == '1'),
      insuranceDetails: _getIfPresent('insurance_details', (v) => v as String?),
      weight: _getIfPresent('weight', (v) => v?.toString()),
      height: _getIfPresent('height', (v) => v?.toString()),
      hasAllergies: _getIfPresent('has_allergies', (v) => v == '1'),
      allergiesDetails: _getIfPresent('allergies_details', (v) => v as String?),
      hasMedicalTreatment: _getIfPresent('has_medical_treatment', (v) => v == '1'),
      medicalTreatmentDetails: _getIfPresent('medical_treatment_details', (v) => v as String?),
      hasPsychologicalTreatment: _getIfPresent('has_psychological_treatment', (v) => v == '1'),
      psychologicalTreatmentDetails: _getIfPresent('psychological_treatment_details', (v) => v as String?),
      hasDeficit: _getIfPresent('has_deficit', (v) => v == '1'),
      auditoryDeficit: _getIfPresent('deficit_auditory', (v) => v?.toString()),
      visualDeficit: _getIfPresent('deficit_visual', (v) => v?.toString()),
      tactileDeficit: _getIfPresent('deficit_tactile', (v) => v?.toString()),
      motorDeficit: _getIfPresent('deficit_motor', (v) => v?.toString()),
      hasDisease: _getIfPresent('has_illness', (v) => v == '1'),
      diseaseDetails: _getIfPresent('illness_details', (v) => v as String?),
      nutritionalProblems: _getIfPresent('nutritional_problems', (v) => v as String?),
      outstandingSkills: _getIfPresent('outstanding_skills', (v) => v as String?),
      otherConsiderations: _getIfPresent('other_observations', (v) => v as String?),
      guardianType: _getIfPresent('guardian_type', (v) => v?.toString()),
      housingType: _getIfPresent('housing_type', (v) => v?.toString()),
      housingTenure: _getIfPresent('housing_tenure', (v) => v?.toString()),
      housingStructure: _getIfPresent('housing_structure', (v) => v?.toString()),
      floorType: _getIfPresent('floor_type', (v) => v?.toString()),
      finishingType: _getIfPresent('finishing_type', (v) => v?.toString()),
      bedrooms: _getIfPresent('bedrooms', (v) => v?.toString()),
      rooms: _getIfPresent('rooms', (v) => v as List<String>?),
      basicServices: _getIfPresent('basic_services', (v) => v as List<String>?),
      transportMode: _getIfPresent('transport_type', (v) => v?.toString()),
      travelTime: _getIfPresent('travel_time', (v) => v?.toString()),
      incidentHistory: _getIfPresent('incident_history', (v) => v as String?),
      pets: _getIfPresent('pets', (v) => v as String?),
      enrollmentDate: _getIfPresent('enrollment_date', (v) => v as DateTime?),
      roomId: _getIfPresent('room_id', (v) => v?.toString()),
      enrollmentFiles: _getIfPresent('file_picker', (v) => v as List<dynamic>?),
      fileBirthCertificate: _getIfPresent('file_birth_certificate', (v) => v as List<dynamic>?),
      fileAdmissionRequest: _getIfPresent('file_admission_request', (v) => v as List<dynamic>?),
      fileCommitment: _getIfPresent('file_commitment', (v) => v as List<dynamic>?),
      fileVaccinationCard: _getIfPresent('file_vaccination_card', (v) => v as List<dynamic>?),
      fileParentId: _getIfPresent('file_parent_id', (v) => v as List<dynamic>?),
      fileUtilityBill: _getIfPresent('file_utility_bill', (v) => v as List<dynamic>?),
      fileHomeSketch: _getIfPresent('file_home_sketch', (v) => v as List<dynamic>?),
      filePickupAuthorization: _getIfPresent('file_pickup_authorization', (v) => v as List<dynamic>?),
      familyMembers: _familyMembers.isNotEmpty ? _familyMembers.toList() : null,
    );
  }

  /// Actualiza un campo específico del currentChild.
  void updateChildField(String field, dynamic value) {
    if (_currentChild == null) _currentChild = Child.empty();

    switch (field) {
      case 'first_name':
        _currentChild = _currentChild!.copyWith(firstName: value);
        break;
      case 'paternal_last_name':
        _currentChild = _currentChild!.copyWith(paternalLastName: value);
        break;
      case 'maternal_last_name':
        _currentChild = _currentChild!.copyWith(maternalLastName: value);
        break;
      case 'gender':
        _currentChild = _currentChild!.copyWith(gender: value);
        break;
      case 'birth_date':
        _currentChild = _currentChild!.copyWith(birthDate: value);
        break;
      case 'address':
        _currentChild = _currentChild!.copyWith(address: value);
        break;
      case 'state':
        _currentChild = _currentChild!.copyWith(state: value);
        break;
      case 'city':
        _currentChild = _currentChild!.copyWith(city: value);
        break;
      case 'municipality':
        _currentChild = _currentChild!.copyWith(municipality: value);
        break;
      case 'has_insurance':
        _currentChild = _currentChild!.copyWith(hasInsurance: value == '1');
        break;
      case 'insurance_details':
        _currentChild = _currentChild!.copyWith(insuranceDetails: value);
        break;
      case 'weight':
        _currentChild = _currentChild!.copyWith(weight: value?.toString());
        break;
      case 'height':
        _currentChild = _currentChild!.copyWith(height: value?.toString());
        break;
      case 'has_allergies':
        _currentChild = _currentChild!.copyWith(hasAllergies: value == '1');
        break;
      case 'allergies_details':
        _currentChild = _currentChild!.copyWith(allergiesDetails: value);
        break;
      case 'has_medical_treatment':
        _currentChild = _currentChild!.copyWith(hasMedicalTreatment: value == '1');
        break;
      case 'medical_treatment_details':
        _currentChild = _currentChild!.copyWith(medicalTreatmentDetails: value);
        break;
      case 'has_psychological_treatment':
        _currentChild = _currentChild!.copyWith(hasPsychologicalTreatment: value == '1');
        break;
      case 'psychological_treatment_details':
        _currentChild = _currentChild!.copyWith(psychologicalTreatmentDetails: value);
        break;
      case 'has_deficit':
        _currentChild = _currentChild!.copyWith(hasDeficit: value == '1');
        break;
      case 'deficit_auditory':
        _currentChild = _currentChild!.copyWith(auditoryDeficit: value?.toString());
        break;
      case 'deficit_visual':
        _currentChild = _currentChild!.copyWith(visualDeficit: value?.toString());
        break;
      case 'deficit_tactile':
        _currentChild = _currentChild!.copyWith(tactileDeficit: value?.toString());
        break;
      case 'deficit_motor':
        _currentChild = _currentChild!.copyWith(motorDeficit: value?.toString());
        break;
      case 'has_illness':
        _currentChild = _currentChild!.copyWith(hasDisease: value == '1');
        break;
      case 'illness_details':
        _currentChild = _currentChild!.copyWith(diseaseDetails: value);
        break;
      case 'nutritional_problems':
        _currentChild = _currentChild!.copyWith(nutritionalProblems: value);
        break;
      case 'outstanding_skills':
        _currentChild = _currentChild!.copyWith(outstandingSkills: value);
        break;
      case 'other_observations':
        _currentChild = _currentChild!.copyWith(otherConsiderations: value);
        break;
      case 'guardian_type':
        _currentChild = _currentChild!.copyWith(guardianType: value?.toString());
        break;
      case 'housing_type':
        _currentChild = _currentChild!.copyWith(housingType: value);
        break;
      case 'housing_tenure':
        _currentChild = _currentChild!.copyWith(housingTenure: value);
        break;
      case 'housing_structure':
        _currentChild = _currentChild!.copyWith(housingStructure: value);
        break;
      case 'floor_type':
        _currentChild = _currentChild!.copyWith(floorType: value);
        break;
      case 'finishing_type':
        _currentChild = _currentChild!.copyWith(finishingType: value);
        break;
      case 'bedrooms':
        _currentChild = _currentChild!.copyWith(bedrooms: value?.toString());
        break;
      case 'rooms':
        _currentChild = _currentChild!.copyWith(rooms: value);
        break;
      case 'basic_services':
        _currentChild = _currentChild!.copyWith(basicServices: value);
        break;
      case 'transport_type':
        _currentChild = _currentChild!.copyWith(transportMode: value);
        break;
      case 'incident_history':
        _currentChild = _currentChild!.copyWith(incidentHistory: value);
        break;
      case 'pets':
        _currentChild = _currentChild!.copyWith(pets: value);
        break;
      case 'travel_time':
        _currentChild = _currentChild!.copyWith(travelTime: value);
        break;
      case 'enrollment_date':
        _currentChild = _currentChild!.copyWith(enrollmentDate: value);
        break;
      case 'room_id':
        _currentChild = _currentChild!.copyWith(roomId: value);
        break;
      case 'file_picker':
        _currentChild = _currentChild!.copyWith(enrollmentFiles: value);
        break;
      case 'file_birth_certificate':
        _currentChild = _currentChild!.copyWith(fileBirthCertificate: value);
        break;
      case 'file_admission_request':
        _currentChild = _currentChild!.copyWith(fileAdmissionRequest: value);
        break;
      case 'file_commitment':
        _currentChild = _currentChild!.copyWith(fileCommitment: value);
        break;
      case 'file_vaccination_card':
        _currentChild = _currentChild!.copyWith(fileVaccinationCard: value);
        break;
      case 'file_parent_id':
        _currentChild = _currentChild!.copyWith(fileParentId: value);
        break;
      case 'file_utility_bill':
        _currentChild = _currentChild!.copyWith(fileUtilityBill: value);
        break;
      case 'file_home_sketch':
        _currentChild = _currentChild!.copyWith(fileHomeSketch: value);
        break;
      case 'file_pickup_authorization':
        _currentChild = _currentChild!.copyWith(filePickupAuthorization: value);
        break;
      case 'avatar':
        setAvatar(value);
        break;
    }
  }

  /// Devuelve el Child actualizado con los datos del formulario.
  /// Usa _currentChild como base (se mantiene actualizado con todos los cambios)
  /// y actualiza con los valores del formulario actual para asegurar sincronización
  Child? collectFormData() {
    final formState = _fbKey.currentState;
    if (formState == null) {
      print('❌ DEBUG: FormBuilderState es null');
      return null;
    }

    // Guardar todos los valores del formulario primero
    formState.save();

    // Si _currentChild es null, inicializarlo
    if (_currentChild == null) {
      _currentChild = Child.empty();
    }

    // Obtener valores del formulario actual (solo del tab visible)
    final formValues = Map<String, dynamic>.from(formState.value);
    
    // Actualizar _currentChild con los valores del formulario actual
    // Esto asegura que los campos del tab actual se actualicen
    // Los campos de otros tabs se preservan porque copyWith usa null para preservar
    _updateChildFromFormData(formValues);

    // Asegurar que los miembros de la familia estén actualizados
    final updatedChild = _currentChild!.copyWith(
      familyMembers: _familyMembers.toList(),
      id: childId ?? _currentChild!.id,
    );

    print('📝 DEBUG: Child recopilado desde _currentChild:');
    print('  ID: ${updatedChild.id}');
    print('  Nombre: ${updatedChild.firstName} ${updatedChild.paternalLastName}');
    print('  Peso: ${updatedChild.weight ?? "null"}');
    print('  Altura: ${updatedChild.height ?? "null"}');
    print('  Guardian Type: ${updatedChild.guardianType ?? "null"}');
    print('  Housing Type: ${updatedChild.housingType ?? "null"}');
    print('  Housing Tenure: ${updatedChild.housingTenure ?? "null"}');
    print('  Housing Structure: ${updatedChild.housingStructure ?? "null"}');
    print('  Floor Type: ${updatedChild.floorType ?? "null"}');
    print('  Finishing Type: ${updatedChild.finishingType ?? "null"}');
    print('  Bedrooms: ${updatedChild.bedrooms ?? "null"}');
    print('  Transport Type: ${updatedChild.transportMode ?? "null"}');
    print('  Travel Time: ${updatedChild.travelTime ?? "null"}');
    print('  Rooms: ${updatedChild.rooms}');
    print('  Basic Services: ${updatedChild.basicServices}');
    print('  Insurance Details: ${updatedChild.insuranceDetails ?? "null"}');
    print('  Allergies Details: ${updatedChild.allergiesDetails ?? "null"}');
    print('  Medical Treatment Details: ${updatedChild.medicalTreatmentDetails ?? "null"}');
    print('  Psychological Treatment Details: ${updatedChild.psychologicalTreatmentDetails ?? "null"}');
    print('  Disease Details: ${updatedChild.diseaseDetails ?? "null"}');
    print('  Other Observations: ${updatedChild.otherConsiderations ?? "null"}');
    print('  Miembros familia: ${updatedChild.familyMembers.length}');
    print('  Grupo: ${updatedChild.roomId}');

    return updatedChild;
  }

  /// Valida todos los campos del formulario y retorna información sobre tabs con errores
  /// Retorna un Map con: 'isValid' (bool) y 'tabsWithErrors' (List<int>)
  Map<String, dynamic> _validateAllFieldsWithTabs() {
    final formState = _fbKey.currentState;
    if (formState == null) {
      print('❌ DEBUG: FormBuilderState es null');
      return {'isValid': false, 'tabsWithErrors': []};
    }

    // Guardar todos los valores primero
    formState.save();

    print('🔍 DEBUG: Iniciando validación de todos los campos');
    print('📋 DEBUG: Total de campos registrados: ${formState.fields.length}');
    print('📋 DEBUG: Campos registrados: ${formState.fields.keys.toList()}');

    // Validar TODOS los campos manualmente, incluso los de tabs no visibles
    Set<int> tabsWithErrors = {};
    bool hasErrors = false;
    
    // Primero, intentar usar saveAndValidate para validar todo
    final globalValid = formState.saveAndValidate();
    print('🔍 DEBUG: saveAndValidate() retornó: $globalValid');
    
    // Iterar sobre todos los campos conocidos de todos los tabs
    for (int tabIndex = 0; tabIndex < _tabFields.length; tabIndex++) {
      final tabFields = _tabFields[tabIndex]!;
      bool tabHasErrors = false;
      
      print('🔍 DEBUG: Validando tab $tabIndex con ${tabFields.length} campos');
      
      for (String fieldName in tabFields) {
        final field = formState.fields[fieldName];
        if (field != null) {
          // Forzar validación del campo
          final fieldValue = formState.value[fieldName];
          
          // Si está en modo edición y el campo tiene valor inicial, verificar primero
          // antes de validar para evitar falsos negativos
          if (isEditing && _initialValues.containsKey(fieldName)) {
            final initialValue = _initialValues[fieldName];
            // Si el campo tiene un valor inicial válido y no se ha modificado,
            // considerarlo válido sin necesidad de validar
            if (initialValue != null && 
                initialValue.toString().isNotEmpty && 
                (fieldValue == null || fieldValue.toString().isEmpty || fieldValue == initialValue)) {
              print('✅ Campo válido en tab $tabIndex (valor inicial): $fieldName');
              continue; // Saltar validación, ya tiene valor inicial
            }
          }
          
          field.didChange(fieldValue);
          
          // Validar el campo
          final fieldValid = field.validate();
          if (!fieldValid) {
            hasErrors = true;
            tabHasErrors = true;
            tabsWithErrors.add(tabIndex);
            print('❌ Campo inválido en tab $tabIndex: $fieldName');
            print('   Valor: $fieldValue');
            print('   Error: ${field.errorText}');
          } else {
            print('✅ Campo válido en tab $tabIndex: $fieldName');
          }
        } else {
          // Campo no registrado - puede ser que el tab no se haya renderizado aún
          print('⚠️ Campo $fieldName del tab $tabIndex NO está registrado en el formulario');
          
          // Verificar si tiene valor en el formState o en valores iniciales
          final fieldValue = formState.value[fieldName] ?? (isEditing ? _initialValues[fieldName] : null);
          print('   Valor en formState: ${formState.value[fieldName]}');
          print('   Valor inicial: ${isEditing ? _initialValues[fieldName] : null}');
          
          // Si el campo es requerido y no tiene valor, marcarlo como error
          final requiredFields = _requiredFields[tabIndex];
          if (requiredFields != null && requiredFields.contains(fieldName)) {
            final isEmpty = fieldValue == null || 
                           (fieldValue is String && fieldValue.trim().isEmpty) ||
                           (fieldValue is List && fieldValue.isEmpty);
            
            if (isEmpty) {
              hasErrors = true;
              tabHasErrors = true;
              tabsWithErrors.add(tabIndex);
              print('❌ Campo requerido $fieldName del tab $tabIndex está vacío (no registrado)');
            } else {
              print('✅ Campo requerido $fieldName del tab $tabIndex tiene valor inicial válido');
            }
          }
        }
      }
      
      if (tabHasErrors) {
        print('❌ Tab $tabIndex tiene errores');
      } else {
        print('✅ Tab $tabIndex está completo');
      }
    }
    
    // También validar campos que puedan estar registrados pero no en nuestro mapeo
    formState.fields.forEach((fieldName, field) {
      // Solo validar si no lo hemos validado ya
      bool alreadyValidated = false;
      for (int tabIndex = 0; tabIndex < _tabFields.length; tabIndex++) {
        if (_tabFields[tabIndex]!.contains(fieldName)) {
          alreadyValidated = true;
          break;
        }
      }
      
      if (!alreadyValidated) {
        final fieldValue = formState.value[fieldName];
        field.didChange(fieldValue);
        if (!field.validate()) {
          hasErrors = true;
          print('❌ Campo inválido (no mapeado): $fieldName - Error: ${field.errorText}');
        }
      }
    });
    
    print('📊 DEBUG: Resultado final de validación:');
    print('   hasErrors: $hasErrors');
    print('   tabsWithErrors: ${tabsWithErrors.toList()}');
    
    return {
      'isValid': !hasErrors,
      'tabsWithErrors': tabsWithErrors.toList()..sort(),
    };
  }


  /// Muestra un modal indicando qué tabs tienen errores y permite navegar a ellos
  void _showTabsWithErrorsModal(List<int> tabsWithErrors, Function(int) onNavigateToTab) {
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) return;

    NDialog dialog = NDialog(
      title: Text(
        "Campos obligatorios pendientes",
        style: Theme.of(overlayContext).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.orange[700]),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 64.sp,
            color: Colors.orange[700],
          ),
          SizedBox(height: 20.h),
          Text(
            "Hay campos obligatorios que deben completarse en las siguientes fichas:",
            style: Theme.of(overlayContext).textTheme.bodyMedium?.merge(
              TextStyle(color: config.Colors().gray99Color(1), fontSize: 14.sp),
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 15.h),
          ...tabsWithErrors.map((tabIndex) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Theme.of(overlayContext).colorScheme.secondary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _tabNames[tabIndex] ?? 'Tab $tabIndex',
                    style: Theme.of(overlayContext).textTheme.bodyMedium?.merge(
                      TextStyle(
                        color: config.Colors().gray99Color(1),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 10.h),
          Text(
            "¿Desea ir a la primera ficha con campos pendientes?",
            style: Theme.of(overlayContext).textTheme.bodySmall?.merge(
              TextStyle(color: config.Colors().gray99Color(0.8), fontSize: 12.sp),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      dialogStyle: DialogStyle(
        titlePadding: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 30.w, right: 30.w),
        contentPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
        elevation: 0,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            overlayColor: Colors.grey.withOpacity(0.2),
          ),
          child: Text(
            "Cancelar",
            style: TextStyle(
              color: config.Colors().gray99Color(1),
              fontSize: 14.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onNavigateToTab(tabsWithErrors.first);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            overlayColor: Colors.grey.withOpacity(0.2),
          ),
          child: Text(
            "Ir a la ficha",
            style: TextStyle(
              color: Theme.of(overlayContext).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
    dialog.show(overlayContext, dismissable: true);
  }

  /// Callback para navegar a un tab específico (se establece desde la pantalla)
  Function(int)? onNavigateToTab;

  /// Callback para obtener el tab actual (se establece desde la pantalla)
  Function()? onGetCurrentTab;

  /// Valida solo los campos de un tab específico
  bool _validateTab(int tabIndex) {
    final formState = _fbKey.currentState;
    if (formState == null) return false;

    final tabFields = _tabFields[tabIndex];
    if (tabFields == null) return true;

    formState.save();

    bool isValid = true;
    
    // Validar todos los campos del formulario y filtrar solo los del tab actual
    formState.fields.forEach((fieldName, field) {
      // Solo validar campos que pertenecen a este tab
      if (tabFields.contains(fieldName)) {
        final fieldValue = formState.value[fieldName];
        field.didChange(fieldValue);
        if (!field.validate()) {
          isValid = false;
          print('❌ Campo inválido en tab $tabIndex: $fieldName - Error: ${field.errorText}');
        }
      }
    });

    return isValid;
  }

  /// Punto único para guardar; aquí solo se arma el payload.
  Future<void> saveChild({int? currentTabIndex}) async {
    print('🚀 DEBUG: Iniciando proceso de guardar niño');

    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      print('❌ DEBUG: overlayContext es null');
      return;
    }

    final customDialog = CustomDialog(context: overlayContext);

    // Marcar que se ha intentado guardar
    _hasAttemptedSave.value = true;
    update(['form_child']);

    // Obtener el tab actual si no se pasó como parámetro
    int? activeTabIndex = currentTabIndex;
    if (activeTabIndex == null && onGetCurrentTab != null) {
      activeTabIndex = onGetCurrentTab!();
    }

    // Si no podemos determinar el tab actual, validar todos
    if (activeTabIndex == null) {
      print('⚠️ DEBUG: No se pudo determinar el tab actual, validando todos');
      final validationResult = _validateAllFieldsWithTabs();
      if (!validationResult['isValid']) {
        customDialog.hide();
        CustomSnackBar(context: overlayContext).show(
          message: 'Por favor, complete todos los campos obligatorios'
        );
        return;
      }
    } else {
      // Primero validar el tab actual
      print('🔍 DEBUG: Validando tab actual: $activeTabIndex');
      final currentTabValid = _validateTab(activeTabIndex);
      
      if (!currentTabValid) {
        print('❌ DEBUG: El tab actual ($activeTabIndex) tiene errores');
        customDialog.hide();
        // No mostrar modal, solo validación normal del tab actual
        CustomSnackBar(context: overlayContext).show(
          message: 'Por favor, complete todos los campos obligatorios en la ficha actual'
        );
        return;
      }

      print('✅ DEBUG: Tab actual está completo, validando otros tabs');
      
      // Si el tab actual está completo, validar todos los otros tabs
      final validationResult = _validateAllFieldsWithTabs();
      
      print('📊 DEBUG: Resultado de validación completa:');
      print('  isValid: ${validationResult['isValid']}');
      print('  tabsWithErrors: ${validationResult['tabsWithErrors']}');
      
      if (!validationResult['isValid']) {
        print('❌ DEBUG: Hay errores en otros tabs');
        customDialog.hide();
        
        final tabsWithErrors = validationResult['tabsWithErrors'] as List<int>;
        print('📋 DEBUG: Tabs con errores: $tabsWithErrors');
        print('📋 DEBUG: Tab actual: $activeTabIndex');
        
        // Filtrar solo los tabs que NO son el actual
        final otherTabsWithErrors = tabsWithErrors.where((index) => index != activeTabIndex).toList();
        print('📋 DEBUG: Otros tabs con errores (filtrados): $otherTabsWithErrors');
        
        if (otherTabsWithErrors.isNotEmpty && onNavigateToTab != null) {
          // Mostrar modal solo si hay errores en otros tabs
          print('✅ DEBUG: Mostrando modal para tabs: $otherTabsWithErrors');
          _showTabsWithErrorsModal(otherTabsWithErrors, onNavigateToTab!);
        } else if (otherTabsWithErrors.isNotEmpty) {
          // Fallback a snackbar si no hay callback
          print('⚠️ DEBUG: Hay errores pero no hay callback de navegación');
          CustomSnackBar(context: overlayContext).show(
            message: 'Por favor, complete todos los campos obligatorios en las demás fichas'
          );
        } else {
          // Si todos los errores están en el tab actual (no debería pasar aquí)
          print('⚠️ DEBUG: Todos los errores están en el tab actual, esto no debería pasar');
          CustomSnackBar(context: overlayContext).show(
            message: 'Por favor, complete todos los campos obligatorios'
          );
        }
        return;
      }
    }
    
    print('✅ DEBUG: Todos los tabs están completos');

    // Recopilar datos
    final child = collectFormData();
    if (child == null) {
      print('❌ DEBUG: No se pudo crear el modelo Child');
      return;
    }

    // Mostrar loading
    customDialog.show();
    print('⏳ DEBUG: Mostrando dialog de carga');

    try {
      // Enviar a API - detectar si es creación o edición
      ResponseRequest response;
      
      if (isEditing && childId != null) {
        // Modo edición
        print('📡 DEBUG: Actualizando child existente (ID: $childId)...');
        response = await ChildRepository().updateChild(
          child: child,
          originalFiles: _originalFiles,
        );
      } else {
        // Modo creación
        print('📡 DEBUG: Creando nuevo child...');
        response = await ChildRepository().createChild(child: child);
      }

      // Procesar respuesta
      if (!response.success) {
        print('❌ DEBUG: API retornó error');
        print('  Message: ${response.message}');
        customDialog.hide();
        CustomSnackBar(context: Get.overlayContext!).show(message: response.message);
        return;
      }

      print('✅ DEBUG: API retornó éxito ');
      print('  Message: ${response.message}');
      // customDialog.hide(); // NO ocultar aquí para evitar parpadeo o espera sin feedback

      // Navegar según el modo
      if (isEditing && childId != null) {
        // En modo edición, guardar el child actualizado y mostrar modal de confirmación
        // Actualizar el child en storage con los datos actualizados antes de limpiar
        await StorageService.instance.setSelectedChild(child);
        print('💾 DEBUG: Child actualizado guardado en storage');

        // Actualizar el estado en ChildOptionsController para reflejar los cambios en la vista de detalles
        try {
          if (Get.isRegistered<ChildOptionsController>()) {
            await Get.find<ChildOptionsController>().refreshChildDetails();
            print('🔄 DEBUG: ChildOptionsController refrescado con los nuevos datos');
          }
        } catch (e) {
          print('⚠️ DEBUG: No se pudo refrescar ChildOptionsController: $e');
        }
        
        // Limpiar formulario después de éxito
        clearForm();
        print('🧹 DEBUG: Formulario limpiado después del éxito');
        
        customDialog.hide(); // Ocultar justo antes de mostrar el modal de éxito
        
        // Mostrar modal de confirmación que navegará al detalle
        _showUpdateSuccessModal();
      } else {
        // En modo creación, limpiar formulario e ir a la pantalla de éxito
        clearForm();
        print('🧹 DEBUG: Formulario limpiado después del éxito');
        customDialog.hide(); // Ocultar antes de navegar
        Get.offNamed(ChildSuccessScreen.routeName);
      }

    } catch (e) {
      print('💥 DEBUG: Error inesperado : $e');
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Error inesperado al guardar el infante'
      );
    }
  }

  void clearForm() {
    _fbKey.currentState?.reset();
    _familyMembers.clear();
    _currentChild = null;
    _initialValues = {};
    childId = null;
    isEditing = false;
    avatar = null;
    _hasAttemptedSave.value = false;
    update(['family_members', 'form_child']);
  }

  /// Muestra un modal de confirmación después de actualizar un child exitosamente
  void _showUpdateSuccessModal() {
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      // Si no hay overlayContext, navegar directamente
      Get.offNamed(ChildOptionsScreen.routeName);
      return;
    }

    NDialog dialog = NDialog(
      title: Text(
        "Infante actualizado",
        style: Theme.of(overlayContext).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.green[700]),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 64.sp,
            color: Colors.green,
          ),
          SizedBox(height: 20.h),
          Text(
            "El infante ha sido actualizado correctamente.",
            style: Theme.of(overlayContext).textTheme.bodyMedium?.merge(
              TextStyle(color: config.Colors().gray99Color(1), fontSize: 14.sp),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      dialogStyle: DialogStyle(
        titlePadding: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 30.w, right: 30.w),
        contentPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
        elevation: 0,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Cerrar modal
            // Navegar al detalle del infante (ChildOptionsScreen)
            Get.offNamed(ChildOptionsScreen.routeName);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Theme.of(overlayContext).colorScheme.secondary,
          ),
          child: Text(
            "Aceptar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
    dialog.show(overlayContext, dismissable: false);
  }

}
