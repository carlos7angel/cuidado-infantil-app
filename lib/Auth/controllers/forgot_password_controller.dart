import 'package:cuidado_infantil/Auth/repositories/auth_repository.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class ForgotPasswordController extends GetxController {

  late GlobalKey<FormBuilderState> _fbKey;
  GlobalKey<FormBuilderState> get fbKey => _fbKey;
  set fbKey(GlobalKey<FormBuilderState> value) => _fbKey = value;

  void setEmailValue(String? value) {
    _fbKey.currentState?.fields['email']?.validate();
  }

  Future<void> sendPasswordResetEmail() async {
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      return;
    }

    final customDialog = CustomDialog(context: overlayContext);

    // Validar formulario
    if (!(_fbKey.currentState?.saveAndValidate() ?? false)) {
      CustomSnackBar(context: overlayContext).show(message: 'Por favor, ingrese un correo electrónico válido');
      return;
    }

    final formData = _fbKey.currentState!.value;
    final email = formData['email'] as String?;

    if (email == null || email.isEmpty) {
      CustomSnackBar(context: overlayContext).show(message: 'Por favor, ingrese un correo electrónico');
      return;
    }

    // Mostrar diálogo de carga
    customDialog.show();

    try {
      // Enviar solicitud de restablecimiento de contraseña
      final response = await AuthRepository().forgotPassword(email: email);

      customDialog.hide();

      if (response.success) {
        // Mostrar diálogo de éxito
        _showSuccessDialog(overlayContext);
      } else {
        // Mostrar diálogo de error
        _showErrorDialog(overlayContext, response.message);
      }
    } catch (e) {
      customDialog.hide();
      _showErrorDialog(overlayContext, 'Error inesperado al enviar la solicitud. Por favor, intente nuevamente.');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    NDialog dialog = NDialog(
      title: Text(
        "Correo enviado",
        style: Theme.of(context).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/correct.gif', height: 90.h),
          SizedBox(height: 20.h),
          Text(
            "Hemos enviado un enlace de restablecimiento de contraseña a su correo electrónico.",
            style: Theme.of(context).textTheme.bodyMedium?.merge(
              TextStyle(color: config.AppColors.gray99Color(1), fontSize: 14.sp),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          Text(
            "Por favor, revise su bandeja de entrada y siga las instrucciones para restablecer su contraseña.",
            style: Theme.of(context).textTheme.bodyMedium?.merge(
              TextStyle(color: config.AppColors.gray99Color(1), fontSize: 13.sp),
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
            Get.back(); // Cerrar el diálogo
            Get.back(); // Volver a la pantalla de login
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            overlayColor: Colors.grey.withOpacity(0.2),
          ),
          child: Text(
            "Aceptar",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
    dialog.show(context, dismissable: false);
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    NDialog dialog = NDialog(
      title: Text(
        "Error",
        style: Theme.of(context).textTheme.titleMedium?.merge(
          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.red),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          ),
          SizedBox(height: 20.h),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium?.merge(
              TextStyle(color: config.AppColors.gray99Color(1), fontSize: 14.sp),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            "Por favor, verifique que el correo electrónico esté correcto y que esté registrado en el sistema.",
            style: Theme.of(context).textTheme.bodySmall?.merge(
              TextStyle(color: config.AppColors.gray99Color(0.8), fontSize: 12.sp),
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
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            overlayColor: Colors.grey.withOpacity(0.2),
          ),
          child: Text(
            "Aceptar",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
    dialog.show(context, dismissable: false);
  }
}

