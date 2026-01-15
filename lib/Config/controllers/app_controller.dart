import 'package:cuidado_infantil/Auth/models/session_model.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:get/get.dart';

class AppController extends GetxController {

  Future<bool> checkSession() async {
    Session? session = StorageService.instance.getSession();
    return session != null;
  }

}