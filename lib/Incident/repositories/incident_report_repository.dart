import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Incident/models/create_incident_report_request.dart';
import 'package:cuidado_infantil/Incident/models/update_incident_report_request.dart';
import 'package:cuidado_infantil/Incident/services/incident_report_service.dart';

class IncidentReportRepository {

  Future<ResponseRequest> getIncidentReportsByChildcareCenter({
    required String childcareCenterId,
    int page = 1,
    int limit = 10,
  }) async => 
    await IncidentReportService().getIncidentReportsByChildcareCenter(
      childcareCenterId: childcareCenterId,
      page: page,
      limit: limit,
    );

  Future<ResponseRequest> createIncidentReport({
    required CreateIncidentReportRequest request,
  }) async =>
    await IncidentReportService().createIncidentReport(request: request);

  Future<ResponseRequest> updateIncidentReport({
    required String incidentReportId,
    required UpdateIncidentReportRequest request,
  }) async =>
    await IncidentReportService().updateIncidentReport(
      incidentReportId: incidentReportId,
      request: request,
    );

  Future<ResponseRequest> getIncidentReportById({
    required String incidentReportId,
  }) async =>
    await IncidentReportService().getIncidentReportById(
      incidentReportId: incidentReportId,
    );

}

