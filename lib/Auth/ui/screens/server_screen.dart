import 'package:cuidado_infantil/Auth/controllers/server_controller.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Intro/ui/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});
  static final String routeName = '/server';

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {

  @override
  void initState() {
    ServerController serverController = Get.put(ServerController());
    serverController.fbKey = GlobalKey<FormBuilderState>();
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
                      begin: Alignment.topLeft,
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

                          GetBuilder<ServerController>(
                              id: 'form_server_url',
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
                                          SizedBox(height: 20.h),
                                          Container(
                                              alignment: Alignment.center,
                                              child: Image.asset('assets/images/server.png', height: ScreenUtil().setHeight(150))
                                          ),
                                          SizedBox(height: 25.h),
                                          Text('Conexión a Servidor', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,),
                                          SizedBox(height: 15.h),
                                          Text('Ingrese la URL del servidor del Municipio', style: Theme.of(context).textTheme.bodyLarge?.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.secondary)), textAlign: TextAlign.center),
                                          SizedBox(height: 40.h),
                                          FormBuilderTextField(
                                            name: 'url',
                                            keyboardType: TextInputType.url,
                                            validator: FormBuilderValidators.compose([
                                              FormBuilderValidators.required(),
                                              FormBuilderValidators.url(),
                                              FormBuilderValidators.maxLength(150),
                                            ]),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            decoration: InputDecoration(
                                              hintText: 'Dirección URL',
                                              hintStyle: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.redAccent)),
                                              errorMaxLines: 2,
                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                                              prefixIcon: Icon(UiIcons.cloudComputing, color: Theme.of(context).colorScheme.secondary), // Color(0xFF78BCC4)
                                              contentPadding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                                            ),
                                            initialValue: controller.loginModel.email,
                                            onChanged: (value) => controller.setUrlValue(value),
                                          ),
                                          SizedBox(height: 50.h),
                                          TextButton(
                                            onPressed: () => controller.access(),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 70.w),
                                              shape: StadiumBorder(),
                                              backgroundColor: Theme.of(context).colorScheme.secondary,
                                            ),
                                            child: Text(
                                              'Continuar',
                                              style: Theme.of(context).textTheme.titleMedium?.merge(
                                                TextStyle(color: Theme.of(context).primaryColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                                    )
                                );
                              }
                          ),
                        ],
                      ),
                      // TextButton(
                      //   onPressed: () => Get.back(),
                      //   child: RichText(
                      //     text: TextSpan(
                      //       style: Theme.of(context).textTheme.titleMedium?.merge(
                      //         TextStyle(color: Theme.of(context).colorScheme.secondary),
                      //       ),
                      //       children: [
                      //         TextSpan(text: 'Cancelar'),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
                onPressed: () => Get.toNamed(OnboardingScreen.routeName),
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
