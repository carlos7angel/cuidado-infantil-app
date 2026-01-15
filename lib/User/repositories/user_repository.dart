import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/User/services/user_service.dart';

class UserRepository {

  Future<ResponseRequest> getAuthenticatedUser() async => await UserService().getAuthenticatedUser();

  Future<ResponseRequest> changePassword({required String password}) async => await UserService().changePassword(password: password);

}
