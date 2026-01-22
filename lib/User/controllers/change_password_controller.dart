import 'package:cuidado_infantil/Auth/controllers/login_controller.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/User/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class ChangePasswordController extends GetxController {

  String _newPassword = '';
  String get newPassword => _newPassword;

  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get fbKey => _fbKey;
  set fbKey(GlobalKey<FormBuilderState> value) => _fbKey = value;

  void setNewPasswordValue(String value) {
    _newPassword = value;
    _fbKey.currentState?.fields['new_password']?.validate();
  }

  void setConfirmPasswordValue(String value) {
    _fbKey.currentState?.fields['confirm_password']?.validate();
  }

  void submit() async {
    final customDialog = CustomDialog(context: Get.overlayContext!);
    if (!_fbKey.currentState!.saveAndValidate()) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(message: 'Por favor, complete todos los campos');
      return;
    }

    customDialog.show();
    ResponseRequest response = await UserRepository().changePassword(password: _newPassword);

    if(!response.success) {
      customDialog.hide();
      CustomSnackBar(context: Get.overlayContext!).show(message: response.message);
      return;
    }

    customDialog.hide();

    NDialog dialog = NDialog(
      title: Text(
        "Actualización de contraseña",
        style: Theme.of(Get.overlayContext!).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 14.sp)
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/correct.gif', height: 90.h),
          SizedBox(height: 10),
          Text(
            "Su contraseña ha sido actualizada satisfactoriamente. Por seguridad debe volver a ingresar a la aplicación.",
            style: Theme.of(Get.overlayContext!).textTheme.bodyMedium?.merge(
              TextStyle(color: config.AppColors.gray99Color(1), fontSize: 13.sp)
            ), 
            textAlign: TextAlign.justify,
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
          onPressed: () => LoginController().logout(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            overlayColor: Colors.grey.withOpacity(0.2),
          ),
          child: Text("Aceptar", style: TextStyle(color: Theme.of(Get.overlayContext!).colorScheme.secondary, fontSize: 14.sp),),


        ),
      ],
    );
    dialog.show(Get.overlayContext!, dismissable: false);
    
  }
  
}
