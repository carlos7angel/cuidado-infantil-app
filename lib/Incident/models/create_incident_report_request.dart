import 'package:file_picker/file_picker.dart';

class CreateIncidentReportRequest {
  final String childId;
  final String type;
  final String severityLevel;
  final String description;
  final String incidentDate;
  final String incidentTime;
  final String incidentLocation;
  final String peopleInvolved;
  final String? witnesses;
  final bool hasEvidence;
  final String? evidenceDescription;
  final String? actionsTaken;
  final String? additionalComments;
  final List<PlatformFile>? evidenceFiles;

  CreateIncidentReportRequest({
    required this.childId,
    required this.type,
    required this.severityLevel,
    required this.description,
    required this.incidentDate,
    required this.incidentTime,
    required this.incidentLocation,
    required this.peopleInvolved,
    this.witnesses,
    this.hasEvidence = false,
    this.evidenceDescription,
    this.actionsTaken,
    this.additionalComments,
    this.evidenceFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'child_id': childId,
      'type': type,
      'severity_level': severityLevel,
      'description': description,
      'incident_date': incidentDate,
      'incident_time': incidentTime,
      'incident_location': incidentLocation,
      'people_involved': peopleInvolved,
      'witnesses': witnesses,
      'has_evidence': hasEvidence,
      'evidence_description': evidenceDescription,
      'actions_taken': actionsTaken,
      'additional_comments': additionalComments,
    };
  }
}

