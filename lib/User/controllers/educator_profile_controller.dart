
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/User/services/user_service.dart';
import 'package:cuidado_infantil/User/models/user_model.dart';
import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:intl/intl.dart';

class EducatorProfileController extends GetxController {

  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;
  set fbKey (GlobalKey<FormBuilderState> value) { _fbKey = value; }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  EducatorProfileController() {
    loadUserData();
  }

  void loadUserData() {
    _user = StorageService.instance.getUser();
    update();
  }

  void setGenderValue(String? gender) {
    if (fbKey.currentState != null) {
      fbKey.currentState!.fields['gender']?.didChange(gender);
      update();
    }
  }

  String? getGenderValue() {
    if (fbKey.currentState != null && fbKey.currentState!.fields['gender']?.value != null) {
      return fbKey.currentState!.fields['gender']?.value;
    }
    // Fallback al género del usuario si el formulario no está inicializado
    return _user?.educator?.gender;
  }

  Future<bool> saveProfile() async {
    if (fbKey.currentState?.saveAndValidate() ?? false) {
      _isLoading = true;
      update();

      // Obtener el contexto de overlay para el CustomDialog
      final overlayContext = Get.overlayContext;
      if (overlayContext == null) {
        _isLoading = false;
        update();
        return false;
      }

      final customDialog = CustomDialog(context: overlayContext);

      try {
        final formData = fbKey.currentState!.value;
        final educatorId = _user?.educator?.id;
        
        if (educatorId == null) {
          customDialog.hide();
          _isLoading = false;
          update();
          CustomSnackBar(context: overlayContext).show(
            title: 'Error',
            message: 'No se encontró el ID del educador',
          );
          return false;
        }

        // Preparar datos para la API
        Map<String, dynamic> updateData = {};
        
        if (formData['first_name'] != null) {
          updateData['first_name'] = formData['first_name'];
        }
        if (formData['last_name'] != null) {
          updateData['last_name'] = formData['last_name'];
        }
        if (formData['gender'] != null) {
          updateData['gender'] = formData['gender'];
        }
        if (formData['birthdate'] != null) {
          // Formatear fecha como yyyy-MM-dd
          final date = formData['birthdate'] as DateTime;
          updateData['birth'] = DateFormat('yyyy-MM-dd').format(date);
        }
        if (formData['state'] != null) {
          updateData['state'] = formData['state'];
        }
        if (formData['dni'] != null && formData['dni'].toString().isNotEmpty) {
          updateData['dni'] = formData['dni'];
        }
        if (formData['phone'] != null && formData['phone'].toString().isNotEmpty) {
          updateData['phone'] = formData['phone'];
        }

        // Mostrar diálogo de carga
        customDialog.show();

        // Enviar actualización a la API
        final response = await UserService.instance.updateEducator(
          educatorId: educatorId,
          data: updateData,
        );

        if (response.success) {
          // Recargar datos del usuario desde la API y actualizar storage
          await refreshUserData();
          
          // Ocultar diálogo
          customDialog.hide();
          
          _isLoading = false;
          update();
          
          CustomSnackBar(context: overlayContext).show(
            title: 'Éxito',
            message: 'Perfil actualizado correctamente',
          );
          
          // Esperar suficiente tiempo para que el usuario lea el mensaje
          await Future.delayed(Duration(seconds: 3));
          
          // Regresar a la pantalla anterior después de actualizar
          Get.back();
          
          return true;
        } else {
          customDialog.hide();
          _isLoading = false;
          update();
          CustomSnackBar(context: overlayContext).show(
            title: 'Error',
            message: response.message.isNotEmpty ? response.message : 'No se pudo actualizar el perfil',
          );
          return false;
        }
      } catch (e) {
        customDialog.hide();
        _isLoading = false;
        update();
        CustomSnackBar(context: overlayContext).show(
          title: 'Error',
          message: 'Error al actualizar: ${e.toString()}',
        );
        return false;
      }
    }
    return false;
  }

  Future<void> refreshUserData() async {
    final response = await UserService.instance.getAuthenticatedUser();
    if (response.success && response.data != null) {
      try {
        // Parsear la respuesta de la API
        // La estructura puede ser: { 'data': {...} } o directamente {...}
        Map<String, dynamic> userData;
        if (response.data is Map) {
          final dataMap = response.data as Map<String, dynamic>;
          if (dataMap.containsKey('data')) {
            userData = dataMap['data'] as Map<String, dynamic>;
          } else {
            userData = dataMap;
          }
        } else {
          return;
        }
        
        _user = User.fromApiResponse(userData);
        
        // Guardar en storage (esperar a que se complete)
        await StorageService.instance.setUser(_user!);
        
        // Esperar un momento para asegurar que el storage se haya guardado completamente
        await Future.delayed(Duration(milliseconds: 200));
        
        // Actualizar SessionController si existe
        try {
          if (Get.isRegistered<SessionController>()) {
            final sessionController = Get.find<SessionController>();
            sessionController.loadSession();
            // Esperar un momento para que el SessionController se actualice completamente
            await Future.delayed(Duration(milliseconds: 200));
          }
        } catch (e) {
          // SessionController no está inicializado, continuar sin actualizarlo
        }
        
        // Actualizar el controlador local
        update();
      } catch (e) {
        // Error al refrescar datos del usuario
      }
    }
  }

}