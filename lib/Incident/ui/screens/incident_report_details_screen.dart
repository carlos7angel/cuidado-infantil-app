import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Incident/controllers/incident_report_details_controller.dart';
import 'package:cuidado_infantil/Incident/models/evidence_file.dart';
import 'package:cuidado_infantil/Incident/ui/widgets/incident_child_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IncidentReportDetailsScreen extends StatefulWidget {
  static final String routeName = '/incident_report_details';
  const IncidentReportDetailsScreen({super.key});

  @override
  State<IncidentReportDetailsScreen> createState() => _IncidentReportDetailsScreenState();
}

class _IncidentReportDetailsScreenState extends State<IncidentReportDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IncidentReportDetailsController>(
      init: IncidentReportDetailsController(),
      builder: (controller) {
        if (controller.loading) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: GradientText(
                config.PRIMARY_GRADIENT,
                "Detalle del Reporte",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (controller.error != null || controller.incidentReport == null) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: GradientText(
                config.PRIMARY_GRADIENT,
                "Detalle del Reporte",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
            body: Center(
              child: Text(controller.error ?? 'No se encontró el reporte'),
            ),
          );
        }

        final report = controller.incidentReport!;
        final severityColor = _parseColor(report.severityColor ?? '#9E9E9E');
        final statusColor = _getStatusColor(report.status);

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
              onPressed: () => Get.back(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: GradientText(
              config.PRIMARY_GRADIENT,
              "Detalle del Reporte",
              size: 20.sp,
              weight: FontWeight.w600,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.refreshIncidentReport(),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card del Child si existe
                    if (report.child != null) ...[
                      IncidentChildDetailsCard(child: report.child!),
                      SizedBox(height: 20.h),
                    ],

                    // Información del reporte
                    _buildReportInfoCard(context, report, severityColor, statusColor),

                    SizedBox(height: 20.h),

                    // Descripción
                    if (report.description != null && report.description!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Descripción'),
                      SizedBox(height: 10.h),
                      _buildDescriptionCard(context, report.description!),
                      SizedBox(height: 20.h),
                    ],

                    // Detalles del incidente
                    _buildSectionTitle(context, 'Detalles del Incidente'),
                    SizedBox(height: 10.h),
                    _buildIncidentDetailsCard(context, report),

                    SizedBox(height: 20.h),

                    // Personas involucradas
                    if (report.peopleInvolved != null && report.peopleInvolved!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Personas Involucradas'),
                      SizedBox(height: 10.h),
                      _buildInfoCard(context, report.peopleInvolved!),
                      SizedBox(height: 20.h),
                    ],

                    // Testigos
                    if (report.witnesses != null && report.witnesses!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Testigos'),
                      SizedBox(height: 10.h),
                      _buildInfoCard(context, report.witnesses!),
                      SizedBox(height: 20.h),
                    ],

                    // Acciones tomadas
                    if (report.actionsTaken != null && report.actionsTaken!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Acciones Tomadas'),
                      SizedBox(height: 10.h),
                      _buildInfoCard(context, report.actionsTaken!),
                      SizedBox(height: 20.h),
                    ],

                    // Comentarios adicionales
                    if (report.additionalComments != null && report.additionalComments!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Comentarios Adicionales'),
                      SizedBox(height: 10.h),
                      _buildInfoCard(context, report.additionalComments!),
                      SizedBox(height: 20.h),
                    ],

                    // Descripción de evidencia
                    if (report.evidenceDescription != null && report.evidenceDescription!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Descripción de la Evidencia'),
                      SizedBox(height: 10.h),
                      _buildInfoCard(context, report.evidenceDescription!),
                      SizedBox(height: 20.h),
                    ],

                    // Archivos de evidencia
                    if (report.evidenceFiles != null && report.evidenceFiles!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Archivos de Evidencia'),
                      SizedBox(height: 10.h),
                      _buildEvidenceFilesCard(context, report.evidenceFiles!),
                      SizedBox(height: 20.h),
                    ],

                    // Información de registro
                    _buildSectionTitle(context, 'Información de Registro'),
                    SizedBox(height: 10.h),
                    _buildRegistrationInfoCard(context, report),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportInfoCard(BuildContext context, report, Color severityColor, Color statusColor) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  report.severityLabel ?? 'N/A',
                  style: TextStyle(
                    color: severityColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  report.statusLabel ?? 'N/A',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          _buildInfoRow(context, 'Código', report.code ?? 'N/A'),
          SizedBox(height: 10.h),
          _buildInfoRow(context, 'Tipo', report.typeLabel ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, String description) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: double.infinity),
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Widget _buildIncidentDetailsCard(BuildContext context, report) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          if (report.incidentDateTimeReadable != null)
            _buildInfoRow(context, 'Fecha y Hora', report.incidentDateTimeReadable!),
          if (report.incidentDateTimeReadable != null) SizedBox(height: 15.h),
          if (report.incidentLocation != null && report.incidentLocation!.isNotEmpty)
            _buildInfoRow(context, 'Ubicación', report.incidentLocation!),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String info) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: double.infinity),
          child: Text(
            info,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceFilesCard(BuildContext context, List<EvidenceFile> files) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: files.length == 1
          ? _buildSingleImage(context, files.first)
          : _buildImageCarousel(context, files),
    );
  }

  Widget _buildSingleImage(BuildContext context, EvidenceFile file) {
    if (file.url == null) return SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showImageDialog(context, file.url!, 0, [file]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CachedNetworkImage(
          imageUrl: file.url!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 200.h,
            color: Colors.grey[300],
            child: Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200.h,
            color: Colors.grey[300],
            child: Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context, List<EvidenceFile> files) {
    return CarouselSlider.builder(
      itemCount: files.length,
      itemBuilder: (context, index, realIndex) {
        final file = files[index];
        if (file.url == null) return SizedBox.shrink();

        return GestureDetector(
          onTap: () => _showImageDialog(context, file.url!, index, files),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: file.url!,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  height: 200.h,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 200.h,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        autoPlay: false,
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl, int initialIndex, List<EvidenceFile> files) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            CarouselSlider.builder(
              itemCount: files.length,
              itemBuilder: (context, index, realIndex) {
                final file = files[index];
                return CachedNetworkImage(
                  imageUrl: file.url ?? '',
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              options: CarouselOptions(
                initialPage: initialIndex,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30.sp),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationInfoCard(BuildContext context, report) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.15),
            offset: Offset(2.0, 4.0),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          if (report.reportedAtReadable != null)
            _buildInfoRow(context, 'Reportado el', report.reportedAtReadable!),
          if (report.reportedAtReadable != null) SizedBox(height: 15.h),
          if (report.closedDate != null)
            _buildInfoRow(context, 'Cerrado el', report.closedDate!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).hintColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (e) {
      // Si falla, retornar gris por defecto
    }
    return Colors.grey;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'reportado':
        return Colors.blue;
      case 'en_revision':
        return Colors.orange;
      case 'cerrado':
        return Colors.green;
      case 'escalado':
        return Colors.red;
      case 'archivado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

