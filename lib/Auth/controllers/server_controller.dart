import 'package:cuidado_infantil/Auth/models/login_model.dart';
import 'package:cuidado_infantil/Auth/repositories/auth_repository.dart';
import 'package:cuidado_infantil/Auth/ui/screens/login_screen.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ServerController extends GetxController {

  late LoginModel _loginModel;
  LoginModel get loginModel => _loginModel;

  late GlobalKey<FormBuilderState> _fbKey;
  GlobalKey<FormBuilderState> get fbKey => _fbKey;
  set fbKey(GlobalKey<FormBuilderState> value) => _fbKey = value;

  @override
  void onInit() {
    _loginModel = LoginModel();
    super.onInit();
  }

  void setUrlValue(String? url) {
    _loginModel.serverUrl = url;
    _fbKey.currentState!.fields['url']?.validate();
  }

  void initForm() {
    _fbKey.currentState?.reset();
    _loginModel = LoginModel();
  }

  void access() async {
    final customDialog = CustomDialog(context: Get.overlayContext!);
    if (_fbKey.currentState!.saveAndValidate()) {
      customDialog.show();
      ResponseRequest response = await AuthRepository().accessServer(url: _loginModel.serverUrl!);
      if(response.success) {
        // await AuthRepository().setServerData(data: response.data as Map<String, dynamic>);
        Get.offNamed(LoginScreen.routeName);
        return;
      } else {
        customDialog.hide();
        CustomSnackBar(context: Get.overlayContext!).show(message: response.message);
      }
    } else {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(message: 'Por favor, complete todos los campos');
    }
  }

}