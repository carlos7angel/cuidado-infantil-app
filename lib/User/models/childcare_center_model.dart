import 'package:intl/intl.dart';

class ChildcareCenter {

  String? id;
  String? type;
  String? name;
  String? description;
  DateTime? dateFounded;
  String? address;
  String? phone;
  String? email;
  String? logo;
  String? state;
  String? city;
  String? municipality;
  String? contactName;
  String? contactPhone;
  String? contactEmail;
  DateTime? assignedAt;

  ChildcareCenter({
    this.id,
    this.type,
    this.name,
    this.description,
    this.dateFounded,
    this.address,
    this.phone,
    this.email,
    this.logo,
    this.state,
    this.city,
    this.municipality,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.assignedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'dateFounded': dateFounded != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(dateFounded!) : null,
      'address': address,
      'phone': phone,
      'email': email,
      'logo': logo,
      'state': state,
      'city': city,
      'municipality': municipality,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'assignedAt': assignedAt != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(assignedAt!) : null,
    };
  }

  static ChildcareCenter fromJson(Map<String, dynamic> json) {
    return ChildcareCenter(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      dateFounded: json['dateFounded'] != null ? DateTime.parse(json['dateFounded']) : null,
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      logo: json['logo'],
      state: json['state'],
      city: json['city'],
      municipality: json['municipality'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      contactEmail: json['contactEmail'],
      assignedAt: json['assignedAt'] != null ? DateTime.parse(json['assignedAt']) : null,
    );
  }

  /// Parsea la respuesta de la API (snake_case)
  static ChildcareCenter fromApiResponse(Map<String, dynamic> json) {
    return ChildcareCenter(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      dateFounded: json['date_founded'] != null ? DateTime.parse(json['date_founded']) : null,
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      logo: json['logo'],
      state: json['state'],
      city: json['city'],
      municipality: json['municipality'],
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      assignedAt: json['assigned_at'] != null ? DateTime.parse(json['assigned_at']) : null,
    );
  }
}
