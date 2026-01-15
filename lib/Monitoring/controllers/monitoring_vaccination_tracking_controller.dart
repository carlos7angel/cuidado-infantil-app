import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_info.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_tracking_response.dart';
import 'package:cuidado_infantil/Monitoring/repositories/monitoring_vaccination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class MonitoringVaccinationTrackingController extends GetxController {
  bool _loading = true;
  bool get loading => _loading;

  VaccineTrackingResponse? _vaccinationData;
  VaccineTrackingResponse? get vaccinationData => _vaccinationData;

  List<VaccineInfo> _vaccines = [];
  List<VaccineInfo> get vaccines => _vaccines;

  VaccineInfo? _selectedVaccine;
  VaccineInfo? get selectedVaccine => _selectedVaccine;

  String? _childId;
  
  bool _needsScrollToSelected = false;
  bool get needsScrollToSelected => _needsScrollToSelected;
  void clearScrollFlag() => _needsScrollToSelected = false;

  @override
  void onInit() {
    super.onInit();
    // Obtener el ID del child desde storage
    final selectedChild = StorageService.instance.getSelectedChild();
    _childId = selectedChild?.id;
    
    // Cargar los datos de vacunación
    if (_childId != null) {
      Future.microtask(() => loadVaccinationData());
    } else {
      print('❌ ERROR: No se encontró child ID');
      _loading = false;
      update(['vaccination_tracking']);
    }
  }

  Future<void> loadVaccinationData({String? preserveSelectedVaccineId, bool showDialog = false}) async {
    if (_childId == null) return;

    _loading = true;
    update(['vaccination_tracking']);

    CustomDialog? customDialog;
    
    // Solo mostrar CustomDialog si se solicita explícitamente (para otras operaciones)
    if (showDialog) {
      // Esperar a que el contexto esté disponible
      await Future.delayed(Duration(milliseconds: 100));
      
      final overlayContext = Get.overlayContext;
      if (overlayContext == null) {
        print('⚠️  WARNING: overlayContext no disponible, reintentando...');
        await Future.delayed(Duration(milliseconds: 200));
      }
      
      final context = Get.overlayContext;
      if (context != null) {
        customDialog = CustomDialog(context: context);
        customDialog.show();
      }
    }

    try {
      final response = await MonitoringVaccinationRepository().getVaccinationTrackingByChild(childId: _childId!);
      
      customDialog?.hide();

      if (!response.success) {
        final overlayContext = Get.overlayContext;
        if (overlayContext != null) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudieron cargar los datos de vacunación. ${response.message}'
          );
        }
        _loading = false;
        update(['vaccination_tracking']);
        return;
      }

      // Parsear la respuesta
      dynamic responseData = response.data;
      Map<String, dynamic>? dataMap;

      if (responseData is Map) {
        if (responseData.containsKey('data')) {
          dataMap = responseData['data'] as Map<String, dynamic>?;
        } else {
          dataMap = responseData as Map<String, dynamic>?;
        }
      }

      if (dataMap != null) {
        _vaccinationData = VaccineTrackingResponse.fromJson(dataMap);
        _vaccines = _vaccinationData!.vaccines;
        
        // Debug: Verificar que las dosis tengan child_vaccination
        for (var vaccine in _vaccines) {
          print('🔍 DEBUG: Vacuna ${vaccine.vaccine.name} tiene ${vaccine.doses.length} dosis');
          for (var dose in vaccine.doses) {
            if (dose.childVaccination != null) {
              print('  ✅ Dosis ${dose.dose.doseNumber} tiene child_vaccination: ${dose.childVaccination!.dateApplied}');
            } else {
              print('  ⚠️ Dosis ${dose.dose.doseNumber} NO tiene child_vaccination (status: ${dose.status})');
            }
          }
        }
        
        // Seleccionar vacuna: preservar la selección si se proporciona un ID, sino seleccionar la primera
        if (_vaccines.isNotEmpty) {
          if (preserveSelectedVaccineId != null) {
            try {
              _selectedVaccine = _vaccines.firstWhere(
                (v) => v.vaccine.id == preserveSelectedVaccineId,
              );
              // Marcar que se necesita hacer scroll al tab seleccionado
              _needsScrollToSelected = true;
            } catch (e) {
              // Si no se encuentra, seleccionar la primera
              _selectedVaccine = _vaccines.first;
            }
          } else {
            // Si no hay preservación, seleccionar la primera vacuna
            _selectedVaccine = _vaccines.first;
          }
        }
        
        print('✅ DEBUG: Datos de vacunación cargados - ${_vaccines.length} vacunas');
      } else {
        print('⚠️ WARNING: No se encontraron datos de vacunación');
        _vaccines = [];
        _selectedVaccine = null;
      }

      _loading = false;
      update(['vaccination_tracking']);
    } catch (e) {
      customDialog?.hide();
      print('❌ ERROR cargando datos de vacunación: $e');
      
      // Mostrar error solo si hay contexto disponible
      final overlayContext = Get.overlayContext;
      if (overlayContext != null) {
        CustomSnackBar(context: overlayContext).show(
          message: 'Error al cargar los datos de vacunación: $e'
        );
      }
      _loading = false;
      update(['vaccination_tracking']);
    }
  }

  void setSelectedVaccine(VaccineInfo vaccine) {
    _selectedVaccine = vaccine;
    update(['vaccination_tracking']);
  }

  /// Refresca los datos de vacunación
  /// [preserveSelectedVaccineId] - Si se proporciona, restaurará esta vacuna después de recargar
  Future<void> refreshVaccinationData({String? preserveSelectedVaccineId}) async {
    await loadVaccinationData(preserveSelectedVaccineId: preserveSelectedVaccineId);
  }

  /// Registra una vacuna
  Future<bool> registerVaccination({
    required String vaccineDoseId,
    required String dateApplied,
    required String appliedAt,
    String? notes,
  }) async {
    if (_childId == null) {
      print('❌ ERROR: No se encontró child ID');
      return false;
    }

    final context = Get.overlayContext;
    if (context == null) {
      print('❌ ERROR: No se pudo obtener overlayContext');
      return false;
    }

    final customDialog = CustomDialog(context: context);
    customDialog.show();

    try {
      final response = await MonitoringVaccinationRepository().createVaccination(
        childId: _childId!,
        vaccineDoseId: vaccineDoseId,
        dateApplied: dateApplied,
        appliedAt: appliedAt,
        notes: notes,
      );

      customDialog.hide();

      if (!response.success) {
        CustomSnackBar(context: context).show(
          message: 'No se pudo registrar la vacuna. ${response.message}'
        );
        return false;
      }

      // Retornar true primero para que el diálogo del formulario se cierre
      // El modal de éxito se mostrará desde el diálogo después de que se cierre
      return true;
    } catch (e) {
      customDialog.hide();
      print('❌ ERROR registrando vacuna: $e');
      CustomSnackBar(context: context).show(
        message: 'Error al registrar la vacuna: $e'
      );
      return false;
    }
  }

  /// Elimina una vacunación
  Future<bool> deleteVaccination({
    required String childVaccinationId,
  }) async {
    if (_childId == null) {
      print('❌ ERROR: No se encontró child ID');
      return false;
    }

    final context = Get.overlayContext;
    if (context == null) {
      print('❌ ERROR: No se pudo obtener overlayContext');
      return false;
    }

    final customDialog = CustomDialog(context: context);
    customDialog.show();

    try {
      print('🔍 DEBUG deleteVaccination controller:');
      print('  childVaccinationId: $childVaccinationId');
      
      final response = await MonitoringVaccinationRepository().deleteVaccination(
        childVaccinationId: childVaccinationId,
      );

      customDialog.hide();

      print('📡 DEBUG deleteVaccination controller response:');
      print('  statusCode: ${response.statusCode}');
      print('  success: ${response.success}');
      print('  message: ${response.message}');

      if (!response.success) {
        print('❌ DEBUG: La respuesta no fue exitosa');
        CustomSnackBar(context: context).show(
          message: 'No se pudo eliminar la vacuna. ${response.message}'
        );
        return false;
      }

      // Retornar true para que se muestre el modal de éxito
      return true;
    } catch (e) {
      customDialog.hide();
      print('❌ ERROR eliminando vacuna: $e');
      CustomSnackBar(context: context).show(
        message: 'Error al eliminar la vacuna: $e'
      );
      return false;
    }
  }

  void showSuccessDialog({String? message}) {
    final context = Get.overlayContext;
    if (context == null) {
      print('❌ ERROR: No se pudo obtener overlayContext para el modal de éxito');
      return;
    }
    
    // Guardar el ID de la vacuna seleccionada antes de refrescar
    final selectedVaccineId = _selectedVaccine?.vaccine.id;
    
    _showSuccessDialog(context, selectedVaccineId, message);
  }

  void _showSuccessDialog(BuildContext context, String? selectedVaccineId, String? customMessage) {
    final title = customMessage?.contains('elimin') == true ? 'Eliminación exitosa' : 'Registro exitoso';
    final defaultMessage = customMessage?.contains('elimin') == true 
        ? 'Vacuna eliminada exitosamente' 
        : 'Vacuna registrada exitosamente';
    
    NDialog dialog = NDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/correct.gif', height: 90.h),
          SizedBox(height: 10.h),
          Text(
            customMessage ?? defaultMessage,
            style: Theme.of(context).textTheme.bodyMedium?.merge(
              TextStyle(
                color: config.Colors().gray99Color(1),
                fontSize: 14.sp,
              ),
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
            Navigator.of(context).pop();
            // Refrescar los datos después de cerrar el modal, preservando la vacuna seleccionada
            refreshVaccinationData(preserveSelectedVaccineId: selectedVaccineId);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            overlayColor: Colors.grey.withOpacity(0.2),
          ),
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
    dialog.show(context, dismissable: false);
  }
}
