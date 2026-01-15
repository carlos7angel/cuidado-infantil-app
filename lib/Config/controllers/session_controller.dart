import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/User/models/childcare_center_model.dart';
import 'package:cuidado_infantil/User/models/user_model.dart';
import 'package:get/get.dart';

/// Controlador global que mantiene los datos de la sesión del usuario.
/// Se inicializa una vez y permanece disponible en toda la app.
class SessionController extends GetxController {

  User? user;
  ChildcareCenter? childcareCenter;

  @override
  void onInit() {
    super.onInit();
    // Cargar datos del storage al iniciar (por si ya hay sesión guardada)
    loadSession();
  }

  bool get isLoggedIn => user != null;
  
  String get displayName => user?.educator?.fullName ?? user?.username ?? 'Usuario';
  
  String get initials {
    final name = displayName;
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Carga los datos del storage. Llamar después del login.
  void loadSession() {
    user = StorageService.instance.getUser();
    childcareCenter = StorageService.instance.getChildcareCenter();
    update();
  }

  /// Limpia los datos de sesión. Llamar en logout.
  void clearSession() {
    user = null;
    childcareCenter = null;
    update();
  }
}

