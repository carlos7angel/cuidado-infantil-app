import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/empty_list.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/header_profile.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Monitoring/controllers/attendance_report_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/attendance_child.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceReportScreen extends StatefulWidget {
  static final String routeName = '/attendance_report';
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _horizontalHeaderScrollController = ScrollController();
  final ScrollController _namesScrollController = ScrollController();

  bool _isScrolling = false;

  // Sincronizar scroll vertical entre nombres y tabla
  void _syncVerticalScroll() {
    _namesScrollController.addListener(() {
      if (!_isScrolling && _verticalScrollController.hasClients) {
        _isScrolling = true;
        _verticalScrollController.jumpTo(_namesScrollController.offset);
        _isScrolling = false;
      }
    });

    _verticalScrollController.addListener(() {
      if (!_isScrolling && _namesScrollController.hasClients) {
        _isScrolling = true;
        _namesScrollController.jumpTo(_verticalScrollController.offset);
        _isScrolling = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Get.put(AttendanceReportController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncVerticalScroll();
      _syncHorizontalScroll();
    });
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    _horizontalHeaderScrollController.dispose();
    _namesScrollController.dispose();
    super.dispose();
  }

  // Sincronizar scroll horizontal entre header y cuerpo
  void _syncHorizontalScroll() {
    _horizontalHeaderScrollController.addListener(() {
      if (!_isScrolling && _horizontalScrollController.hasClients) {
        _isScrolling = true;
        _horizontalScrollController.jumpTo(_horizontalHeaderScrollController.offset);
        _isScrolling = false;
      }
    });

    _horizontalScrollController.addListener(() {
      if (!_isScrolling && _horizontalHeaderScrollController.hasClients) {
        _isScrolling = true;
        _horizontalHeaderScrollController.jumpTo(_horizontalScrollController.offset);
        _isScrolling = false;
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'presente':
      case 'present':
        return Colors.green;
      case 'falta':
      case 'absent':
        return Colors.red;
      case 'retraso':
      case 'late':
        return Colors.blue;
      case 'justificado':
      case 'justified':
        return Colors.orange;
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'presente':
      case 'present':
        return Icons.check;
      case 'falta':
      case 'absent':
        return Icons.close;
      case 'retraso':
      case 'late':
        return Icons.access_time;
      case 'justificado':
      case 'justified':
        return Icons.flag_outlined;
      default:
        return Icons.remove;
    }
  }

  String _formatChildName(AttendanceChild child) {
    List<String> nameParts = [];
    
    if (child.paternalLastName.isNotEmpty) {
      nameParts.add(child.paternalLastName.trim());
    }
    
    if (child.maternalLastName.isNotEmpty) {
      nameParts.add(child.maternalLastName.trim());
    }
    
    String lastNamePart = nameParts.join(' ');
    if (lastNamePart.isNotEmpty && child.firstName.isNotEmpty) {
      lastNamePart += ', ';
    }
    
    String firstNamePart = child.firstName.trim();
    String fullName = lastNamePart + firstNamePart;
    
    return fullName.isNotEmpty ? fullName : 'Sin nombre';
  }

  Future<void> _selectDateRange(BuildContext context, AttendanceReportController controller) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: controller.startDate,
        end: controller.endDate,
      ),
      helpText: 'Seleccionar rango de fechas',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Colors.white,
              surface: Theme.of(context).primaryColor,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await controller.updateDateRange(picked.start, picked.end);
    }
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
                  colors: [config.Colors().mainColor(1), config.Colors().mainColor(0.4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(circleSize/2),
                  bottomRight: Radius.circular(circleSize/2)
                )
              ),
            ),
          ),
          Scaffold(
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
                "Reporte de Asistencia",
                size: 24.sp,
                weight: FontWeight.w700,
              ),
              actions: <Widget>[
              ],
            ),
            body: GetBuilder<AttendanceReportController>(
              id: 'report_table',
              builder: (controller) {
                if (controller.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }

                if (controller.children.isEmpty || controller.dates.isEmpty) {
                  return Center(
                    child: EmptyList(
                      icon: UiIcons.barChart,
                      message: 'No hay datos disponibles',
                      useFullHeight: false,
                    ),
                  );
                }

                return Column(
                  children: [
                    // Selector de rango de fechas
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () => _selectDateRange(context, controller),
                              icon: Icon(
                                UiIcons.calendar,
                                size: 20.sp,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              label: Text(
                                '${DateFormat('dd/MM/yyyy').format(controller.startDate)} - ${DateFormat('dd/MM/yyyy').format(controller.endDate)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.sp,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          IconButton(
                            onPressed: () => controller.loadAttendanceReport(),
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            tooltip: 'Actualizar',
                          ),
                        ],
                      ),
                    ),

                    // Tabla de reporte
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.1),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Columna fija de nombres
                            Container(
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Header de nombres
                                  Container(
                                    height: 60.h,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                      ),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context).hintColor.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Infante',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  // Lista de nombres
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _namesScrollController,
                                      itemCount: controller.children.length,
                                      itemBuilder: (context, index) {
                                        final child = controller.children[index];
                                        final formattedName = _formatChildName(child);
                                        final hasMoreThanThreeAbsences = controller.hasMoreThanThreeAbsences(child.childId);
                                        
                                        return Container(
                                          height: 50.h,
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: hasMoreThanThreeAbsences 
                                                ? Colors.red.withOpacity(0.15) 
                                                : Colors.transparent,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Theme.of(context).hintColor.withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              formattedName,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: 12.sp,
                                                color: hasMoreThanThreeAbsences 
                                                    ? Colors.red.shade700 
                                                    : null,
                                                fontWeight: hasMoreThanThreeAbsences 
                                                    ? FontWeight.w600 
                                                    : FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tabla scrollable horizontal y vertical
                            Expanded(
                              child: Column(
                                children: [
                                  // Header de fechas (scrollable horizontal)
                                  Container(
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                      ),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context).hintColor.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      controller: _horizontalHeaderScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(controller.dates.length, (index) {
                                          final date = controller.dates[index];
                                          final formattedDate = controller.formatDateForColumn(date);
                                          return Container(
                                            width: 80.w,
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Theme.of(context).hintColor.withOpacity(0.1),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                formattedDate,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.secondary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  // Celdas de asistencia (scrollable horizontal y vertical)
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: _horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: controller.dates.length * 80.w,
                                        child: ListView.builder(
                                          controller: _verticalScrollController,
                                          itemCount: controller.children.length,
                                          itemBuilder: (context, rowIndex) {
                                            final child = controller.children[rowIndex];
                                            return Container(
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Theme.of(context).hintColor.withOpacity(0.1),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: List.generate(controller.dates.length, (colIndex) {
                                                  final date = controller.dates[colIndex];
                                                  final status = controller.getAttendanceStatus(child.childId, date);
                                                  final statusColor = _getStatusColor(status);
                                                  final statusIcon = _getStatusIcon(status);
                                                  
                                                  return Container(
                                                    width: 80.w,
                                                    padding: EdgeInsets.all(5.w),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Theme.of(context).hintColor.withOpacity(0.1),
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        width: 35.w,
                                                        height: 35.w,
                                                        decoration: BoxDecoration(
                                                          color: statusColor,
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Icon(
                                                          statusIcon,
                                                          size: 20.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

