import 'dart:async';
import 'package:cuidado_infantil/Auth/models/session_model.dart';
import 'package:cuidado_infantil/Auth/ui/screens/login_screen.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {

  Session? session;

  @override
  void onReady() async {
    await Future.delayed(const Duration(seconds: 1));
    session = StorageService.instance.getSession();

    if(session != null && session?.accessToken != null) {
      Get.offAll(() => HomeScreen(currentTab: 2));
    } else {
      Get.offAllNamed(LoginScreen.routeName);
    }

    super.onReady();
  }
}
