import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';

class MonitoringNutritionService {

  MonitoringNutritionService._internal();
  static final MonitoringNutritionService _instance = MonitoringNutritionService._internal();
  static MonitoringNutritionService get instance => _instance;
  factory MonitoringNutritionService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getEvaluationsByChild({required String childId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/children/$childId/nutritional-assessments',
      headers: {
      'Authorization': 'Bearer $token',
      },
      queryParams: {
        'limit': '100',
      },
    );
    return response;
  }

  Future<ResponseRequest> createEvaluation({
    required String childId,
    required String weight,
    required String height,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.post(
      '/children/$childId/nutritional-assessments',
      data: {
        'weight': weight,
        'height': height,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

}