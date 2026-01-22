import 'package:cuidado_infantil/Auth/controllers/forgot_password_controller.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static final String routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  @override
  void initState() {
    ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
    forgotPasswordController.fbKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = ScreenUtil().screenWidth * 1.5;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: -((circleSize/2) - (ScreenUtil().screenWidth/2)),
            top: -120.h,
            child: Container(
              width: circleSize * 1.0,
              height: circleSize,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [config.AppColors.mainColor(0.9), config.AppColors.mainColor(0.35)],
                      begin: Alignment.center,
                      end: Alignment.bottomRight
                  ),
                  borderRadius: BorderRadius.circular(circleSize/2)
              ),
            ),
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                            margin: EdgeInsets.symmetric(vertical: 70, horizontal: 40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor.withOpacity(0.6),
                            ),
                          ),

                          GetBuilder<ForgotPasswordController>(
                              builder: (controller) {
                                return FormBuilder(
                                    key: controller.fbKey,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                                      margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Theme.of(context).primaryColor,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 10), blurRadius: 20)
                                          ]),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 25.h),
                                          Text(
                                            'Recuperar contraseña',
                                            style: Theme.of(context).textTheme.displayMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            'Ingrese su correo electrónico para recibir un enlace de restablecimiento',
                                            style: Theme.of(context).textTheme.bodySmall?.merge(
                                              TextStyle(color: config.AppColors.gray99Color(1)),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 50.h),
                                          FormBuilderTextField(
                                            name: 'email',
                                            keyboardType: TextInputType.emailAddress,
                                            validator: FormBuilderValidators.compose([
                                              FormBuilderValidators.required(errorText: 'El correo electrónico es obligatorio'),
                                              FormBuilderValidators.email(errorText: 'Ingrese un correo electrónico válido'),
                                              FormBuilderValidators.maxLength(150),
                                            ]),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            decoration: InputDecoration(
                                              hintText: 'Correo Electrónico',
                                              hintStyle: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.redAccent)),
                                              errorMaxLines: 2,
                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                                              prefixIcon: Icon(UiIcons.envelope, color: Theme.of(context).colorScheme.secondary),
                                              contentPadding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                                            ),
                                            onChanged: (value) => controller.setEmailValue(value),
                                          ),
                                          SizedBox(height: 50.h),
                                          TextButton(
                                            onPressed: () => controller.sendPasswordResetEmail(),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 70.w),
                                              shape: StadiumBorder(),
                                              backgroundColor: Theme.of(context).colorScheme.secondary,
                                            ),
                                            child: Text(
                                              'Enviar enlace',
                                              style: Theme.of(context).textTheme.titleMedium?.merge(
                                                TextStyle(color: Theme.of(context).primaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25.h),
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: RichText(
                                              text: TextSpan(
                                                style: Theme.of(context).textTheme.bodyMedium?.merge(
                                                  TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                ),
                                                children: [
                                                  TextSpan(text: '¿Recordaste tu contraseña? '),
                                                  TextSpan(
                                                    text: 'Iniciar sesión',
                                                    style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: (AppBar().preferredSize.height).h,
            left: 20.w,
            child: Container(
              child: IconButton(
                icon: Icon(UiIcons.returnIcon),
                onPressed: () => Get.back(),
                color: Colors.white,
                padding: EdgeInsets.all(15.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

