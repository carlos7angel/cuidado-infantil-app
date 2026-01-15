import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Monitoring/services/childcare_center_service.dart';

class ChildcareCenterRepository {

  Future<ResponseRequest> getCurrentChildcareCenter() async => await ChildcareCenterService().getCurrentChildcareCenter();

}