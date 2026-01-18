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
    print('💾 DEBUG: Guardando child en storage:');
    print('  ID: ${child.id}');
    print('  Nombre: ${child.firstName} ${child.paternalLastName}');
    await storage.write('selected_child', jsonEncode(child.toMap()));
    await storage.save();
    print('✅ DEBUG: Child guardado exitosamente');
  }

  Child? getSelectedChild() {
    String? value = storage.read('selected_child');
    print('📖 DEBUG: Leyendo child desde storage:');
    print('  value existe: ${value != null}');
    if (value != null) {
      try {
        final decoded = jsonDecode(value);
        print('  decoded type: ${decoded.runtimeType}');
        print('  decoded keys: ${decoded is Map ? decoded.keys : 'N/A'}');
        
        // El child guardado desde toMap() tiene una estructura diferente
        // Necesitamos convertir strings ISO8601 a DateTime y usar fromForm()
        Map<String, dynamic> childMap;
        if (decoded is Map) {
          childMap = Map<String, dynamic>.from(decoded);
          
          // Convertir fechas de string ISO8601 a DateTime
          if (childMap['birth_date'] is String) {
            try {
              childMap['birth_date'] = DateTime.parse(childMap['birth_date']);
            } catch (e) {
              print('⚠️  WARNING: Error parseando birth_date: $e');
              childMap['birth_date'] = null;
            }
          }
          
          if (childMap['enrollment_date'] is String) {
            try {
              childMap['enrollment_date'] = DateTime.parse(childMap['enrollment_date']);
            } catch (e) {
              print('⚠️  WARNING: Error parseando enrollment_date: $e');
              childMap['enrollment_date'] = null;
            }
          }
          
          // Convertir family_members de lista de mapas a formato esperado
          if (childMap['family_members'] is List) {
            // Parsear fechas en family_members si existen
            final familyMembers = childMap['family_members'] as List;
            for (var member in familyMembers) {
              if (member is Map && member['birth_date'] is String) {
                try {
                  member['birth_date'] = DateTime.parse(member['birth_date']);
                } catch (e) {
                  member['birth_date'] = null;
                }
              }
            }
          }
          
          // Asegurar que las listas estén en el formato correcto
          if (childMap['rooms'] is! List) {
            childMap['rooms'] = [];
          }
          if (childMap['basic_services'] is! List) {
            childMap['basic_services'] = [];
          }
          
          final child = Child.fromForm(childMap, id: childMap['id']?.toString());
          print('✅ DEBUG: Child recuperado exitosamente:');
          print('  ID: ${child.id}');
          print('  Nombre: ${child.firstName} ${child.paternalLastName}');
          return child;
        } else {
          print('❌ ERROR: decoded no es un Map');
          return null;
        }
      } catch (e, stackTrace) {
        print('❌ ERROR parseando child desde storage: $e');
        print('  StackTrace: $stackTrace');
        return null;
      }
    }
    print('⚠️  WARNING: No hay child guardado en storage');
    return null;
  }

  Future<void> clearSelectedChild() async {
    await storage.remove('selected_child');
    await storage.save();
  }
}
