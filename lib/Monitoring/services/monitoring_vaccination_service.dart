import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';

class MonitoringVaccinationService {

  MonitoringVaccinationService._internal();
  static final MonitoringVaccinationService _instance = MonitoringVaccinationService._internal();
  static MonitoringVaccinationService get instance => _instance;
  factory MonitoringVaccinationService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getVaccinationTrackingByChild({required String childId}) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/children/$childId/vaccination-tracking',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<ResponseRequest> createVaccination({
    required String childId,
    required String vaccineDoseId,
    required String dateApplied,
    required String appliedAt,
    String? notes,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final body = {
      'vaccine_dose_id': vaccineDoseId,
      'date_applied': dateApplied,
      'applied_at': appliedAt,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    final response = await _api.post(
      '/children/$childId/vaccinations',
      data: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<ResponseRequest> deleteVaccination({
    required String childVaccinationId,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    print('🔍 DEBUG deleteVaccination:');
    print('  childVaccinationId: $childVaccinationId');
    print('  endpoint: /child-vaccinations/$childVaccinationId/delete');
    print('  token: ${token != null ? "present" : "null"}');
    
    final response = await _api.post(
      '/child-vaccinations/$childVaccinationId/delete',
      data: {}, // Enviar body vacío
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    print('📡 DEBUG deleteVaccination response:');
    print('  statusCode: ${response.statusCode}');
    print('  success: ${response.success}');
    print('  message: ${response.message}');
    print('  data: ${response.data}');
    
    return response;
  }

}