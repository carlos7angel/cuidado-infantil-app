import 'dart:convert';

import 'package:cuidado_infantil/Auth/models/server_model.dart';
import 'package:cuidado_infantil/Auth/models/session_model.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/User/models/childcare_center_model.dart';
import 'package:cuidado_infantil/User/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService._internal();
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;

  GetStorage storage = GetStorage();

  /// Session data ------------------------------------------------------------

  Future<void> setSession(Session session) async {
    await storage.write('session', jsonEncode(session.toJson()));
    await storage.save();
  }

  Session? getSession() {
    String? value = storage.read('session');
    return value != null ? Session.fromJson(jsonDecode(value)) : null;
  }

  /// Limpia la sesión del usuario y datos relacionados
  Future<void> clearUserSession() async {
    await storage.remove('session');
    await storage.remove('user');
    await storage.remove('childcare_center');
    await storage.remove('selected_child');
  }

    /// Server data ------------------------------------------------------------

  Future<void> setServer(Server server) async {
    await storage.write('server', jsonEncode(server.toJson()));
    await storage.save();
  }

  Server? getServer() {
    String? value = storage.read('server');
    return value != null ? Server.fromJson(jsonDecode(value)) : null;
  }

  /// User data ------------------------------------------------------------

  Future<void> setUser(User user) async {
    await storage.write('user', jsonEncode(user.toJson()));
    await storage.save();
  }

  User? getUser() {
    String? value = storage.read('user');
    return value != null ? User.fromJson(jsonDecode(value)) : null;
  }

  /// Childcare center data ------------------------------------------------------------

  Future<void> setChildcareCenter(ChildcareCenter childcareCenter) async {
    await storage.write('childcare_center', jsonEncode(childcareCenter.toJson()));
    await storage.save();
  }

  ChildcareCenter? getChildcareCenter() {
    String? value = storage.read('childcare_center');
    return value != null ? ChildcareCenter.fromJson(jsonDecode(value)) : null;
  }

  /// Selected child data ------------------------------------------------------------

  Future<void> setSelectedChild(Child child) async {
    await storage.write('selected_child', jsonEncode(child.toMap()));
    await storage.save();
  }

  Child? getSelectedChild() {
    String? value = storage.read('selected_child');
    if (value != null) {
      try {
        final decoded = jsonDecode(value);
        return _parseChildData(decoded);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Child? _parseChildData(dynamic decoded) {
    // El child guardado desde toMap() tiene una estructura diferente
    // Necesitamos convertir strings ISO8601 a DateTime y usar fromForm()
    if (decoded is! Map) return null;

    final childMap = Map<String, dynamic>.from(decoded);
    
    // Convertir fechas de string ISO8601 a DateTime
    _parseDateFields(childMap);
    
    // Convertir family_members
    _parseFamilyMembers(childMap);
    
    // Asegurar listas
    if (childMap['rooms'] is! List) childMap['rooms'] = [];
    if (childMap['basic_services'] is! List) childMap['basic_services'] = [];
    
    return Child.fromForm(childMap, id: childMap['id']?.toString());
  }

  void _parseDateFields(Map<String, dynamic> map) {
    if (map['birth_date'] is String) {
      try {
        map['birth_date'] = DateTime.parse(map['birth_date']);
      } catch (_) {
        map['birth_date'] = null;
      }
    }
    
    if (map['enrollment_date'] is String) {
      try {
        map['enrollment_date'] = DateTime.parse(map['enrollment_date']);
      } catch (_) {
        map['enrollment_date'] = null;
      }
    }
  }

  void _parseFamilyMembers(Map<String, dynamic> childMap) {
    if (childMap['family_members'] is List) {
      final familyMembers = childMap['family_members'] as List;
      for (var member in familyMembers) {
        if (member is Map && member['birth_date'] is String) {
          try {
            member['birth_date'] = DateTime.parse(member['birth_date']);
          } catch (_) {
            member['birth_date'] = null;
          }
        }
      }
    }

  }

  Future<void> clearSelectedChild() async {
    await storage.remove('selected_child');
    await storage.save();
  }
}
