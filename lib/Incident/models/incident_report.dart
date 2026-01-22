import 'package:cuidado_infantil/Incident/models/evidence_file.dart';
import 'package:cuidado_infantil/Incident/models/incident_child.dart';

class IncidentReport {
  final String? type;
  final String? id;
  final String? code;
  final String? status;
  final String? statusLabel;
  final String? typeLabel;
  final String? severityLevel;
  final String? severityLabel;
  final String? severityColor;
  final String? description;
  final String? incidentDate;
  final String? incidentDateReadable;
  final String? incidentTime;
  final String? incidentLocation;
  final String? incidentDateTimeReadable;
  final String? childId;
  final String? childName;
  final String? roomId;
  final String? roomName;
  final String? peopleInvolved;
  final String? witnesses;
  final bool hasEvidence;
  final String? evidenceDescription;
  final List<String>? evidenceFileIds;
  final int? evidenceFilesCount;
  final String? actionsTaken;
  final String? escalatedTo;
  final String? additionalComments;
  final String? followUpNotes;
  final String? authorityNotificationDetails;
  final bool isActive;
  final String? reportedAt;
  final String? reportedAtReadable;
  final String? closedDate;
  final String? createdAt;
  final String? updatedAt;
  final String? readableCreatedAt;
  // Campos del detalle completo
  final IncidentChild? child;
  final List<EvidenceFile>? evidenceFiles;

  IncidentReport({
    this.type,
    this.id,
    this.code,
    this.status,
    this.statusLabel,
    this.typeLabel,
    this.severityLevel,
    this.severityLabel,
    this.severityColor,
    this.description,
    this.incidentDate,
    this.incidentDateReadable,
    this.incidentTime,
    this.incidentLocation,
    this.incidentDateTimeReadable,
    this.childId,
    this.childName,
    this.roomId,
    this.roomName,
    this.peopleInvolved,
    this.witnesses,
    this.hasEvidence = false,
    this.evidenceDescription,
    this.evidenceFileIds,
    this.evidenceFilesCount,
    this.actionsTaken,
    this.escalatedTo,
    this.additionalComments,
    this.followUpNotes,
    this.authorityNotificationDetails,
    this.isActive = true,
    this.reportedAt,
    this.reportedAtReadable,
    this.closedDate,
    this.createdAt,
    this.updatedAt,
    this.readableCreatedAt,
    this.child,
    this.evidenceFiles,
  });

  factory IncidentReport.fromJson(Map<String, dynamic> json) {
    return IncidentReport(
      type: json['type']?.toString(),
      id: json['id']?.toString(),
      code: json['code']?.toString(),
      status: json['status']?.toString(),
      statusLabel: json['status_label']?.toString(),
      typeLabel: json['type_label']?.toString(),
      severityLevel: json['severity_level']?.toString(),
      severityLabel: json['severity_label']?.toString(),
      severityColor: json['severity_color']?.toString(),
      description: json['description']?.toString(),
      incidentDate: json['incident_date']?.toString(),
      incidentDateReadable: json['incident_date_readable']?.toString(),
      incidentTime: json['incident_time']?.toString(),
      incidentLocation: json['incident_location']?.toString(),
      incidentDateTimeReadable: json['incident_date_time_readable']?.toString(),
      childId: json['child_id']?.toString(),
      childName: json['child_name']?.toString(),
      roomId: json['room_id']?.toString(),
      roomName: json['room_name']?.toString(),
      peopleInvolved: json['people_involved']?.toString(),
      witnesses: json['witnesses']?.toString(),
      hasEvidence: json['has_evidence'] == true,
      evidenceDescription: json['evidence_description']?.toString(),
      evidenceFileIds: _parseEvidenceFileIds(json['evidence_file_ids']),
      evidenceFilesCount: json['evidence_files_count'] is int
          ? json['evidence_files_count']
          : (json['evidence_files_count'] != null ? int.tryParse(json['evidence_files_count'].toString()) : null),
      actionsTaken: json['actions_taken']?.toString(),
      escalatedTo: json['escalated_to']?.toString(),
      additionalComments: json['additional_comments']?.toString(),
      followUpNotes: json['follow_up_notes']?.toString(),
      authorityNotificationDetails: json['authority_notification_details']?.toString(),
      isActive: json['is_active'] != false,
      reportedAt: json['reported_at']?.toString(),
      reportedAtReadable: json['reported_at_readable']?.toString(),
      closedDate: json['closed_date']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      readableCreatedAt: json['readable_created_at']?.toString(),
      child: _parseChild(json['child']),
      evidenceFiles: _parseEvidenceFiles(json['evidence_files']),
    );
  }

