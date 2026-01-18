import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/repositories/child_repository.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Monitoring/models/room.dart';
import 'package:cuidado_infantil/Monitoring/repositories/childcare_center_repository.dart';
import 'package:get/get.dart';

class ChildListController extends GetxController {

  List<Child> _childList = [];
  List<Child> get childList => _childList;

  List<Child> _searchChildList = [];
  List<Child> get searchChildList => _searchChildList;

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  Set<String> _selectedRoomIds = {};
  Set<String> get selectedRoomIds => _selectedRoomIds;

  bool _loading = true;
  bool get loading => _loading;

  @override
  void onInit() {
    loadRooms();
    loadChildren();
    super.onInit();
  }

  Future<void> loadChildren() async {
    _loading = true;
    update(['list_child']);

    try {
      final childcareCenterId = StorageService.instance.getChildcareCenter()?.id;
      
      if (childcareCenterId == null) {
        CustomSnackBar(context: Get.overlayContext!).show(
          message: 'No se encontró el centro de cuidado infantil'
        );
        _loading = false;
        update(['list_child']);
        return;
      }

      final response = await ChildRepository().getChildrenByChildcareCenter(
        childcareCenterId: childcareCenterId.toString()
      );
      
      if (!response.success) {
        CustomSnackBar(context: Get.overlayContext!).show(
          message: 'No se pudieron cargar los registros. ${response.message}'
        );
        _loading = false;
        update(['list_child']);
        return;
      }

      // El API puede retornar { "data": [...] } o directamente un array
      dynamic childrenData = response.data['data'];
      if (childrenData == null && response.data is List) {
        childrenData = response.data;
      }

      _childList.clear();
      if (childrenData != null && childrenData is List && childrenData.isNotEmpty) {
        _childList = childrenData.map((json) {
          try {
            return Child.fromMap(json as Map<String, dynamic>);
          } catch (e) {
            print('⚠️ Error parseando child: $e');
            return null;
          }
        }).whereType<Child>().toList();
        
        // Ordenar por apellido paterno
        _childList.sort((a, b) {
          final aPaternal = a.paternalLastName.toLowerCase();
          final bPaternal = b.paternalLastName.toLowerCase();
          return aPaternal.compareTo(bPaternal);
        });

        print('✅ DEBUG: ${_childList.length} children cargados');
        print(_childList[0]);
        
        // Inicializar la lista filtrada con todos los children
        _searchChildList = List.from(_childList);
      } else {
        _searchChildList.clear();
      }

      print('✅ DEBUG: ${_childList.length} children cargados y ordenados');
    } catch (e) {
      print('❌ ERROR cargando children: $e');
      CustomSnackBar(context: Get.overlayContext!).show(
        message: 'Error al cargar los registros: $e'
      );
    } finally {
      _loading = false;
      update(['list_child']);
    }
  }

  /// Carga los rooms desde el endpoint
  Future<void> loadRooms() async {
    try {
      final response = await ChildcareCenterRepository().getCurrentChildcareCenter();
      if (!response.success) {
        print('⚠️ No se pudieron cargar los rooms: ${response.message}');
        return;
      }

      final childcareCenterData = response.data['data'] as Map<String, dynamic>?;
      if (childcareCenterData == null) return;

      final roomsData = childcareCenterData['active_rooms']?['data'] as List?;
      if (roomsData != null && roomsData.isNotEmpty) {
        _rooms = roomsData.map((json) => Room.fromMap(json as Map<String, dynamic>)).toList();
        print('✅ DEBUG: ${_rooms.length} rooms cargados');
      }
    } catch (e) {
      print('❌ ERROR cargando rooms: $e');
    }
  }

  /// Toggle de selección de room para filtro
  void toggleRoomFilter(String roomId) {
    if (_selectedRoomIds.contains(roomId)) {
      _selectedRoomIds.remove(roomId);
    } else {
      _selectedRoomIds.add(roomId);
    }
    applyFilters();
  }

  /// Limpia todos los filtros de rooms
  void clearRoomFilters() {
    _selectedRoomIds.clear();
    applyFilters();
  }

  /// Aplica todos los filtros (búsqueda + rooms)
  void applyFilters() {
    _applyFilters();
  }

  /// Filtra la lista de children basado en el query de búsqueda y rooms seleccionados
  void filterChildren(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  String _currentSearchQuery = '';

  void _applyFilters() {
    List<Child> filtered = List.from(_childList);

    // Filtrar por rooms si hay alguno seleccionado
    if (_selectedRoomIds.isNotEmpty) {
      filtered = filtered.where((child) {
        if (child.roomId == null || child.roomId!.isEmpty) {
          return false; // Si el child no tiene room, no se muestra cuando hay filtros
        }
        return _selectedRoomIds.contains(child.roomId);
      }).toList();
    }

    // Filtrar por búsqueda de texto si hay query
    if (_currentSearchQuery.isNotEmpty && _currentSearchQuery.trim().isNotEmpty) {
      final searchQuery = _currentSearchQuery.toLowerCase().trim();
      
      filtered = filtered.where((child) {
        // Buscar en nombre completo
        final fullName = child.getFullName().toLowerCase();
        if (fullName.contains(searchQuery)) {
          return true;
        }
        
        // Buscar en nombre
        final firstName = child.firstName.toLowerCase();
        if (firstName.contains(searchQuery)) {
          return true;
        }
        
        // Buscar en apellido paterno
        final paternalLastName = child.paternalLastName.toLowerCase();
        if (paternalLastName.contains(searchQuery)) {
          return true;
        }
        
        // Buscar en apellido materno
        if (child.maternalLastName != null) {
          final maternalLastName = child.maternalLastName!.toLowerCase();
          if (maternalLastName.contains(searchQuery)) {
            return true;
          }
        }
        
        // Buscar en iniciales
        final initials = child.getInitials().toLowerCase();
        if (initials.contains(searchQuery)) {
          return true;
        }
        
        return false;
      }).toList();
    }

    _searchChildList = filtered;
    update(['list_child']);
  }

  /// Limpia todos los filtros (búsqueda y rooms) y muestra todos los children
  void clearAllFilters() {
    _currentSearchQuery = '';
    _selectedRoomIds.clear();
    _searchChildList = List.from(_childList);
    update(['list_child']);
  }
}