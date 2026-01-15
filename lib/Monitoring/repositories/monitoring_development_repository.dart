import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Monitoring/services/monitoring_development_service.dart';

class MonitoringDevelopmentRepository {

  Future<ResponseRequest> getEvaluationsByChild({required String childId}) async => 
    await MonitoringDevelopmentService().getEvaluationsByChild(childId: childId);

  Future<ResponseRequest> getDevelopmentItemsByChild({required String childId}) async => 
    await MonitoringDevelopmentService().getDevelopmentItemsByChild(childId: childId);

  Future<ResponseRequest> createDevelopmentEvaluation({
    required String childId,
    required List<String> items,
    String? notes,
  }) async => 
    await MonitoringDevelopmentService().createDevelopmentEvaluation(
      childId: childId,
      items: items,
      notes: notes,
    );

  Future<ResponseRequest> getEvaluationById({required String evaluationId}) async => 
    await MonitoringDevelopmentService().getEvaluationById(evaluationId: evaluationId);

}

