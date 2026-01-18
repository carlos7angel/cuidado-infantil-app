import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/repositories/child_repository.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Incident/controllers/incident_report_list_controller.dart';
import 'package:cuidado_infantil/Incident/models/create_incident_report_request.dart';
import 'package:cuidado_infantil/Incident/repositories/incident_report_repository.dart';
import 'package:cuidado_infantil/Monitoring/models/room.dart';
import 'package:cuidado_infantil/Monitoring/repositories/childcare_center_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

class IncidentReportFormController extends GetxController {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;

  List<Child> _children = [];
  List<Child> get children => _children;

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  bool _loadingChildren = false;
  bool get loadingChildren => _loadingChildren;

  Child? _selectedChild;
  Child? get selectedChild => _selectedChild;

  List<PlatformFile> _evidenceFiles = [];
  List<PlatformFile> get evidenceFiles => _evidenceFiles;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  bool _hasAttemptedSave = false;
  bool get hasAttemptedSave => _hasAttemptedSave;

  bool _hasEvidence = false;
  bool get hasEvidence => _hasEvidence;

  void setHasEvidence(bool value) {
    _hasEvidence = value;
    if (!value) {
      // Limpiar archivos y descripción si se desactiva
      _evidenceFiles.clear();
      _fbKey.currentState?.fields['evidence_description']?.didChange(null);
      update(['evidence_files']);
    }
    update(['has_evidence']);
  }

  @override
  void onInit() {
    super.onInit();
    loadRooms();
    loadChildren();
  }

  Future<void> loadRooms() async {
    try {
      final response = await ChildcareCenterRepository().getCurrentChildcareCenter();
      if (!response.success) {
        return;
      }

      final childcareCenterData = response.data['data'] as Map<String, dynamic>?;
      if (childcareCenterData == null) return;

      final roomsData = childcareCenterData['active_rooms']?['data'] as List?;
      if (roomsData != null && roomsData.isNotEmpty) {
        _rooms = roomsData.map((json) => Room.fromMap(json as Map<String, dynamic>)).toList();
      }
      update(['rooms']);
    } catch (e) {
      // Silently fail
    }
  }

  Room? getRoomById(String? roomId) {
    if (roomId == null) return null;
    return _rooms.firstWhereOrNull((room) => room.id == roomId);
  }

