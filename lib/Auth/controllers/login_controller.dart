import 'package:cuidado_infantil/Auth/models/login_model.dart';
import 'package:cuidado_infantil/Auth/models/server_model.dart';
import 'package:cuidado_infantil/Auth/repositories/auth_repository.dart';
import 'package:cuidado_infantil/Auth/ui/screens/server_screen.dart';
import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:cuidado_infantil/User/models/childcare_center_model.dart';
import 'package:cuidado_infantil/User/models/user_model.dart';
import 'package:cuidado_infantil/User/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  late LoginModel _loginModel;
  LoginModel get loginModel => _loginModel;
  Server? server;

  late GlobalKey<FormBuilderState> _fbKey;
  GlobalKey<FormBuilderState> get fbKey => _fbKey;
  set fbKey(GlobalKey<FormBuilderState> value) => _fbKey = value;

  @override
  void onInit() {
    _loginModel = LoginModel();
    server = StorageService.instance.getServer();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if(server == null || server?.host == null) {
      CustomSnackBar(context: Get.overlayContext!).show(message: 'No existe una dirección de servidor configurada');
      Get.offNamed(ServerScreen.routeName);
      return;
    }
  }

  void setEmailValue(String? value) {
    _loginModel.email = value;
    _fbKey.currentState!.fields['email']?.validate();
  }

  void setPasswordValue(String? value) {
    _loginModel.password = value;
    _fbKey.currentState!.fields['password']?.validate();
  }

  void initForm() {
    _fbKey.currentState?.reset();
    _loginModel = LoginModel();
  }

  void login() async {
    final customDialog = CustomDialog(context: Get.overlayContext!);

    if (!_fbKey.currentState!.saveAndValidate()) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(message: 'Por favor, complete todos los campos');
      return;
    }
    
    customDialog.show();
    ResponseRequest response = await AuthRepository().login(email: _loginModel.email!, password: _loginModel.password!);      
    
    if(!response.success) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(message: response.message);
      return;
    }

    // set session data - los datos del token están dentro de 'data'
    final sessionData = response.data['data'] as Map<String, dynamic>;
    await AuthRepository().setSessionData(data: sessionData);
    
    // Configurar el token en ApiService para las siguientes peticiones
    final session = StorageService.instance.getSession();
    if (session?.accessToken != null) {
      ApiService.instance.setAuthToken(session!.accessToken!);
    }

    ResponseRequest userResponse = await UserRepository().getAuthenticatedUser();
    
    if(!userResponse.success) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(message: userResponse.message);
      return;
    }

    // set user data - los datos del usuario están dentro de 'data'
    final userData = userResponse.data['data'] as Map<String, dynamic>;
      
    // Combine data + educator.data to create User
    final user = User.fromApiResponse(userData);
    await StorageService.instance.setUser(user);
    
    // Save the first childcareCenter
    final childcareCentersData = userData['childcareCenters']?['data'] as List?;
    
    if (childcareCentersData != null && childcareCentersData.isNotEmpty) {
      final childcareCenter = ChildcareCenter.fromApiResponse(childcareCentersData.first);
      await StorageService.instance.setChildcareCenter(childcareCenter);
    }
    
    // Cargar datos en el SessionController global
    Get.find<SessionController>().loadSession();
    
    customDialog.hide();
    Get.offAllNamed(HomeScreen.routeName);
  }

  void logout() async {
    final customDialog = CustomDialog(context: Get.overlayContext!);
    customDialog.show();
    ResponseRequest responseRequest = await AuthRepository().logout();
    // if(!responseRequest.success) {
    //   CustomSnackBar(context: Get.overlayContext).show(message: responseRequest.message);
    // }
    StorageService.instance.remove();
    Get.find<SessionController>().clearSession();
    customDialog.hide();
    Get.offAllNamed(ServerScreen.routeName);
  }
}
