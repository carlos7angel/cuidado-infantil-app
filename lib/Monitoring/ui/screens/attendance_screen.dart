import 'package:carousel_slider/carousel_slider.dart';
import 'package:cuidado_infantil/Config/widgets/empty_list.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/filter_attendance_drawer.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/custom_dialog.dart';
import 'package:cuidado_infantil/Config/widgets/custom_snack_bar.dart';
import 'package:cuidado_infantil/Intro/ui/widgets/navigation_menu.dart';
import 'package:cuidado_infantil/Monitoring/controllers/attendance_controller.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/ui/widgets/select_attendance_dialog.dart';
import 'package:cuidado_infantil/Monitoring/models/attendance_child.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatefulWidget {
  static final String routeName = '/attendance';
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late Animation<double> animationOpacity;
  late AnimationController animationController;
  
  // Colores para el avatar (mismos que en child_list_screen)
  static final List<Color> _avatarColors = [
    Color(0xFF1ABC9C), Color(0xFF2ECC71), Color(0xFF3498DB),
    Color(0xFF9B59B6), Color(0xFF34495E), Color(0xFFF1C40F),
    Color(0xFFE67E22), Color(0xFFE74C3C), Color(0xFF95A5A6),
  ];

  Color _getAvatarColor(String? childId) {
    if (childId == null || childId.isEmpty) {
      return _avatarColors[0];
    }
    final hash = childId.hashCode;
    final index = hash.abs() % _avatarColors.length;
    return _avatarColors[index].withAlpha(900);
  }

  String _formatChildName(AttendanceChild child) {
    List<String> nameParts = [];
    
    // Agregar apellido paterno
    if (child.paternalLastName.isNotEmpty) {
      nameParts.add(child.paternalLastName.trim());
    }
    
    // Agregar apellido materno
    if (child.maternalLastName.isNotEmpty) {
      nameParts.add(child.maternalLastName.trim());
    }
    
    // Si hay apellidos, agregar coma
    String lastNamePart = nameParts.join(' ');
    if (lastNamePart.isNotEmpty && child.firstName.isNotEmpty) {
      lastNamePart += ', ';
    }
    
    // Agregar nombres
    String firstNamePart = child.firstName.trim();
    
    String fullName = lastNamePart + firstNamePart;
    
    return fullName.isNotEmpty ? fullName : 'Sin nombre';
  }

  String _getInitials(AttendanceChild child) {
    String paternalInitial = '';
    String firstNameInitial = '';
    
    if (child.paternalLastName.isNotEmpty) {
      paternalInitial = child.paternalLastName.trim()[0].toUpperCase();
    }
    
    if (child.firstName.isNotEmpty) {
      firstNameInitial = child.firstName.trim()[0].toUpperCase();
    }
    
    if (paternalInitial.isEmpty && firstNameInitial.isEmpty) {
      return '?';
    }
    
    return paternalInitial + firstNameInitial;
  }


  Color _getAttendanceStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'presente':
        return Colors.green;
      case 'falta':
        return Colors.red;
      case 'retraso':
        return Colors.blue;
      case 'justificado':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'presente':
        return Icons.check;
      case 'falta':
        return Icons.close;
      case 'retraso':
        return Icons.access_time;
      case 'justificado':
        return Icons.flag_outlined;
      default:
        return Icons.question_mark;
    }
  }

  String _formatDateForDisplay(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'presente':
        return 'Presente';
      case 'falta':
        return 'Falta';
      case 'retraso':
        return 'Retraso';
      case 'justificado':
        return 'Justificado';
      default:
        return 'Sin especificar';
    }
  }

  Future<void> _handleSaveAttendance(BuildContext context, AttendanceController controller, AttendanceChild child, String newStatus) async {
    final currentStatus = controller.getCurrentAttendanceStatus(child.childId);
    final hasRecord = controller.hasAttendanceRecord(child.childId);

    // Si ya tiene el mismo estado, no hacer nada
    if (hasRecord && currentStatus.toLowerCase() == newStatus.toLowerCase()) {
      return;
    }

    // Si ya tiene un registro diferente, mostrar confirmación
    if (hasRecord && currentStatus.toLowerCase() != newStatus.toLowerCase()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text('Confirmar cambio', style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.secondary))),
            content: Text(
              'El infante ${child.fullName} ya tiene registrado "${_getStatusDisplayName(currentStatus)}" para esta fecha.\n\n'
              '¿Deseas cambiar el estado a "${_getStatusDisplayName(newStatus)}"?',
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontWeight: FontWeight.w500)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w700, fontSize: 16.sp)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Confirmar', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w700, fontSize: 16.sp)),
              ),
            ],
          );
        },
      );

      if (confirmed != true) {
        return; // Usuario canceló
      }
    }

    // Mostrar loading
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      final customDialog = CustomDialog(context: overlayContext);
      customDialog.show();

      try {
        final success = await controller.saveAttendance(child.childId, newStatus);
        customDialog.hide();

        if (!success) {
          CustomSnackBar(context: overlayContext).show(
            message: 'No se pudo registrar la asistencia. Intenta nuevamente.',
            title: 'Error',
          );
        }
      } catch (e) {
        customDialog.hide();
        if (overlayContext.mounted) {
          CustomSnackBar(context: overlayContext).show(
            message: 'Error al registrar asistencia: $e',
            title: 'Error',
          );
        }
      }
    }
  }

  Future<void> _handleSimpleTap(BuildContext context, AttendanceController controller, AttendanceChild child) async {
    final currentStatus = controller.getCurrentAttendanceStatus(child.childId);
    final hasRecord = controller.hasAttendanceRecord(child.childId);

    // Si ya tiene 'present', no hacer nada
    if (hasRecord && (currentStatus.toLowerCase() == 'present' || currentStatus.toLowerCase() == 'presente')) {
      return;
    }

    // Guardar como 'present'
    await _handleSaveAttendance(context, controller, child, 'presente');
  }

  Future<void> _handleLongPress(BuildContext context, AttendanceController controller, AttendanceChild child) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectAttendanceDialog(
        onStatusSelected: (status) async {
          await _handleSaveAttendance(context, controller, child, status);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(duration: Duration(milliseconds: 75), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)..addListener(() {setState(() {});});
    animationController.forward();

    Get.put(AttendanceController());
    
    // Listener para el campo de búsqueda
    _searchController.addListener(() {
      final controller = Get.find<AttendanceController>();
      controller.filterChildren(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = ScreenUtil().screenWidth * 1.8;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Positioned(
            left: -((circleSize/2) - (ScreenUtil().screenWidth/2)),
            top: -420,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [config.AppColors.mainColor(1), config.AppColors.mainColor(0.4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(circleSize/2), bottomRight: Radius.circular(circleSize/2) )
              ),
            ),
          ),
          Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor),
                  onPressed: () => Get.back(),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: GradientText(
                  config.GRAY_LIGHT_GRADIENT_BUBBLE,
                  "Asistencia",
                  size: 24.sp,
                  weight: FontWeight.w700,
                ),
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: IconButton(
                      icon: Icon(UiIcons.barChart, color: Theme.of(context).primaryColor, size: 24.sp,),
                      onPressed: () {
                        Get.toNamed('/attendance_report');
                      },
                    ),
                  ),
                ],
              ),
              endDrawer: FilterAttendanceDrawer(),
              body: GetBuilder<AttendanceController>(
                init: AttendanceController(),
                id: 'list_child',
                builder: (controller) {
                  final selectedDateObj = controller.selectedDate != null
                      ? DateTime.tryParse(controller.selectedDate!)
                      : null;
                  final displayDate = selectedDateObj != null
                      ? _formatDateForDisplay(selectedDateObj)
                      : 'Fecha no seleccionada';

                  return Column(
                    children: [
                      // Elementos fijos en la parte superior
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),

                            // Buscador
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12),
                                        hintText: 'Buscar ',
                                        hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
                                        prefixIcon: Icon(UiIcons.loupe, size: 20, color: Theme.of(context).hintColor),
                                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _scaffoldKey.currentState?.openEndDrawer();
                                      },
                                      icon: Icon(UiIcons.settings_2, size: 20, color: Theme.of(context).hintColor.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 10.h),

                            // Fecha seleccionada y botón "Hoy"
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    final DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDateObj ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      // Limpiar el campo de búsqueda
                                      _searchController.clear();
                                      // Cargar asistencia de la semana de la fecha seleccionada
                                      await controller.loadAttendance(selectedDate: pickedDate);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    overlayColor: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(UiIcons.calendar, size: 24.sp, color: Theme.of(context).colorScheme.secondary),
                                      SizedBox(width: 10.w),
                                      Text(displayDate, style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 16.sp))),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 0.w),
                                TextButton(
                                  onPressed: () async {
                                    // Limpiar el campo de búsqueda
                                    _searchController.clear();
                                    
                                    // Primero verificar si la fecha de hoy está en el carousel actual
                                    final todayFound = controller.goToTodayIfAvailable();
                                    
                                    // Si no está en la lista, entonces llamar al endpoint
                                    if (!todayFound) {
                                      await controller.loadAttendance(selectedDate: DateTime.now());
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.5.h),
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                    overlayColor: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Text(
                                    'Hoy',
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                      TextStyle(
                                        fontSize: 14.sp,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),

                            // Slider calendario
                            Container(
                              // decoration: BoxDecoration(border: Border.all(width: 1)),
                              margin: EdgeInsets.symmetric(horizontal: 0.w),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 48.w,
                                    height: 48.w,
                                    child: IconButton(
                                      icon: Icon(Icons.chevron_left, size: 36.sp, color: Theme.of(context).colorScheme.secondary,),
                                      onPressed: (){
                                        if (controller.currentTab > 0) {
                                          controller.carouselController.previousPage();
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: _CarouselSliderWrapper(
                                      controller: controller,
                                      listAttendanceDay: controller.listAttendanceDay,
                                      animationController: animationController,
                                    ),
                                  ),
                                  Container(
                                    width: 48.w,
                                    height: 48.w,
                                    child: IconButton(
                                      icon: Icon(Icons.chevron_right, size: 36.sp, color: Theme.of(context).colorScheme.secondary,),
                                      onPressed: (){
                                        if (controller.currentTab < controller.listAttendanceDay.length - 1) {
                                          controller.carouselController.nextPage();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),

                      // Lista de children scrollable
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.loadAttendance();
                          },
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Column(
                              children: <Widget>[
                                // Lista de children
                                if (controller.loading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 60.h),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )
                          else if (controller.children.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: EmptyList(
                                  icon: UiIcons.user_1,
                                  message: 'No hay infantes registrados',
                                  useFullHeight: true,
                                ),
                              ),
                            )
                          else if (controller.searchChildList.isEmpty && (_searchController.text.isNotEmpty || controller.selectedRoomIds.isNotEmpty))
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      UiIcons.loupe,
                                      size: 64,
                                      color: Theme.of(context).hintColor.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No se encontraron resultados',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Intenta con otros términos de búsqueda',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            FadeTransition(
                              opacity: animationOpacity,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: controller.searchChildList.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 7);
                                },
                                itemBuilder: (context, index) {
                                  final child = controller.searchChildList[index];
                                  final initial = _getInitials(child);
                                  final formattedName = _formatChildName(child);
                                  final birthDate = child.birthDate.isNotEmpty 
                                      ? DateTime.tryParse(child.birthDate) 
                                      : null;
                                  final ageText = Child.calculateAgeFromDate(birthDate);
                                  final attendanceStatus = controller.getAttendanceStatusForChild(child.childId);
                                  final statusColor = _getAttendanceStatusColor(attendanceStatus);
                                  final statusIcon = _getStatusIcon(attendanceStatus);

                                  return InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      await _handleSimpleTap(context, controller, child);
                                    },
                                    onLongPress: () async {
                                      FocusScope.of(context).unfocus();
                                      await _handleLongPress(context, controller, child);
                                    },
                                    child: Container(
                                      color: Theme.of(context).focusColor.withOpacity(0.10),
                                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircleAvatar(
                                              radius: 18.r,
                                              backgroundColor: _getAvatarColor(child.childId),
                                              child: Text(
                                                initial,
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  formattedName,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                                                    TextStyle(fontSize: 15.sp),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  ageText,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context).textTheme.bodySmall?.merge(
                                                    TextStyle(fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: statusColor
                                              ),
                                              child: Center(
                                                child: Icon(statusIcon, size: 36, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              bottomNavigationBar: NavigationMenu()
          ),
        ],
      ),
    );
  }
}

class _CarouselSliderWrapper extends StatefulWidget {
  final AttendanceController controller;
  final List<dynamic> listAttendanceDay;
  final AnimationController animationController;

  const _CarouselSliderWrapper({
    required this.controller,
    required this.listAttendanceDay,
    required this.animationController,
  });

  @override
  State<_CarouselSliderWrapper> createState() => _CarouselSliderWrapperState();
}

class _CarouselSliderWrapperState extends State<_CarouselSliderWrapper> {
  @override
  void initState() {
    super.initState();
    // Animar después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.needsCarouselAnimation) {
        Future.delayed(Duration(milliseconds: 100), () {
          try {
            if (widget.controller.listAttendanceDay.isNotEmpty && 
                widget.controller.currentTab < widget.controller.listAttendanceDay.length) {
              widget.controller.carouselController.animateToPage(widget.controller.currentTab);
            }
          } catch (e) {
            // Error animando carousel
          }
          widget.controller.clearCarouselAnimationFlag();
        });
      }
    });
  }

  @override
  void didUpdateWidget(_CarouselSliderWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el controlador necesita animar y el widget se actualizó
    if (widget.controller.needsCarouselAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 100), () {
          try {
            if (widget.controller.listAttendanceDay.isNotEmpty && 
                widget.controller.currentTab < widget.controller.listAttendanceDay.length) {
              widget.controller.carouselController.animateToPage(widget.controller.currentTab);
            }
          } catch (e) {
            // Error animando carousel
          }
          widget.controller.clearCarouselAnimationFlag();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        carouselController: widget.controller.carouselController,
        options: CarouselOptions(
            height: 95.h,
            viewportFraction: 0.34025,
            initialPage: widget.controller.currentTab,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            scrollPhysics: BouncingScrollPhysics(),
            onPageChanged: (index, reason) {
              widget.animationController.reverse().then((f) {widget.animationController.forward();});
              widget.controller.setCurrentTab(index);
            }
        ),
        items: widget.listAttendanceDay.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = widget.controller.currentTab == index;
          
          return GestureDetector(
            onTap: () {
              widget.controller.carouselController.animateToPage(index);
            },
            child: Container(
              width: 85.w,
              height: 85.w,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                // border: Border.all(width: 1),
                borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 8)
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        item.month,
                        style: Theme.of(context).textTheme.bodySmall?.merge(
                            TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.grey
                            )
                        )
                    ),
                    SizedBox(height: 5.h,),
                    Text(
                        item.day.toString(),
                        style: Theme.of(context).textTheme.displayLarge?.merge(
                            TextStyle(
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white70 : Colors.cyan
                            )
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

