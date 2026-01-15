import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/User/models/childcare_center_model.dart';
import 'package:cuidado_infantil/User/models/educator_model.dart';
import 'package:cuidado_infantil/User/models/user_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  final SessionController _session = Get.find<SessionController>();

  ChildcareCenter? get childcareCenter => _session.childcareCenter;
  User? get user => _session.user;





}
