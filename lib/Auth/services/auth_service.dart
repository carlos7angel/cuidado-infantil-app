import 'package:cuidado_infantil/Auth/models/session_model.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:dio/dio.dart';

class AuthService {

  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;
  factory AuthService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> accessServer({required String url}) async {
    final response = await _api.getRaw(url);
    return response;
  }

  Future<ResponseRequest> login({required String email, required String password}) async {
    return await _api.post("/clients/app/login", data: {
      "email" : email,
      "password" : password,
    });
  }

  Future<ResponseRequest> logout() async {
    // Obtener el token antes de limpiar
    final session = StorageService.instance.getSession();
    final accessToken = session?.accessToken;
    
    // Limpiar la sesión local primero para evitar que el interceptor interfiera
    _api.clearAuthToken();
    await StorageService.instance.clearUserSession();
    
    // Si hay token, intentar hacer logout en el servidor (pero no es crítico si falla)
    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        // Usar configuración fija del servidor
        final server = ApiService.getFixedServerConfig();
        if (server.host != null) {
        // Construir la URL completa para el logout
        String baseUrl = server.apiVersion != null && server.apiVersion!.isNotEmpty
            ? '${server.host}/${server.apiVersion}'
            : server.host!;
          
          final fullUrl = '$baseUrl/logout';

          // Usar dioRaw para evitar que el interceptor intercepte esta petición
          await _api.rawDio.post(
            fullUrl,
            options: Options(
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );
        }
      } catch (e) {
        // Si el logout en el servidor falla, no importa porque ya limpiamos localmente
        // Solo registramos el error pero no lo reportamos al usuario
      }
    }
    
    // Siempre retornar éxito porque la sesión local ya fue limpiada
    return ResponseRequest()
      ..success = true
      ..message = 'Sesión cerrada exitosamente';
  }

  Future<ResponseRequest> forgotPassword({required String email}) async {
    return await _api.post('/forgot-password', data: {
      'email': email,
    });
  }

  /// Refresca el token de acceso usando el refresh token
  /// NOTA: Este método usa dioRaw para evitar que el interceptor lo intercepte
  Future<ResponseRequest> refreshToken() async {
    final session = StorageService.instance.getSession();
    
    if (session == null || session.refreshToken == null || session.refreshToken!.isEmpty) {
      return ResponseRequest()
        ..success = false
        ..message = 'No hay refresh token disponible';
    }

    try {
      // Usar configuración fija del servidor
      final server = ApiService.getFixedServerConfig();

      // Construir la URL completa para el refresh token
      String baseUrl = server.apiVersion != null && server.apiVersion!.isNotEmpty
          ? '${server.host}/${server.apiVersion}'
          : server.host!;
      
      final fullUrl = '$baseUrl/clients/app/refresh';

      // Usar dioRaw para evitar que el interceptor intercepte esta petición
      final response = await _api.rawDio.post(
        fullUrl,
        data: {
          'refresh_token': session.refreshToken,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final responseRequest = ResponseRequest()
        ..statusCode = response.statusCode ?? 0;

      if (response.statusCode == 200 || response.statusCode == 201) {
        responseRequest.success = true;
        responseRequest.data = response.data is Map ? response.data : {'data': response.data};
        responseRequest.message = 'Token refrescado exitosamente';

        // Actualizar la sesión con los nuevos tokens
        final responseData = responseRequest.data;
        if (responseData != null && responseData is Map) {
          final sessionData = responseData['data'] as Map<String, dynamic>?;
          if (sessionData != null) {
            final newSession = Session.fromJson(sessionData);
            await StorageService.instance.setSession(newSession);
            
            // Actualizar el token en el ApiService
            if (newSession.accessToken != null) {
              _api.setAuthToken(newSession.accessToken!);
            }
          }
        }
      } else {
        responseRequest.success = false;
        final data = response.data;
        if (data is Map && data['message'] != null) {
          responseRequest.message = data['message'];
        } else {
          responseRequest.message = 'Error al refrescar el token';
        }
      }

      return responseRequest;
    } on DioException catch (e) {
      return ResponseRequest()
        ..success = false
        ..statusCode = e.response?.statusCode ?? 0
        ..message = e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : 'Error al refrescar el token: ${e.message ?? e.toString()}';
    } catch (e) {
      return ResponseRequest()
        ..success = false
        ..statusCode = 0
        ..message = 'Error inesperado al refrescar el token: ${e.toString()}';
    }
  }
}