  Future<void> loadChildren() async {
    _loadingChildren = true;
    update(['children_loading']);

    try {
      final childcareCenterId = StorageService.instance.getChildcareCenter()?.id;
      
      if (childcareCenterId == null) {
        CustomSnackBar(context: Get.overlayContext!).show(
          message: 'No se encontró el centro de cuidado infantil'
        );
        _loadingChildren = false;
        update(['children_loading']);
        return;
      }

      final response = await ChildRepository().getChildrenByChildcareCenter(
        childcareCenterId: childcareCenterId.toString()
      );
      
      if (!response.success) {
        CustomSnackBar(context: Get.overlayContext!).show(
          message: 'No se pudieron cargar los niños. ${response.message}'
        );
        _loadingChildren = false;
        update(['children_loading']);
        return;
      }

      dynamic childrenData = response.data['data'];
      if (childrenData == null && response.data is List) {
        childrenData = response.data;
      }

      _children.clear();
      if (childrenData != null && childrenData is List && childrenData.isNotEmpty) {
        _children = childrenData.map((json) {
          try {
            return Child.fromMap(json as Map<String, dynamic>);
          } catch (e) {
            return null;
          }
        }).whereType<Child>().toList();
        
        // Ordenar por nombre completo
        _children.sort((a, b) {
          return a.getFullName().toLowerCase().compareTo(b.getFullName().toLowerCase());
        });
      }

      _loadingChildren = false;
      update(['children_loading']);
    } catch (e) {
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Error al cargar los niños: $e'
      );
      _loadingChildren = false;
      update(['children_loading']);
    }
  }

  void setSelectedChild(Child? child) {
    _selectedChild = child;
    if (child != null && _fbKey.currentState != null) {
      // Actualizar el campo del formulario
      _fbKey.currentState!.fields['child_id']?.didChange(child.id);
      // Validar el campo para que desaparezca el error
      _fbKey.currentState!.fields['child_id']?.validate();
      // Guardar el estado del formulario
      _fbKey.currentState!.save();
    }
    update(['selected_child']);
  }

  void addEvidenceFile(PlatformFile file) {
    _evidenceFiles.add(file);
    update(['evidence_files']);
  }

  void removeEvidenceFile(int index) {
    if (index >= 0 && index < _evidenceFiles.length) {
      _evidenceFiles.removeAt(index);
      update(['evidence_files']);
    }
  }

  void clearEvidenceFiles() {
    _evidenceFiles.clear();
    update(['evidence_files']);
  }

  Future<void> saveIncidentReport() async {
    print('🚀 DEBUG: Iniciando proceso de guardar reporte de incidente');
    
    // Marcar que se ha intentado guardar
    _hasAttemptedSave = true;
    update(['form_validation']);

    // Validar el formulario
    if (_fbKey.currentState?.saveAndValidate() != true) {
      print('❌ DEBUG: Formulario no válido');
      return;
    }

    if (_selectedChild == null) {
      print('❌ DEBUG: No hay child seleccionado');
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Por favor selecciona un niño'
      );
      return;
    }

    final formData = _fbKey.currentState!.value;
    print('📋 DEBUG: Datos del formulario:');
    print('  - child_id: ${_selectedChild!.id}');
    print('  - type: ${formData['type']}');
    print('  - description: ${formData['description']}');
    print('  - incident_date: ${formData['incident_date']}');
    print('  - incident_time: ${formData['incident_time']}');
    print('  - incident_location: ${formData['incident_location']}');
    print('  - people_involved: ${formData['people_involved']}');
    print('  - escalated_to: ${formData['escalated_to']}');
    print('  - evidence_files count: ${_evidenceFiles.length}');

    _isSaving = true;
    update(['saving']);

    final overlayContext = Get.overlayContext;
    CustomDialog? customDialog;
    if (overlayContext != null) {
      customDialog = CustomDialog(context: overlayContext);
      customDialog.show();
      print('⏳ DEBUG: Mostrando dialog de carga');
    }

    try {
      // Convertir fecha y hora a string
      String incidentDateStr;
      if (formData['incident_date'] is DateTime) {
        incidentDateStr = formatDate(formData['incident_date'] as DateTime);
      } else if (formData['incident_date'] is String) {
        incidentDateStr = formData['incident_date'] as String;
      } else {
        throw Exception('Formato de fecha inválido: ${formData['incident_date']}');
      }

      String incidentTimeStr;
      if (formData['incident_time'] is DateTime) {
        // Si es DateTime, extraer solo la hora
        final dateTime = formData['incident_time'] as DateTime;
        incidentTimeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (formData['incident_time'] is TimeOfDay) {
        incidentTimeStr = formatTime(formData['incident_time'] as TimeOfDay);
      } else if (formData['incident_time'] is String) {
        incidentTimeStr = formData['incident_time'] as String;
      } else {
        throw Exception('Formato de hora inválido: ${formData['incident_time']}');
      }

      print('📅 DEBUG: Fechas convertidas:');
      print('  - incident_date (original): ${formData['incident_date']} (${formData['incident_date'].runtimeType})');
      print('  - incident_date (convertido): $incidentDateStr');
      print('  - incident_time (original): ${formData['incident_time']} (${formData['incident_time'].runtimeType})');
      print('  - incident_time (convertido): $incidentTimeStr');

      final request = CreateIncidentReportRequest(
        childId: _selectedChild!.id!,
        type: formData['type'] as String,
        description: formData['description'] as String,
        incidentDate: incidentDateStr,
        incidentTime: incidentTimeStr,
        incidentLocation: formData['incident_location'] as String,
        peopleInvolved: formData['people_involved'] as String,
        witnesses: formData['witnesses']?.toString(),
        hasEvidence: _hasEvidence,
        evidenceDescription: _hasEvidence ? formData['evidence_description']?.toString() : null,
        actionsTaken: formData['actions_taken']?.toString(),
        escalatedTo: formData['escalated_to']?.toString(),
        additionalComments: formData['additional_comments']?.toString(),
        evidenceFiles: _hasEvidence && _evidenceFiles.isNotEmpty ? _evidenceFiles : null,
      );

      print('📡 DEBUG: Enviando request al API...');
      final response = await IncidentReportRepository().createIncidentReport(
        request: request,
      );

      print('📥 DEBUG: Respuesta recibida del API');
      print('  - success: ${response.success}');
      print('  - message: ${response.message}');
      print('  - data: ${response.data}');

      // Ocultar dialog siempre, sin importar el resultado
      if (customDialog != null) {
        customDialog.hide();
        print('✅ DEBUG: Dialog ocultado');
      }

      if (!response.success) {
        print('❌ DEBUG: API retornó error');
        print('  - Error message: ${response.message}');
        print('  - Error data: ${response.data}');
        
        // Si hay errores de validación en el response.data, mostrarlos
        String errorMessage = response.message.isNotEmpty ? response.message : 'Error desconocido';
        if (response.data != null && response.data is Map) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('errors')) {
            final errors = errorData['errors'];
            print('  - Validation errors: $errors');
            if (errors is Map) {
              final errorList = <String>[];
              errors.forEach((key, value) {
                if (value is List && value.isNotEmpty) {
                  errorList.add('${key}: ${value.first}');
                }
              });
              if (errorList.isNotEmpty) {
                errorMessage = errorList.join('\n');
              }
            }
          }
        }
        
        CustomSnackBar(context: Get.overlayContext!).show(
          message: 'Error al crear el reporte: $errorMessage'
        );
        _isSaving = false;
        update(['saving']);
        return;
      }

      print('✅ DEBUG: Reporte creado exitosamente');
      print('  - Response data: ${response.data}');

      // Mostrar diálogo de éxito
      _showSuccessDialog();
    } catch (e, stackTrace) {
      print('💥 DEBUG: Error inesperado al crear reporte');
      print('  - Error: $e');
      print('  - StackTrace: $stackTrace');
      
      // Ocultar dialog en caso de excepción
      if (customDialog != null) {
        customDialog.hide();
        print('✅ DEBUG: Dialog ocultado después de excepción');
      }
      
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Error al crear el reporte: $e'
      );
      _isSaving = false;
      update(['saving']);
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showSuccessDialog() {
    // Asegurarse de que el CustomDialog esté completamente cerrado
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      final customDialog = CustomDialog(context: overlayContext);
      customDialog.hide();
    }
    
    // Mostrar el modal de éxito en el próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.overlayContext;
      if (context == null) {
        print('❌ ERROR: No se pudo obtener overlayContext para el modal de éxito');
        return;
      }

      NDialog dialog = NDialog(
        title: Text(
          "Reporte creado",
          style: Theme.of(context).textTheme.titleMedium?.merge(
            TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/correct.gif', height: 90.h),
            SizedBox(height: 10.h),
            Text(
              "El reporte de incidente ha sido creado exitosamente.",
              style: Theme.of(context).textTheme.bodyMedium?.merge(
                TextStyle(color: config.Colors().gray99Color(1), fontSize: 13.sp)
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
              // Cerrar el modal de éxito
              Navigator.of(context).pop();
              
              // Navegar de vuelta a la lista y refrescar
              Get.back();
              
              // Refrescar la lista de reportes
              try {
                Get.find<IncidentReportListController>().refreshIncidentReports();
              } catch (e) {
                print('⚠️ No se pudo encontrar el controlador del listado: $e');
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              overlayColor: Colors.grey.withOpacity(0.2),
            ),
            child: Text(
              "Aceptar",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      );
      dialog.show(context, dismissable: false);
    });
  }
}

