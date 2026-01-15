import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Monitoring/services/monitoring_vaccination_service.dart';

class MonitoringVaccinationRepository {

  Future<ResponseRequest> getVaccinationTrackingByChild({required String childId}) async => await MonitoringVaccinationService().getVaccinationTrackingByChild(childId: childId);

  Future<ResponseRequest> createVaccination({
    required String childId,
    required String vaccineDoseId,
    required String dateApplied,
    required String appliedAt,
    String? notes,
  }) async => await MonitoringVaccinationService().createVaccination(
    childId: childId,
    vaccineDoseId: vaccineDoseId,
    dateApplied: dateApplied,
    appliedAt: appliedAt,
    notes: notes,
  );

  Future<ResponseRequest> deleteVaccination({
    required String childVaccinationId,
  }) async => await MonitoringVaccinationService().deleteVaccination(
    childVaccinationId: childVaccinationId,
  );

}