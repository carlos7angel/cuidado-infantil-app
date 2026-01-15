import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';

class ChildcareCenterService {

  ChildcareCenterService._internal();
  static final ChildcareCenterService _instance = ChildcareCenterService._internal();
  static ChildcareCenterService get instance => _instance;
  factory ChildcareCenterService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getCurrentChildcareCenter() async {
    final token = StorageService.instance.getSession()?.accessToken;
    final childcareCenter = StorageService.instance.getChildcareCenter();
    final response = await _api.get(
        '/childcare-centers/${childcareCenter?.id}',
        queryParams: {
          'include': 'active_rooms',
          'limit': 100
        },
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    return response;
  }

}