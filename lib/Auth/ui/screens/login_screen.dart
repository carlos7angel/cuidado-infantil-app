import 'package:cuidado_infantil/Auth/controllers/login_controller.dart';
import 'package:cuidado_infantil/Auth/ui/screens/forgot_password_screen.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static final String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _showPassword = false;

  @override
  void initState() {
    LoginController loginController = Get.put(LoginController());
    loginController.fbKey = GlobalKey<FormBuilderState>();
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
                      colors: [config.Colors().mainColor(0.9), config.Colors().mainColor(0.35)],
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

                          GetBuilder<LoginController>(
                              id: 'form_login',
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
                                          Text('Ingresar', style: Theme.of(context).textTheme.displayMedium),
                                          SizedBox(height: 15.h),
                                          Text('Municipio: ${controller.server?.municipality ?? 'Undefined'}', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                                          SizedBox(height: 50.h),
                                          FormBuilderTextField(
                                            name: 'email',
                                            keyboardType: TextInputType.emailAddress,
                                            validator: FormBuilderValidators.compose([
                                              FormBuilderValidators.required(),
                                              FormBuilderValidators.email(),
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
                                              prefixIcon: Icon(UiIcons.envelope, color: Theme.of(context).colorScheme.secondary), // Color(0xFF78BCC4)
                                              contentPadding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                                            ),
                                            initialValue: controller.loginModel.email,
                                            onChanged: (value) => controller.setEmailValue(value),
                                          ),
                                          SizedBox(height: 20.h),
                                          FormBuilderTextField(
                                            name: 'password',
                                            keyboardType: TextInputType.text,
                                            obscureText: !_showPassword,
                                            validator: FormBuilderValidators.compose([
                                              FormBuilderValidators.required(),
                                              FormBuilderValidators.minLength(6),
                                              FormBuilderValidators.maxLength(30),
                                            ]),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            decoration: InputDecoration(
                                                hintText: 'Contraseña',
                                                hintStyle: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                                errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.redAccent)),
                                                errorMaxLines: 2,
                                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                                                contentPadding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                                                prefixIcon: Icon(UiIcons.padlock_1, color: Theme.of(context).colorScheme.secondary), // Color(0xFF78BCC4)
                                                suffixIcon: IconButton(
                                                  onPressed: () => setState(() => _showPassword = !_showPassword),
                                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                                                )
                                            ),
                                            initialValue: controller.loginModel.password,
                                            onChanged: (value) => controller.setPasswordValue(value),
                                          ),
                                          SizedBox(height: 50.h),
                                          TextButton(
                                            onPressed: () => controller.login(),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 70.w),
                                              shape: StadiumBorder(),
                                              backgroundColor: Theme.of(context).colorScheme.secondary,
                                            ),
                                            child: Text(
                                              'Login',
                                              style: Theme.of(context).textTheme.titleMedium?.merge(
                                                TextStyle(color: Theme.of(context).primaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25.h),
                                        ],
                                      ),
                                    )
                                );
                              }
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(ForgotPasswordScreen.routeName),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleMedium?.merge(
                              TextStyle(color: Theme.of(context).colorScheme.secondary),
                            ),
                            children: [
                              TextSpan(text: '¿Olvidaste tu contraseña? '),
                              TextSpan(
                                text: 'Recuperar',
                                style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
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
              //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
