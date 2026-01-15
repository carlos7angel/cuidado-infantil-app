import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/Config/routes/app_pages.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  ApiService.instance.init();
  
  // Registrar SessionController como permanente (disponible en toda la app)
  Get.put(SessionController(), permanent: true);
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      )
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ScreenUtilInit(
      designSize: Size(412, 823),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Cuidado Infantil',
          initialRoute: '/splash',
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          theme: config.Themes.primaryTheme(),
          darkTheme: config.Themes.darkTheme(),
          themeMode: ThemeMode.light,
          locale: Locale('es', 'ES'),
          supportedLocales: [Locale('es', 'ES')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
        );
      },
    );
  }
}
