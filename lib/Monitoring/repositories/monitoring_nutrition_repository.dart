import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Monitoring/models/create_nutritional_assessment_request.dart';
import 'package:cuidado_infantil/Monitoring/services/monitoring_nutrition_service.dart';

class MonitoringNutritionRepository {

  Future<ResponseRequest> getEvaluationsByChild({required String childId}) async => await MonitoringNutritionService().getEvaluationsByChild(childId: childId);

  Future<ResponseRequest> createEvaluation({
    required CreateNutritionalAssessmentRequest request,
  }) async => await MonitoringNutritionService().createEvaluation(
    request: request,
  );

}
