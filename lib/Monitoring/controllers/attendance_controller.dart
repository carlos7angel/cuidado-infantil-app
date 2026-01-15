import 'package:carousel_slider/carousel_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/attendance_day.dart';
import 'package:cuidado_infantil/Monitoring/models/attendance_response.dart';
import 'package:cuidado_infantil/Monitoring/models/attendance_child.dart';
import 'package:cuidado_infantil/Monitoring/models/room.dart';
import 'package:cuidado_infantil/Monitoring/repositories/Attendance_repository.dart';
import 'package:cuidado_infantil/Monitoring/repositories/childcare_center_repository.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final CarouselSliderController _carouselController = CarouselSliderController();
  CarouselSliderController get carouselController => _carouselController;
  
  int _currentTab = 0;
  int get currentTab => _currentTab;
  
  bool _loading = true;
  bool get loading => _loading;

  List<AttendanceDay> _listAttendanceDay = [];
  List<AttendanceDay> get listAttendanceDay => _listAttendanceDay;

  List<AttendanceChild> _children = [];
  List<AttendanceChild> get children => _children;

  List<AttendanceChild> _searchChildList = [];
  List<AttendanceChild> get searchChildList => _searchChildList;

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  Set<String> _selectedRoomIds = {};
  Set<String> get selectedRoomIds => _selectedRoomIds;

  AttendanceResponse? _attendanceResponse;
  AttendanceResponse? get attendanceResponse => _attendanceResponse;

  String? _selectedDate;
  String? get selectedDate => _selectedDate;

  String _currentSearchQuery = '';
  
  bool _needsCarouselAnimation = false;
  bool get needsCarouselAnimation => _needsCarouselAnimation;
  void clearCarouselAnimationFlag() => _needsCarouselAnimation = false;

  @override
  void onInit() {
    super.onInit();
    // Diferir la carga hasta después del build
    Future.microtask(() {
      loadRooms();
    loadAttendance();
    });
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
        update(['list_child']);
      }
    } catch (e) {
      print('❌ ERROR cargando rooms: $e');
    }
  }

  Future<void> loadAttendance({DateTime? selectedDate}) async {
    _loading = true;
    update(['list_child']);

    // Esperar a que el contexto esté disponible
    await Future.delayed(Duration(milliseconds: 100));
    
    final context = Get.overlayContext;
    if (context == null) {
      print('⚠️  WARNING: overlayContext no disponible, reintentando...');
      await Future.delayed(Duration(milliseconds: 200));
    }
    
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      final customDialog = CustomDialog(context: overlayContext);
      customDialog.show();

      try {
        final response = await AttendanceRepository().getAttendance(selectedDate: selectedDate);

        customDialog.hide();

        if (!response.success) {
          if (overlayContext.mounted) {
            CustomSnackBar(context: overlayContext).show(
              message: 'No se pudieron cargar los datos de asistencia. ${response.message}'
            );
          }
          _loading = false;
          update(['list_child']);
          return;
        }

        // Parsear la respuesta
        dynamic responseData = response.data;
        Map<String, dynamic>? attendanceData;

        if (responseData is Map) {
          if (responseData.containsKey('data')) {
            attendanceData = responseData['data'] as Map<String, dynamic>?;
          } else {
            attendanceData = responseData as Map<String, dynamic>?;
          }
        }

        if (attendanceData != null) {
          _attendanceResponse = AttendanceResponse.fromMap(attendanceData);
          _children = _attendanceResponse!.children;
          
          // Ordenar children por apellido paterno, luego materno, luego nombre
          _children.sort(_sortChildren);
          
          print('✅ DEBUG: Datos cargados - ${_children.length} children, ${_attendanceResponse!.dates.length} fechas');
          
          // Limpiar filtros al cargar nueva fecha
          _currentSearchQuery = '';
          _selectedRoomIds.clear();
          
          // Inicializar lista filtrada con todos los children (ya ordenados)
          _searchChildList = List.from(_children);

          // Convertir fechas a AttendanceDay
          _listAttendanceDay = _attendanceResponse!.dates.asMap().entries.map((entry) {
            final index = entry.key;
            final dateString = entry.value;
            final date = DateTime.parse(dateString);
            return AttendanceDay.fromDate(date, index);
          }).toList();

          // Determinar qué fecha seleccionar
          String targetDateString;
          if (selectedDate != null) {
            // Si se pasó una fecha específica, buscar esa fecha
            targetDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
          } else {
            // Si no, usar la fecha de hoy
            final today = DateTime.now();
            targetDateString = DateFormat('yyyy-MM-dd').format(today);
          }
          
          print('🔍 DEBUG: Buscando fecha objetivo: $targetDateString');
          print('🔍 DEBUG: Fechas disponibles: ${_attendanceResponse!.dates}');
          
          final targetIndex = _attendanceResponse!.dates.indexWhere((date) => date == targetDateString);
          
          if (targetIndex >= 0) {
            _currentTab = targetIndex;
            _selectedDate = targetDateString;
            print('✅ DEBUG: Fecha encontrada en índice $targetIndex');
          } else if (_listAttendanceDay.isNotEmpty) {
            // Si no está la fecha objetivo, usar la primera fecha disponible
            _currentTab = 0;
            _selectedDate = _attendanceResponse!.dates[0];
            print('⚠️ DEBUG: Fecha objetivo no encontrada, usando primera fecha: ${_attendanceResponse!.dates[0]}');
          }

          // Marcar que se necesita animar al carousel
          // La animación se hará desde el widget cuando esté construido
          _needsCarouselAnimation = true;
          update(['list_child']);
        } else {
          if (overlayContext.mounted) {
            CustomSnackBar(context: overlayContext).show(
              message: 'No se encontraron datos de asistencia en la respuesta'
            );
          }
        }
      } catch (e, stackTrace) {
        customDialog.hide();
        print('❌ ERROR EXCEPTION en loadAttendance:');
        print('  Error: $e');
        print('  StackTrace: $stackTrace');
        final errorContext = Get.overlayContext;
        if (errorContext != null && errorContext.mounted) {
          CustomSnackBar(context: errorContext).show(
            message: 'Error al cargar los datos: $e'
          );
        }
      } finally {
        _loading = false;
        update(['list_child']);
      }
    } else {
      print('❌ ERROR: No se pudo obtener overlayContext para mostrar diálogo');
      _loading = false;
      update(['list_child']);
    }
  }

  void setCurrentTab(int index) {
    if (index >= 0 && index < _listAttendanceDay.length) {
      _currentTab = index;
      _selectedDate = _listAttendanceDay[index].dateString;
      update(['list_child']);
    }
  }

  String getAttendanceStatusForChild(String childId) {
    if (_selectedDate == null) return 'unspecified';
    final child = _children.firstWhere(
      (c) => c.childId == childId,
      orElse: () => AttendanceChild(
        childId: '',
        fullName: '',
        firstName: '',
        paternalLastName: '',
        maternalLastName: '',
        birthDate: '',
        gender: '',
        roomId: '',
        roomName: '',
        attendance: {},
      ),
    );
    return child.getAttendanceStatus(_selectedDate!);
  }

  /// Toggle de selección de room para filtro
  void toggleRoomFilter(String roomId) {
    if (_selectedRoomIds.contains(roomId)) {
      _selectedRoomIds.remove(roomId);
    } else {
      _selectedRoomIds.add(roomId);
    }
    _applyFilters();
  }

  /// Limpia todos los filtros de rooms
  void clearRoomFilters() {
    _selectedRoomIds.clear();
    _applyFilters();
  }

  /// Filtra la lista de children basado en el query de búsqueda
  void filterChildren(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  /// Aplica todos los filtros (búsqueda + rooms)
  void _applyFilters() {
    List<AttendanceChild> filtered = List.from(_children);

    // Filtrar por rooms si hay alguno seleccionado
    if (_selectedRoomIds.isNotEmpty) {
      filtered = filtered.where((child) {
        if (child.roomId.isEmpty) {
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
        final fullName = child.fullName.toLowerCase();
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
        if (child.maternalLastName.isNotEmpty) {
          final maternalLastName = child.maternalLastName.toLowerCase();
          if (maternalLastName.contains(searchQuery)) {
            return true;
          }
        }
        
        // Buscar en iniciales (primera letra apellido paterno + primera letra nombre)
        final initials = (child.paternalLastName.isNotEmpty ? child.paternalLastName[0] : '') +
                        (child.firstName.isNotEmpty ? child.firstName[0] : '');
        if (initials.toLowerCase().contains(searchQuery)) {
          return true;
        }
        
        return false;
      }).toList();
    }

    // Ordenar la lista filtrada
    filtered.sort(_sortChildren);
    
    _searchChildList = filtered;
    update(['list_child']);
  }

  /// Método de comparación para ordenar children por apellido paterno, luego materno, luego nombre
  int _sortChildren(AttendanceChild a, AttendanceChild b) {
    // Comparar apellido paterno
    final paternalA = a.paternalLastName.toLowerCase().trim();
    final paternalB = b.paternalLastName.toLowerCase().trim();
    if (paternalA != paternalB) {
      return paternalA.compareTo(paternalB);
    }
    
    // Si los apellidos paternos son iguales, comparar apellido materno
    final maternalA = a.maternalLastName.toLowerCase().trim();
    final maternalB = b.maternalLastName.toLowerCase().trim();
    if (maternalA != maternalB) {
      return maternalA.compareTo(maternalB);
    }
    
    // Si ambos apellidos son iguales, comparar nombre
    final firstNameA = a.firstName.toLowerCase().trim();
    final firstNameB = b.firstName.toLowerCase().trim();
    return firstNameA.compareTo(firstNameB);
  }

  /// Limpia todos los filtros (búsqueda y rooms) y muestra todos los children
  void clearAllFilters() {
    _currentSearchQuery = '';
    _selectedRoomIds.clear();
    _searchChildList = List.from(_children);
    // Asegurar que esté ordenada (aunque _children ya debería estar ordenada)
    _searchChildList.sort(_sortChildren);
    update(['list_child']);
  }

  List<AttendanceChild> getChildrenForSelectedDate() {
    return _children;
  }

  /// Guarda la asistencia de un child
  Future<bool> saveAttendance(String childId, String status) async {
    if (_selectedDate == null) {
      print('❌ ERROR: No hay fecha seleccionada');
      return false;
    }

    try {
      final attendanceDate = DateTime.parse(_selectedDate!);
      
      final response = await AttendanceRepository().saveAttendance(
        childId: childId,
        attendanceStatus: status,
        attendanceDate: attendanceDate,
      );

      if (!response.success) {
        print('❌ ERROR al guardar asistencia: ${response.message}');
        return false;
      }

      // Actualizar el estado local del child
      final childIndex = _children.indexWhere((c) => c.childId == childId);
      if (childIndex >= 0) {
        // Actualizar el mapa de attendance del child
        final updatedAttendance = Map<String, String>.from(_children[childIndex].attendance);
        updatedAttendance[_selectedDate!] = status;
        
        // Crear un nuevo AttendanceChild con el attendance actualizado usando copyWith
        final updatedChild = _children[childIndex].copyWith(attendance: updatedAttendance);
        
        _children[childIndex] = updatedChild;
        
        // Re-aplicar filtros para actualizar la lista filtrada
        _applyFilters();
      }

      return true;
    } catch (e, stackTrace) {
      print('❌ ERROR EXCEPTION en saveAttendance:');
      print('  Error: $e');
      print('  StackTrace: $stackTrace');
      return false;
    }
  }

  /// Verifica si el child ya tiene un registro de asistencia para la fecha seleccionada
  bool hasAttendanceRecord(String childId) {
    if (_selectedDate == null) return false;
    final status = getAttendanceStatusForChild(childId);
    return status != 'unspecified';
  }

  /// Obtiene el estado actual de asistencia del child
  String getCurrentAttendanceStatus(String childId) {
    return getAttendanceStatusForChild(childId);
  }

  /// Verifica si la fecha de hoy está en la lista actual del carousel
  /// Si está, mueve el carousel a esa fecha sin llamar al endpoint
  /// Retorna true si la fecha fue encontrada y el carousel fue movido, false si no está en la lista
  bool goToTodayIfAvailable() {
    if (_listAttendanceDay.isEmpty) {
      return false;
    }

    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);
    
    // Buscar la fecha de hoy en la lista actual
    final todayIndex = _listAttendanceDay.indexWhere((day) => day.dateString == todayString);
    
    if (todayIndex >= 0) {
      // La fecha de hoy está en la lista, solo mover el carousel
      _currentTab = todayIndex;
      _selectedDate = todayString;
      
      // Animar el carousel a la posición de hoy
      if (_carouselController.ready) {
        _carouselController.animateToPage(todayIndex);
      }
      
      update(['list_child']);
      print('✅ DEBUG: Fecha de hoy encontrada en índice $todayIndex, moviendo carousel sin llamar endpoint');
      return true;
    }
    
    print('⚠️ DEBUG: Fecha de hoy ($todayString) no está en la lista actual, se llamará al endpoint');
    return false;
  }
}
