class UpdateIncidentReportRequest {
  final String description;
  final String? actionsTaken;
  final String? additionalComments;
  final String? followUpNotes;
  final String? authorityNotificationDetails;

  UpdateIncidentReportRequest({
    required this.description,
    this.actionsTaken,
    this.additionalComments,
    this.followUpNotes,
    this.authorityNotificationDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'actions_taken': actionsTaken,
      'additional_comments': additionalComments,
      'follow_up_notes': followUpNotes,
      'authority_notification_details': authorityNotificationDetails,
    };
  }
}
