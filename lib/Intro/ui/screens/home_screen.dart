import 'package:cuidado_infantil/Child/ui/screens/child_form_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_list_screen.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/widgets/header_profile.dart';
import 'package:cuidado_infantil/Incident/ui/screens/incident_report_list_screen.dart';
import 'package:cuidado_infantil/Intro/controllers/home_controller.dart';
import 'package:cuidado_infantil/Intro/ui/widgets/navigation_menu.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/attendance_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = '/home';
  int currentTab = 2;
  int selectedTab = 2;
  HomeScreen({super.key, this.currentTab = 2});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = ScreenUtil().screenWidth * 1.5;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Positioned(
            left: -((circleSize/2) - (ScreenUtil().screenWidth/2)),
            top: -400,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [config.AppColors.mainColor(0.9), config.AppColors.mainColor(0.2)],
                      begin: Alignment.center,
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
              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0),
              elevation: 0,
              title: GradientText(
                  config.GRAY_LIGHT_GRADIENT_BUBBLE,
                  "INICIO",
                  size: 22.sp,
                  weight: FontWeight.w700,
              ),
              actions: <Widget>[
                HeaderProfile(),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 0.h,),
                  
                  
                  GetBuilder<HomeController>(
                    builder: (controller) {
                      return Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hola, ${controller.user?.educator?.fullName}',
                                    style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.childcareCenter!.name!.toUpperCase(),
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1.2, color: Theme.of(context).colorScheme.secondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${controller.childcareCenter?.municipality} - ${controller.childcareCenter?.state}',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      );
                    }
                  ),
                  SizedBox(height: 25.h,),
                  Container(
                    margin: EdgeInsets.only(top: 30.h),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AttendanceScreen.routeName),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(width: 0, color: Colors.grey.withOpacity(0.15)),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                            ]
                          ),
                        ),
                        child: Stack(
                          //overflow: Overflow.visible,
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              children: <Widget>[
                                SizedBox(width: 10.w),
                                Flexible(
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
                                                Text(
                                                  'ASISTENCIA',
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  maxLines: 2,
                                                  style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
                                                      fontSize: 24.sp,
                                                      color: Theme.of(context).primaryColor,
                                                      // fontFamily: 'Kruda'
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Control de asistencia de los infantes',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontSize: 13.sp,
                                                    color: Theme.of(context).primaryColor.withOpacity(0.7)
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: true,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                Container(
                                  width: 120.w,
                                  height: 100.w,
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0.w,
                              bottom: 0.h,
                              child: Container(
                                height: 150.w,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/images/attendance.png'), fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        UiIcons.layers,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Seguimiento y Monitoreo',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(ChildFormScreen.routeName),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                // color: Color(0xFFff6e3e).withOpacity(1),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFff6e3e).withOpacity(1),
                                      Color(0xFFff6e3e).withOpacity(0.6),
                                    ]
                                ),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 9)
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image(image: AssetImage('assets/images/option_1.png'), height: 50.h,),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    "Nuevo".toUpperCase(),
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily: 'Kruda'
                                        )
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  SizedBox(height: 5.h,),
                                  Flexible(
                                    child: Text(
                                      'Inscripción de un nuevo infante',
                                      style: Theme.of(context).textTheme.bodySmall?.merge(
                                          TextStyle(
                                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                                              height: 1.1,
                                              fontSize: 13.sp
                                          )
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      //softWrap: false,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(ChildListScreen.routeName),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                // color: Color(0xFFddb216).withOpacity(1),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFFddb216).withOpacity(1),
                                      Color(0xFFddb216).withOpacity(0.6),
                                    ]
                                ),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 9)
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      Image(
                                        image: AssetImage('assets/images/baby.png'),
                                        height: 50.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    "Infantes".toUpperCase(),
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        )
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  SizedBox(height: 5.h,),
                                  Flexible(
                                    child: Text(
                                      'Lista de infantes inscritos',
                                      style: Theme.of(context).textTheme.bodySmall?.merge(
                                          TextStyle(
                                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                                              height: 1.1,
                                              fontSize: 13.sp
                                          )
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      //softWrap: false,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(MonitoringChildListScreen.routeName),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                // color: Color(0xFF6d74de).withOpacity(1),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color(0xFF6d74de).withOpacity(1),
                                      Color(0xFF6d74de).withOpacity(0.6),
                                    ]
                                ),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 9)
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage('assets/images/option_2.png'),
                                    height: 50.h,
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    "Monitoreo".toUpperCase(),
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          // fontFamily: 'Kruda'
                                        )
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  SizedBox(height: 5.h,),
                                  Flexible(
                                    child: Text(
                                      'Seguimiento y evaluación',
                                      style: Theme.of(context).textTheme.bodySmall?.merge(
                                          TextStyle(
                                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                                              height: 1.1,
                                              fontSize: 13.sp
                                          )
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      //softWrap: false,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(IncidentReportListScreen.routeName),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                // color: Color(0xFFff577a).withOpacity(1),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      Color(0xFFff577a).withOpacity(1),
                                      Color(0xFFff577a).withOpacity(0.6),
                                    ]
                                ),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 9)
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage('assets/images/option_3.png'),
                                    height: 50.h,
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    "INCIDENTES".toUpperCase(),
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        )
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  SizedBox(height: 5.h,),
                                  Flexible(
                                    child: Text(
                                      'Reporte de Incidentes',
                                      style: Theme.of(context).textTheme.bodySmall?.merge(
                                          TextStyle(
                                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                                              height: 1.1,
                                              fontSize: 13.sp
                                          )
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      //softWrap: false,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,)
                ],
              ),
            ),
            bottomNavigationBar: NavigationMenu(),
          )
        ],
      ),
    );

  }
}
