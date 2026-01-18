import 'dart:io';
import 'package:cuidado_infantil/Config/models/response_request.dart';
import 'package:cuidado_infantil/Config/services/api_service.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Incident/models/create_incident_report_request.dart';
import 'package:cuidado_infantil/Incident/models/update_incident_report_request.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class IncidentReportService {

  IncidentReportService._internal();
  static final IncidentReportService _instance = IncidentReportService._internal();
  static IncidentReportService get instance => _instance;
  factory IncidentReportService() => _instance;

  final ApiService _api = ApiService.instance;

  Future<ResponseRequest> getIncidentReportsByChildcareCenter({
    required String childcareCenterId,
    int page = 1,
    int limit = 10,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/childcare-centers/$childcareCenterId/incident-reports',
      headers: {
        'Authorization': 'Bearer $token',
      },
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return response;
  }

  /// Convierte un PlatformFile a MultipartFile
  Future<MultipartFile?> _fileToMultipartFile(PlatformFile file) async {
    try {
      if (file.path == null || file.path!.isEmpty) {
        return null;
      }

      final fileObj = File(file.path!);
      if (!await fileObj.exists()) {
        return null;
      }

      return await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      );
    } catch (e) {
      return null;
    }
  }

  Future<ResponseRequest> createIncidentReport({
    required CreateIncidentReportRequest request,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;

    // Crear FormData
    Map<String, dynamic> formDataMap = {
      'child_id': request.childId,
      'type': request.type,
      'description': request.description,
      'incident_date': request.incidentDate,
      'incident_time': request.incidentTime,
      'incident_location': request.incidentLocation,
      'people_involved': request.peopleInvolved,
      'witnesses': request.witnesses,
      'has_evidence': request.hasEvidence ? '1' : '0',
      'evidence_description': request.evidenceDescription,
      'actions_taken': request.actionsTaken,
      'escalated_to': request.escalatedTo,
      'additional_comments': request.additionalComments,
    };

    // Agregar archivos de evidencia si existen
    if (request.evidenceFiles != null && request.evidenceFiles!.isNotEmpty) {
      List<MultipartFile> evidenceMultipartFiles = [];
      for (final file in request.evidenceFiles!) {
        final multipartFile = await _fileToMultipartFile(file);
        if (multipartFile != null) {
          evidenceMultipartFiles.add(multipartFile);
        }
      }
      if (evidenceMultipartFiles.isNotEmpty) {
        formDataMap['evidence_files[]'] = evidenceMultipartFiles;
      }
    }

    FormData formData = FormData.fromMap(formDataMap);

    final response = await _api.post(
      '/incident-reports',
      data: formData,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  Future<ResponseRequest> updateIncidentReport({
    required String incidentReportId,
    required UpdateIncidentReportRequest request,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;

    final response = await _api.put(
      '/incident-reports/$incidentReportId',
      data: request.toJson(),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  Future<ResponseRequest> getIncidentReportById({
    required String incidentReportId,
  }) async {
    final token = StorageService.instance.getSession()?.accessToken;
    final response = await _api.get(
      '/incident-reports/$incidentReportId',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}

