import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Monitoring/services/monitoring_nutrition_service.dart';

class MonitoringNutritionRepository {

  Future<ResponseRequest> getEvaluationsByChild({required String childId}) async => await MonitoringNutritionService().getEvaluationsByChild(childId: childId);

  Future<ResponseRequest> createEvaluation({
    required String childId,
    required String weight,
    required String height,
  }) async => await MonitoringNutritionService().createEvaluation(
    childId: childId,
    weight: weight,
    height: height,
  );

}