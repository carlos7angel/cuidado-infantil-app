import 'package:intl/intl.dart';

class Educator {

  String? id;
  String? firstName;
  String? lastName;
  String? fullName;  
  String? gender;
  DateTime? birthdate;
  String? phone;
  String? dni;
  String? state;

  Educator({this.id, this.firstName, this.lastName, this.fullName, this.gender, this.birthdate, this.phone, this.dni, this.state});

  Map<String, dynamic> toJson() {
    var mapData = <String, dynamic>{};
    mapData['id'] = id;
    mapData['firstName'] = firstName;
    mapData['lastName'] = lastName;
    mapData['fullName'] = fullName;
    mapData['gender'] = gender;
    mapData['birthdate'] = birthdate != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(birthdate!) : null;
    mapData['phone'] = phone;
    mapData['dni'] = dni;
    mapData['state'] = state;
    return mapData;
  }

  static Educator fromJson(Map<String, dynamic> json) {
    return Educator(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      gender: json['gender'],
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      phone: json['phone'],
      dni: json['dni'],
      state: json['state'],
    );
  }

  /// Parsea la respuesta de la API (snake_case)
  static Educator fromApiResponse(Map<String, dynamic> json) {
    return Educator(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      gender: json['gender'],
      birthdate: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      phone: json['phone'],
      dni: json['dni'],
      state: json['state'],
    );
  }
  
}