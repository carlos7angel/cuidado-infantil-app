import 'dart:async';
import 'dart:io';
import 'package:cuidado_infantil/Auth/models/server_model.dart';
import 'package:cuidado_infantil/Auth/models/session_model.dart';
import 'package:cuidado_infantil/Auth/repositories/auth_repository.dart';
import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:dio/dio.dart' as dio_lib show Response;
import 'package:dio/io.dart';
import 'package:get/get.dart';

class ApiService {

  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  static ApiService get instance => _instance;
  factory ApiService() => _instance;

  final Dio dioRaw = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 1000),
    receiveTimeout: const Duration(seconds: 1000),
    contentType: Headers.jsonContentType,
    headers: {Headers.acceptHeader: Headers.jsonContentType},
  ))..httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      // SOLO PARA DESARROLLO/STAGING - NO USAR EN PRODUCCIÓN
      // Ignora la validación de certificados SSL
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    },
  );

  /// Configura el HttpClientAdapter para ignorar la validación de certificados SSL
  /// SOLO PARA DESARROLLO/STAGING - NO USAR EN PRODUCCIÓN
  void _configureHttpClientAdapter(Dio dioInstance) {
    if (dioInstance.httpClientAdapter is IOHttpClientAdapter) {
      (dioInstance.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  late Dio dio;
  
  // Variable para controlar si se está refrescando el token
  bool _isRefreshing = false;
  // Completer que se resuelve cuando se completa el refresh
  Completer<String?>? _refreshCompleter;

  /// Construye la URL base completa desde un Server object
  String _buildBaseUrl(Server server) {
    if (server.apiVersion != null && server.apiVersion!.isNotEmpty) {
      return '${server.host}/${server.apiVersion}';
    }
    return server.host!;
  }

  /// Inicializa la configuración leyendo del storage (solo lectura)
  void init() {
    final Server? server = StorageService.instance.getServer();
    String baseUrl = '';

    if (server?.host != null) {
      baseUrl = _buildBaseUrl(server!);
    }

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 1000),
      receiveTimeout: const Duration(seconds: 1000),
      contentType: Headers.jsonContentType,
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    ));
    _configureHttpClientAdapter(dio);
    
    // Configurar el token inicial si existe
    final session = StorageService.instance.getSession();
    if (session?.accessToken != null) {
      setAuthToken(session!.accessToken!);
    }
    
    // Agregar el interceptor para manejo automático de tokens y refresh
    // Verificar que no se agregue múltiples veces
    bool hasAuthInterceptor = dio.interceptors.any((interceptor) => interceptor is _AuthInterceptor);
    if (!hasAuthInterceptor) {
      dio.interceptors.add(_AuthInterceptor(this));
    }
  }

  /// Actualiza la URL base (lectura + escritura)
  void updateBaseUrl(Server server) {
    dio.options.baseUrl = _buildBaseUrl(server);
    
    // Asegurar que el interceptor esté presente después de actualizar la URL
    bool hasAuthInterceptor = dio.interceptors.any((interceptor) => interceptor is _AuthInterceptor);
    if (!hasAuthInterceptor) {
      dio.interceptors.add(_AuthInterceptor(this));
    }
    
    // Restaurar el token si existe después de actualizar la URL
    final session = StorageService.instance.getSession();
    if (session?.accessToken != null) {
      setAuthToken(session!.accessToken!);
    }
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  // ============ Method helper  ============

  /// GET request
  Future<ResponseRequest> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() => dio.get(
      path,
      queryParameters: queryParams,
      options: headers != null ? Options(headers: headers) : null,
    ));
  }

  /// POST request
  Future<ResponseRequest> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() => dio.post(
      path,
      data: data,
      options: headers != null ? Options(headers: headers) : null,
    ));
  }

  /// PUT request
  Future<ResponseRequest> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? headers,
      }) async {
    return _handleRequest(() => dio.put(
      path,
      data: data,
      options: headers != null ? Options(headers: headers) : null,
    ));
  }

  /// PATCH request
  Future<ResponseRequest> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() => dio.patch(
      path,
      data: data,
      options: headers != null ? Options(headers: headers) : null,
    ));
  }

  /// GET request to raw url
  Future<ResponseRequest> getRaw(String fullUrl) async {
    return _handleRequest(() => dioRaw.get(fullUrl));
  }

  /// Expone dioRaw para uso en métodos específicos como refreshToken
  Dio get rawDio => dioRaw;

  Future<ResponseRequest> _handleRequest(Future<dio_lib.Response> Function() request) async {
    ResponseRequest responseRequest = ResponseRequest();
    try {
      dio_lib.Response response = await request();
      
      responseRequest.statusCode = response.statusCode ?? 0;

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        responseRequest.success = true;
        // Para 204 (No Content), el body puede estar vacío o ser null
        if (response.statusCode == 204) {
          responseRequest.data = null;
        } else {
          responseRequest.data = response.data is Map ? response.data : {'data': response.data};
        }
        responseRequest.message = 'Success';  // Asignar mensaje de éxito
      } else {
        responseRequest.success = false;
        final data = response.data;
        if (data is Map && data['message'] != null) {
          responseRequest.message = data['message'];
        } else {
          responseRequest.message = 'Error en la solicitud';
        }
      }
    } on DioException catch (e) {
      responseRequest.success = false;
      responseRequest.statusCode = e.response?.statusCode ?? 0;
      responseRequest.message = _handleDioError(e);
    } catch (e) {
      responseRequest.success = false;
      responseRequest.statusCode = 0;
      responseRequest.message = 'Error inesperado: ${e.toString()}';
    }
    return responseRequest;
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado. Verifique que la URL sea correcta y que el servidor esté disponible.';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de respuesta agotado. El servidor tardó demasiado en responder.';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'];
        }
        return 'Error del servidor (${e.response?.statusCode ?? 'desconocido'})';
      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifique su conexión a internet y que la URL sea correcta.';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado';
      case DioExceptionType.badCertificate:
        return 'Error de certificado SSL. Verifique que la URL use HTTPS válido.';
      case DioExceptionType.cancel:
        return 'Solicitud cancelada';
      default:
        return 'Error de conexión: ${e.message ?? e.toString()}';
    }
  }

  /// Refresca el token y retorna el nuevo access token
  /// Si ya se está refrescando, espera a que se complete el refresh actual
  Future<String?> refreshAccessToken() async {
    // Si ya se está refrescando, esperar a que se complete
    if (_isRefreshing && _refreshCompleter != null) {
      return await _refreshCompleter!.future;
    }

    // Crear un nuevo completer para este refresh
    _refreshCompleter = Completer<String?>();
    _isRefreshing = true;
    
    try {
      final response = await AuthRepository().refreshToken();
      
      if (response.success && response.data != null) {
        // Actualizar la sesión con los nuevos tokens
        final sessionData = response.data!['data'] as Map<String, dynamic>?;
        if (sessionData != null) {
          final newSession = Session.fromJson(sessionData);
          await StorageService.instance.setSession(newSession);
          
          if (newSession.accessToken != null) {
            setAuthToken(newSession.accessToken!);
            
            // Resolver el completer con el nuevo token
            _refreshCompleter!.complete(newSession.accessToken);
            
            return newSession.accessToken;
          }
        }
      }
      
      // Si llegamos aquí, el refresh falló
      _handleRefreshFailure();
      _refreshCompleter!.complete(null);
      
    } catch (e) {
      _handleRefreshFailure();
      _refreshCompleter!.completeError(e);
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
    
    return null;
  }

  /// Maneja el fallo del refresh token
  void _handleRefreshFailure() {
    // Limpiar sesión
    StorageService.instance.remove();
    clearAuthToken();
    
    // Limpiar SessionController si existe
    try {
      if (Get.isRegistered<SessionController>()) {
        Get.find<SessionController>().clearSession();
      }
    } catch (e) {
      // SessionController no está inicializado, continuar
    }
  }
}

