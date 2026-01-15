import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';

class MonitoringDevelopmentService {

  MonitoringDevelopmentService._internal();
  static final MonitoringDevelopmentService _instance = MonitoringDevelopmentService._internal();
  static MonitoringDevelopmentService get instance => _instance;
  factory MonitoringDevelopmentService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getEvaluationsByChild({required String childId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/children/$childId/development-evaluations',
      headers: {
        'Authorization': 'Bearer $token',
      },
      queryParams: {
        'limit': '100',
      },
    );
    return response;
  }

  Future<ResponseRequest> getDevelopmentItemsByChild({required String childId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/children/$childId/development-items',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<ResponseRequest> createDevelopmentEvaluation({
    required String childId,
    required List<String> items,
    String? notes,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final body = {
      'items': items,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    final response = await _api.post(
      '/children/$childId/development-evaluations',
      data: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<ResponseRequest> getEvaluationById({required String evaluationId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/development-evaluations/$evaluationId',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

}