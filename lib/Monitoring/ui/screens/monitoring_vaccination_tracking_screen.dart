import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:cuidado_infantil/Monitoring/controllers/monitoring_vaccination_tracking_controller.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_dose_info.dart';
import 'package:cuidado_infantil/Monitoring/models/vaccine_info.dart';
import 'package:cuidado_infantil/Monitoring/ui/widgets/register_vaccination_dialog.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_options_screen.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MonitoringVaccinationTrackingScreen extends StatefulWidget {
  static final String routeName = '/monitoring_vaccination_tracking';
  const MonitoringVaccinationTrackingScreen({super.key});

  @override
  State<MonitoringVaccinationTrackingScreen> createState() => _MonitoringVaccinationTrackingScreenState();
}

class _MonitoringVaccinationTrackingScreenState extends State<MonitoringVaccinationTrackingScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController animationController;
  late Animation<double> animationOpacity;
  final ItemScrollController _itemScrollController = ItemScrollController();
  
  List<Color> colors = [
    Colors.blue,
    Colors.deepOrangeAccent,
    Colors.green,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.deepPurple,
    Colors.teal,
    Colors.amber,
  ];

  @override
  void initState() {
    Get.put(MonitoringVaccinationTrackingController());
    animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)..addListener(() {setState(() {});});
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offNamed(MonitoringChildOptionsScreen.routeName);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<MonitoringVaccinationTrackingController>();
          await controller.loadVaccinationData();
        },
        child: GetBuilder<MonitoringVaccinationTrackingController>(
          id: 'vaccination_tracking',
          builder: (controller) {
            // Hacer scroll automático al tab seleccionado si es necesario
            if (controller.needsScrollToSelected && controller.selectedVaccine != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                try {
                  final selectedIndex = controller.vaccines.indexWhere(
                    (v) => v.vaccine.id == controller.selectedVaccine?.vaccine.id,
                  );
                  if (selectedIndex >= 0 && _itemScrollController.isAttached) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      if (_itemScrollController.isAttached) {
                        _itemScrollController.scrollTo(
                          index: selectedIndex,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    });
                  }
                } catch (e) {
                  print('⚠️ Error haciendo scroll al tab seleccionado: $e');
                }
                controller.clearScrollFlag();
              });
            }

            return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: SliverAppBarTitle(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.w),
                    child: GradientText(
                      config.GRAY_LIGHT_GRADIENT_BUBBLE,
                      'Control de Vacunas',
                      size: 18.sp,
                      weight: FontWeight.w600,
                      align: TextAlign.left,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp,),
                  onPressed: () => Get.offNamed(MonitoringChildOptionsScreen.routeName),
                ),
                actions: <Widget>[],
                backgroundColor: Theme.of(context).colorScheme.secondary,
                expandedHeight: 190.w,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                           gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).primaryColor.withOpacity(0.5),
                            ])
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: (AppBar().preferredSize.height).h),
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.h,),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                                  child: CardChild()
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: -60.w,
                        bottom: 10.h,
                        child: Container(
                          width: 300.w,
                          height: 300.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(300.r),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30.w,
                        top: -80.h,
                        child: Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(150.r),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Título "Seguimiento por tipo de vacuna" o Loading
              if (controller.loading)
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50.h),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else if (controller.vaccines.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Row(
                      children: [
                        Icon(
                          UiIcons.inbox,
                          color: Theme.of(context).hintColor,
                          size: 24.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Seguimiento por tipo de vacuna',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Tabs de vacunas usando SliverPersistentHeader (solo si no está cargando)
              if (!controller.loading && controller.vaccines.isNotEmpty)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverVaccineTabsDelegate(
                    vaccines: controller.vaccines,
                    selectedVaccine: controller.selectedVaccine,
                    colors: colors,
                    itemScrollController: _itemScrollController,
                    animationController: animationController,
                    onVaccineSelected: (vaccine, index) {
                      controller.setSelectedVaccine(vaccine);
                      animationController.reverse().then((f) { animationController.forward(); });
                      // Scroll automático al tab seleccionado
                      Future.delayed(Duration(milliseconds: 100), () {
                        if (_itemScrollController.isAttached) {
                          _itemScrollController.scrollTo(
                            index: index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      });
                    },
                    context: context,
                  ),
                ),
              // Lista de dosis de la vacuna seleccionada (solo si no está cargando)
              if (!controller.loading && controller.selectedVaccine != null)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      FadeTransition(
                        opacity: animationOpacity,
                        child: Column(
                          children: controller.selectedVaccine!.doses.asMap().entries.map((entry) {
                            final index = entry.key;
                            final doseInfo = entry.value;
                            return _buildDoseCard(context, doseInfo, controller.selectedVaccine!, index + 1);
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ]),
                  ),
                )
              else if (!controller.loading)
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50.h),
                    child: Center(
                      child: Text(
                        'No hay vacunas disponibles',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
          },
        ),
      ),
      ),
    );
  }

  Widget _buildDoseCard(BuildContext context, VaccineDoseInfo doseInfo, VaccineInfo vaccine, int index) {
    final isApplied = doseInfo.childVaccination != null;
    
    // Debug: Verificar datos
    if (isApplied && doseInfo.childVaccination != null) {
      print('🔍 DEBUG _buildDoseCard: Dosis ${doseInfo.dose.doseNumber} está aplicada');
      print('  - dateApplied: "${doseInfo.childVaccination?.dateApplied}"');
      print('  - dateApplied.isEmpty: ${doseInfo.childVaccination?.dateApplied.isEmpty}');
      print('  - appliedAt: "${doseInfo.childVaccination?.appliedAt}"');
      print('  - notes: "${doseInfo.childVaccination?.notes}"');
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Theme.of(context).scaffoldBackgroundColor,
        // border: Border.all(
        //   color: _getStatusColor(doseInfo.statusColor).withOpacity(0),
        //   width: 1,
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(doseInfo.statusColor).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      '${doseInfo.dose.doseNumber}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(doseInfo.statusColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dosis ${doseInfo.dose.doseNumber}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        doseInfo.dose.description ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(doseInfo.statusColor).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(
                    doseInfo.statusLabel,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(doseInfo.statusColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Divider(color: Colors.black12.withOpacity(0.05),),
            SizedBox(height: 5.h),
            _buildInfoRow(context, 'Edad recomendada:', doseInfo.dose.recommendedAgeReadable),
            _buildInfoRow(context, 'Rango de edad:', doseInfo.dose.ageRangeReadable),
            // _buildInfoRow(context, 'Estado de edad:', doseInfo.ageStatusLabel),
            SizedBox(height: 5.h),
            Divider(color: Colors.black12.withOpacity(0.05),),
            SizedBox(height: 5.h),
            // Estado de aplicación
            Row(
              children: [
                Icon(
                  isApplied ? Icons.check_circle : Icons.cancel,
                  color: isApplied ? Colors.green : Colors.grey,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    isApplied ? 'Vacuna aplicada' : 'Vacuna no aplicada',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isApplied ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                if (isApplied && doseInfo.childVaccination != null)
                  Container(
                    // decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: IconButton(
                      icon: Icon(
                        UiIcons.trash_1,
                        size: 20.sp,
                        color: Colors.red,
                      ),
                      onPressed: () => _showDeleteConfirmationDialog(context, doseInfo.childVaccination!.id),
                      tooltip: 'Eliminar vacuna',
                    ),
                  )
                else if (!isApplied)
                  Container(
                    // decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: IconButton(
                      icon: Icon(
                        UiIcons.edit,
                        size: 20.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () => _showRegisterVaccinationDialog(context, doseInfo, vaccine),
                      tooltip: 'Registrar vacuna',
                    ),
                  ),
              ],
            ),
            if (isApplied && doseInfo.childVaccination != null) ...[
              SizedBox(height: 10.h),
              _buildInfoRow(
                context, 
                'Fecha aplicada:', 
                doseInfo.childVaccination!.dateApplied.isNotEmpty 
                  ? _formatDate(doseInfo.childVaccination!.dateApplied)
                  : 'No especificada'
              ),
              if (doseInfo.childVaccination!.appliedAt != null && doseInfo.childVaccination!.appliedAt!.isNotEmpty)
                _buildInfoRow(context, 'Lugar:', doseInfo.childVaccination!.appliedAt!),
              if (doseInfo.childVaccination!.notes != null && doseInfo.childVaccination!.notes!.isNotEmpty) ...[
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(child: SizedBox.shrink()),
                    TextButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0)),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => _showNotesDialog(context, doseInfo.childVaccination!.notes!),
                      icon: Icon(UiIcons.chat_1, size: 16.sp, color: Theme.of(context).colorScheme.secondary),
                      label: Text(
                        'Ver notas',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ],
            ],
            if (doseInfo.daysOverdue != null) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Atrasada por ${doseInfo.daysOverdue} días',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (doseInfo.monthsUntilAvailable != null) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Disponible en ${doseInfo.monthsUntilAvailable} meses',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String statusColor) {
    switch (statusColor.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'danger':
        return Colors.red;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) {
      print('⚠️ WARNING: dateString está vacío');
      return 'No especificada';
    }
    try {
      print('🔍 DEBUG _formatDate: Intentando formatear fecha "$dateString"');
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      final formatted = DateFormat('dd/MM/yyyy').format(date);
      print('✅ DEBUG _formatDate: Fecha formateada exitosamente: "$formatted"');
      return formatted;
    } catch (e) {
      print('❌ ERROR formateando fecha: "$dateString" - $e');
      return dateString;
    }
  }

  void _showRegisterVaccinationDialog(BuildContext context, VaccineDoseInfo doseInfo, VaccineInfo vaccine) {
    final controller = Get.find<MonitoringVaccinationTrackingController>();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return RegisterVaccinationDialog(
          vaccine: vaccine,
          doseInfo: doseInfo,
          onRegister: ({
            required String vaccineDoseId,
            required String dateApplied,
            required String appliedAt,
            String? notes,
          }) async {
            return await controller.registerVaccination(
              vaccineDoseId: vaccineDoseId,
              dateApplied: dateApplied,
              appliedAt: appliedAt,
              notes: notes,
            );
          },
          onSuccess: () {
            // Mostrar modal de éxito después de que se cierre el diálogo del formulario
            controller.showSuccessDialog();
          },
        );
      },
    );
  }

  void _showNotesDialog(BuildContext context, String notes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            children: [
              Icon(UiIcons.information, color: Theme.of(context).colorScheme.secondary),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Notas de la vacunación',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String childVaccinationId) {
    final controller = Get.find<MonitoringVaccinationTrackingController>();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            children: [
              Icon(
                UiIcons.trash_1,
                color: Colors.red,
                size: 24.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Eliminar vacuna',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '¿Está seguro que desea eliminar este registro de vacunación? Esta acción no se puede deshacer.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await controller.deleteVaccination(
                  childVaccinationId: childVaccinationId,
                );
                if (success) {
                  // Mostrar modal de éxito después de eliminar exitosamente
                  controller.showSuccessDialog(message: 'Vacuna eliminada exitosamente');
                }
              },
              child: Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Delegate para los tabs de vacunas
class _SliverVaccineTabsDelegate extends SliverPersistentHeaderDelegate {
  final List vaccines;
  final selectedVaccine;
  final List<Color> colors;
  final ItemScrollController itemScrollController;
  final AnimationController animationController;
  final Function(dynamic, int) onVaccineSelected;
  final BuildContext context;

  _SliverVaccineTabsDelegate({
    required this.vaccines,
    required this.selectedVaccine,
    required this.colors,
    required this.itemScrollController,
    required this.animationController,
    required this.onVaccineSelected,
    required this.context,
  });

  @override
  double get minExtent => 140.h;

  @override
  double get maxExtent => 140.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 140.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
      margin: EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ScrollablePositionedList.builder(
        itemCount: vaccines.length,
        scrollDirection: Axis.horizontal,
        itemScrollController: itemScrollController,
        itemBuilder: (context, indexList) {
          final vaccine = vaccines[indexList];
          final isSelected = selectedVaccine?.vaccine.id == vaccine.vaccine.id;
          final color = colors[indexList % colors.length];
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            margin: EdgeInsets.only(left: 0, top: 10.h, bottom: 10.h),
            width: ((MediaQuery.of(context).size.width / 3).round() - 12.w + 0.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.cyan,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                ),
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                onVaccineSelected(vaccine, indexList);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    width: double.infinity,
                    height: double.infinity,
                    duration: Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      border: Border.all(width: 2.w, color: color),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          UiIcons.shield,
                          size: 26.sp,
                          color: isSelected ? Colors.white : color,
                        ),
                        SizedBox(height: 7.h),
                        Container(
                          height: 25.h,
                          child: Text(
                            vaccine.vaccine.name,
                            style: Theme.of(context).textTheme.bodyMedium?.merge(
                              TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                                letterSpacing: -0.5,
                                color: isSelected ? Colors.white : Theme.of(context).hintColor,
                              ),
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          'Aplicadas ${vaccine.progress.applied}/${vaccine.progress.total} (${vaccine.progress.percentage.toStringAsFixed(0)}%)',
                          style: Theme.of(context).textTheme.bodySmall?.merge(
                            TextStyle(
                              fontSize: 10.sp,
                              color: isSelected ? Colors.white.withOpacity(0.8) : Theme.of(context).hintColor.withOpacity(0.7),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverVaccineTabsDelegate oldDelegate) {
    return vaccines != oldDelegate.vaccines ||
        selectedVaccine?.vaccine.id != oldDelegate.selectedVaccine?.vaccine.id;
  }
}
