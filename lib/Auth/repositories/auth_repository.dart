import 'package:cuidado_infantil/Auth/models/server_model.dart';
import 'package:cuidado_infantil/Auth/models/session_model.dart';
import 'package:cuidado_infantil/Auth/services/auth_service.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';

class AuthRepository {

  Future<ResponseRequest> accessServer({required String url}) async => await AuthService().accessServer(url: url);

  Future<void> setServerData({required Map<String, dynamic> data}) async => await StorageService.instance.setServer(Server.fromJson(data));

  Future<void> setSessionData({required Map<String, dynamic> data}) async => await StorageService.instance.setSession(Session.fromJson(data));

  Future<ResponseRequest> login({required String email, required String password}) async => await AuthService().login(email: email, password: password);

  Future<ResponseRequest> logout() async => await AuthService().logout();

  Future<ResponseRequest> forgotPassword({required String email}) async => await AuthService().forgotPassword(email: email);

  Future<ResponseRequest> refreshToken() async => await AuthService().refreshToken();
}