  static IncidentChild? _parseChild(dynamic childData) {
    if (childData == null) return null;
    
    if (childData is Map) {
      if (childData['data'] != null) {
        final childDataData = childData['data'];
        if (childDataData is Map<String, dynamic>) {
          return IncidentChild.fromJson(childDataData);
        }
      }
    }
    return null;
  }

  static List<EvidenceFile>? _parseEvidenceFiles(dynamic evidenceFilesData) {
    if (evidenceFilesData == null) return null;

    if (evidenceFilesData is Map && evidenceFilesData['data'] != null) {
      final filesList = evidenceFilesData['data'] as List?;
      if (filesList != null) {
        return filesList
            .map((file) => EvidenceFile.fromJson(file as Map<String, dynamic>))
            .toList();
      }
    }
    return null;
  }

  static List<String>? _parseEvidenceFileIds(dynamic ids) {
    if (ids == null) return null;
    
    if (ids is List) {
      return ids.map((id) => id.toString()).toList();
    }
    return null;
  }


  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'code': code,
      'status': status,
      'status_label': statusLabel,
      'type_label': typeLabel,
      'severity_level': severityLevel,
      'severity_label': severityLabel,
      'severity_color': severityColor,
      'description': description,
      'incident_date': incidentDate,
      'incident_date_readable': incidentDateReadable,
      'incident_time': incidentTime,
      'incident_location': incidentLocation,
      'incident_date_time_readable': incidentDateTimeReadable,
      'child_id': childId,
      'child_name': childName,
      'room_id': roomId,
      'room_name': roomName,
      'people_involved': peopleInvolved,
      'witnesses': witnesses,
      'has_evidence': hasEvidence,
      'evidence_description': evidenceDescription,
      'evidence_file_ids': evidenceFileIds,
      'evidence_files_count': evidenceFilesCount,
      'actions_taken': actionsTaken,
      'escalated_to': escalatedTo,
      'additional_comments': additionalComments,
      'follow_up_notes': followUpNotes,
      'authority_notification_details': authorityNotificationDetails,
      'is_active': isActive,
      'reported_at': reportedAt,
      'reported_at_readable': reportedAtReadable,
      'closed_date': closedDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'readable_created_at': readableCreatedAt,
      'child': child?.toJson(),
      'evidence_files': evidenceFiles?.map((f) => f.toJson()).toList(),
    };
  }

  /// Obtiene el color basado en el nivel de severidad
  String getSeverityColor() {
    return severityColor ?? '#9E9E9E'; // Gris por defecto
  }

  /// Obtiene el icono basado en el nivel de severidad
  String getSeverityIcon() {
    switch (severityLevel?.toLowerCase()) {
      case 'leve':
        return 'info';
      case 'moderado':
        return 'warning';
      case 'grave':
        return 'error';
      case 'critico':
        return 'danger';
      default:
        return 'info';
    }
  }

  /// Obtiene el icono basado en el estado
  String getStatusIcon() {
    switch (status?.toLowerCase()) {
      case 'reportado':
        return 'report';
      case 'en_revision':
        return 'review';
      case 'cerrado':
        return 'check';
      case 'escalado':
        return 'escalate';
      case 'archivado':
        return 'archive';
      default:
        return 'info';
    }
  }

  /// Obtiene el color basado en el estado
  String getStatusColor() {
    switch (status?.toLowerCase()) {
      case 'reportado':
        return '#2196F3'; // Blue
      case 'en_revision':
        return '#FF9800'; // Orange
      case 'cerrado':
        return '#4CAF50'; // Green
      case 'escalado':
        return '#F44336'; // Red
      case 'archivado':
        return '#9E9E9E'; // Grey
      default:
        return '#9E9E9E';
    }
  }
}