/// Interceptor para manejar automáticamente la autenticación y refresh de tokens
class _AuthInterceptor extends Interceptor {
  final ApiService apiService;

  _AuthInterceptor(this.apiService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Obtener el token actual
    final session = StorageService.instance.getSession();
    
    // Si hay un token y no está en los headers, agregarlo
    if (session?.accessToken != null && 
        !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer ${session!.accessToken}';
    }
    
    // Verificar si el token está expirado antes de hacer la petición
    if (session != null && session.isExpired()) {
      // El token está expirado, intentar refrescar primero
      _handleExpiredToken(options, handler);
      return;
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Si el error es 401 (Unauthorized), intentar refrescar el token
    if (err.response?.statusCode == 401) {
      _handleUnauthorized(err, handler);
      return;
    }
    
    handler.next(err);
  }

  /// Maneja el caso cuando el token está expirado
  Future<void> _handleExpiredToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = StorageService.instance.getSession();
    
    if (session == null || !session.canRefresh()) {
      // No hay refresh token, redirigir al login
      _redirectToLogin();
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: dio_lib.Response(
            statusCode: 401,
            requestOptions: options,
            data: {'message': 'Sesión expirada. Por favor inicie sesión nuevamente.'},
          ),
        ),
      );
      return;
    }

    try {
      // Intentar refrescar el token (espera si ya se está refrescando)
      final newToken = await apiService.refreshAccessToken();
      
      if (newToken != null && newToken.isNotEmpty) {
        // Token refrescado exitosamente, continuar con la petición original
        options.headers['Authorization'] = 'Bearer $newToken';
        handler.next(options);
      } else {
        // Fallo al refrescar, redirigir al login
        _redirectToLogin();
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: dio_lib.Response(
              statusCode: 401,
              requestOptions: options,
              data: {'message': 'No se pudo renovar la sesión. Por favor inicie sesión nuevamente.'},
            ),
          ),
        );
      }
    } catch (e) {
      // Error al refrescar, redirigir al login
      _redirectToLogin();
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: dio_lib.Response(
            statusCode: 401,
            requestOptions: options,
            data: {'message': 'Error al renovar la sesión. Por favor inicie sesión nuevamente.'},
          ),
        ),
      );
    }
  }

  /// Maneja errores 401 (Unauthorized) intentando refrescar el token
  Future<void> _handleUnauthorized(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    
    // Evitar loops infinitos: no intentar refresh en endpoints de autenticación
    if (requestOptions.path.contains('/login') || 
        requestOptions.path.contains('/refresh-token') ||
        requestOptions.path.contains('/refresh') ||
        requestOptions.path.contains('/logout') ||
        requestOptions.path.contains('/forgot-password')) {
      handler.next(err);
      return;
    }

    final session = StorageService.instance.getSession();
    
    if (session == null || !session.canRefresh()) {
      // No hay refresh token, redirigir al login
      _redirectToLogin();
      handler.next(err);
      return;
    }

    try {
      // Intentar refrescar el token (espera si ya se está refrescando)
      final newToken = await apiService.refreshAccessToken();
      
      if (newToken != null && newToken.isNotEmpty) {
        // Token refrescado exitosamente, reintentar la petición original
        final opts = requestOptions.copyWith(
          headers: {
            ...requestOptions.headers,
            'Authorization': 'Bearer $newToken',
          },
        );
        
        try {
          final response = await apiService.dio.fetch(opts);
          handler.resolve(response);
        } catch (e) {
          if (e is DioException) {
            // Si el error sigue siendo 401 después del refresh, redirigir al login
            if (e.response?.statusCode == 401) {
              _redirectToLogin();
            }
            handler.next(e);
          } else {
            handler.next(err);
          }
        }
      } else {
        // Fallo al refrescar, redirigir al login
        _redirectToLogin();
        handler.next(err);
      }
    } catch (e) {
      // Error al refrescar, redirigir al login
      _redirectToLogin();
      handler.next(err);
    }
  }

  /// Redirige al login cuando no se puede refrescar el token
  void _redirectToLogin() {
    // Limpiar datos de sesión
    StorageService.instance.remove();
    apiService.clearAuthToken();
    
    // Limpiar SessionController si existe
    try {
      if (Get.isRegistered<SessionController>()) {
        Get.find<SessionController>().clearSession();
      }
    } catch (e) {
      // SessionController no está inicializado, continuar
    }
    
    // Redirigir al login usando GetX
    // Nota: Esto debería manejarse en un lugar centralizado, no aquí
    // Por ahora solo limpiamos la sesión
    print('⚠️ Sesión expirada. Se requiere nuevo login.');
    
    // Redirigir al login usando GetX
    // Nota: Se redirige solo si no estamos ya en el login
    try {
      if (Get.currentRoute != '/login' && Get.currentRoute != '/server') {
        Get.offAllNamed('/server');
      }
    } catch (e) {
      // Si falla la navegación, continuar
      print('⚠️ Error al redirigir al login: $e');
    }
  }
}
