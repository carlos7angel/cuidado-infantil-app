import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';

class UserService {

  UserService._internal();
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;
  factory UserService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getAuthenticatedUser() async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/profile',
      queryParams: {
        'include': 'roles,educator,childcareCenters',
      },
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
    return response;
  }

  Future<ResponseRequest> changePassword({required String password}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final user = StorageService.instance.getUser();
    final response = await _api.patch(
      '/users/${user?.id}/password',
      data: {
        'new_password': password,
        'new_password_confirmation': password,
      },
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
    return response;
  }

  Future<ResponseRequest> updateEducator({
    required String educatorId,
    required Map<String, dynamic> data,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.put(
      '/educators/$educatorId',
      data: data,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
    return response;
  }

}