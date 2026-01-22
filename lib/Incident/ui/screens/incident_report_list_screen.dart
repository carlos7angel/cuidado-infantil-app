import 'package:cuidado_infantil/Config/general/color_utils.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/empty_list.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Incident/controllers/incident_report_list_controller.dart';
import 'package:cuidado_infantil/Incident/models/incident_report.dart';
import 'package:cuidado_infantil/Incident/ui/incident_ui_helpers.dart';
import 'package:cuidado_infantil/Incident/ui/screens/incident_report_form_screen.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IncidentReportListScreen extends StatefulWidget {
  static final String routeName = '/incident_report_list';
  const IncidentReportListScreen({super.key});

  @override
  State<IncidentReportListScreen> createState() => _IncidentReportListScreenState();
}

class _IncidentReportListScreenState extends State<IncidentReportListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(HomeScreen.routeName);
        }
      },
      child: GetBuilder<IncidentReportListController>(
        init: IncidentReportListController(),
        builder: (controller) {
          return Scaffold(
            key: _scaffoldKey,
            body: RefreshIndicator(
              onRefresh: () async {
                final controller = Get.find<IncidentReportListController>();
                // Resetear el estado de scroll cuando se hace refresh
                setState(() {
                  _hasScrolled = false;
                });
                await controller.refreshIncidentReports();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Detectar cuando se llega cerca del final del scroll
                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                    final controller = Get.find<IncidentReportListController>();
                    if (controller.hasMore && !controller.loadingMore && !controller.loading) {
                      controller.loadMoreIncidentReports();
                    }
                  }
                  // Detectar si el usuario ha hecho scroll
                  if (scrollInfo.metrics.pixels > 0 && !_hasScrolled) {
                    setState(() {
                      _hasScrolled = true;
                    });
                  }
                  // Permitir que el RefreshIndicator también reciba los eventos
                  return false;
                },
                child: GetBuilder<IncidentReportListController>(
                  id: 'incident_report_list',
                  builder: (controller) {
                    return CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(), // Asegurar que siempre sea scrollable para el RefreshIndicator
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        title: SliverAppBarTitle(
                          child: Container(
                            padding: EdgeInsets.only(left: 5.w),
                            child: GradientText(
                              config.GRAY_LIGHT_GRADIENT_BUBBLE,
                              'Reportes de Incidentes',
                              size: 18.sp,
                              weight: FontWeight.w600,
                              align: TextAlign.left,
                            ),
                          ),
                        ),
                        leading: IconButton(
                          icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp,),
                          onPressed: () {
                            Get.offAllNamed(HomeScreen.routeName);
                          },
                        ),
                        actions: <Widget>[],
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        expandedHeight: 150.h,
                        elevation: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                      Colors.cyan,
                                      Theme.of(context).primaryColor.withOpacity(0.5),
                                    ])),
                                child: Container(
                                  margin: EdgeInsets.only(top: (AppBar().preferredSize.height).h),
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                  // decoration: BoxDecoration(border: Border.all(width: 1)),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30.h,),
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                                          child: GradientText(
                                            config.GRAY_LIGHT_GRADIENT_BUBBLE,
                                            "Reportes de incidentes",
                                            size: 26.sp,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                          )
                                      ),
                                      SizedBox(height: 0.h,),
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                                          child: GradientText(
                                            config.GRAY_LIGHT_GRADIENT_BUBBLE,
                                            "y maltrato",
                                            size: 26.sp,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                          )
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

                      // Título fijo usando SliverPersistentHeader
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverTitleDelegate(
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
                                  'Lista de Reportes',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Padding para toda la lista
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                              [
                                if (controller.loading)
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 50.h),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (controller.incidentReports.isEmpty)
                                  EmptyList(
                                    message: 'No hay reportes de incidentes registrados',
                                    icon: UiIcons.folder_1,
                                  )
                                else ...[
                                  ...controller.incidentReports.map((report) {
                                    return _buildIncidentCard(context, report);
                                  }),
                                  // Indicador de carga al final cuando se están cargando más datos
                                  if (controller.loadingMore)
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 20.h),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  // Mensaje cuando no hay más datos (solo si hay scroll disponible y el usuario ha scrolleado)
                                  if (!controller.hasMore && 
                                      controller.incidentReports.isNotEmpty && 
                                      _scrollController.hasClients &&
                                      _scrollController.position.maxScrollExtent > 0 &&
                                      _hasScrolled)
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 20.h),
                                      child: Center(
                                        child: Text(
                                          'No hay más reportes',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ]
                          ),
                        ),
                      )
                    ],
                    );
                  },
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.toNamed(IncidentReportFormScreen.routeName);
              },
              shape: StadiumBorder(side: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary.withOpacity(0))),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, IncidentReport report) {
    final severityColor = ColorUtils.parseColor(report.severityColor ?? '#9E9E9E');
    final statusIcon = IncidentUiHelpers.getStatusIcon(report.status);
    final severityIcon = IncidentUiHelpers.getSeverityIcon(report.severityLevel);
    
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black45.withOpacity(0.15),
              offset: Offset(2.0, 4.0),
              blurRadius: 8,
            )
          ]
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                if (report.id != null) {
                  Get.toNamed('/incident_report_details', arguments: report.id);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Icono de severidad/estado
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Icon(
                        severityIcon,
                        color: severityColor,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            report.code ?? 'N/A',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 16.sp
                                            ),
                                          ),
                                        ),
                                        if (report.severityLevel != null) ...[
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: severityColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            child: Text(
                                              report.severityLabel ?? 'N/A',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: severityColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text('Tipo: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),),
                                        Text(
                                          report.typeLabel ?? report.type ?? 'N/A',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Text('Infante: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                        Expanded(
                                          child: Text(
                                            report.childName ?? 'N/A',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ]
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Text('Fecha: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                        Text(
                                          report.incidentDateReadable ?? report.incidentDate ?? 'N/A',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                        ),
                                        if (report.incidentTime != null) ...[
                                          SizedBox(width: 10.w),
                                          Text(
                                            report.incidentTime!.substring(0, 5), // HH:mm
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ]
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Estado: ',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                statusIcon,
                                                size: 14.sp,
                                                color: ColorUtils.parseColor(report.getStatusColor()),
                                              ),
                                              SizedBox(width: 5.w),
                                              Flexible(
                                                child: Text(
                                                  report.statusLabel ?? report.status ?? 'N/A',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorUtils.parseColor(report.getStatusColor()),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

// Delegate para el título fijo en el SliverPersistentHeader
class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTitleDelegate({required this.child});

  @override
  double get minExtent {
    return 54.h;
  }

  @override
  double get maxExtent {
    return 54.h;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: maxExtent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: overlapsContent
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTitleDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

