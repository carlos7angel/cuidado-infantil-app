import 'package:cuidado_infantil/User/models/educator_model.dart';

class User {

  String? id;
  String? email;
  String? username;
  String? avatar;
  Educator? educator;

  User({this.id, this.email, this.username, this.avatar, this.educator});

  Map<String, dynamic> toJson() {
    var mapData = <String, dynamic>{};
    mapData['id'] = id;
    mapData['username'] = username;
    mapData['email'] = email;
    mapData['avatar'] = avatar;
    mapData['educator'] = educator != null ? educator!.toJson() : null;
    return mapData;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        avatar: json['avatar'],
        educator: json['educator'] != null ? Educator.fromJson(json['educator']) : null,
    );
  }

  /// Parsea la respuesta completa de la API combinando data + educator.data
  static User fromApiResponse(Map<String, dynamic> json) {
    final educatorData = json['educator']?['data'];
    return User(
      id: json['id'],
      email: json['email'],
      username: json['name'],
      avatar: null,
      educator: educatorData != null ? Educator.fromApiResponse(educatorData) : null,
    );
  }
}