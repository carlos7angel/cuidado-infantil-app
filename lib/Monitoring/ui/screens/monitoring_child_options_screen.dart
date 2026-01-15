import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_list_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_list_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_vaccination_tracking_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MonitoringChildOptionsScreen extends StatefulWidget {
  static final String routeName = '/monitoring_child_options';
  const MonitoringChildOptionsScreen({super.key});

  @override
  State<MonitoringChildOptionsScreen> createState() => _MonitoringChildOptionsScreenState();
}

class _MonitoringChildOptionsScreenState extends State<MonitoringChildOptionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offNamed(MonitoringChildListScreen.routeName);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: SliverAppBarTitle(
                child: Container(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    'Detalle del Infante',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp,),
                onPressed: () => Get.offNamed(MonitoringChildListScreen.routeName),
              ),
              actions: <Widget>[],
              backgroundColor: Theme.of(context).colorScheme.secondary,
              expandedHeight: 180.h,
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
                          ])),
                      child: Container(
                        margin: EdgeInsets.only(top: AppBar().preferredSize.height),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h,),
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

            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        visualDensity: VisualDensity.compact,
                        leading: Icon(
                          UiIcons.inbox,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24,
                        ),
                        title: Text(
                          'Opciones de Monitoreo y Seguimiento',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h,),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(MonitoringNutritionListScreen.routeName);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 5.h), //10
                              //height: 100.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/child_slide1.png'), fit: BoxFit.cover),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: BoxBorder.all(width: 2, color: Color(0xFFff6e3e)),
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 9)],
                              ),
                              child: Container(
                                alignment: AlignmentDirectional.bottomEnd,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(child: SizedBox.shrink(),),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Seguimiento'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFFff6e3e)
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                            SizedBox(height: 2.h,),
                                            Text(
                                              'Nutricional'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFFff6e3e)
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                            // Text(
                                            //   'Realice el seguimiento de su Infante',
                                            //   style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.white.withOpacity(0.75))),
                                            //   textAlign: TextAlign.end,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h,),
                          GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              //height: 100.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/child_slide2.png'), fit: BoxFit.cover),
                                color: Colors.white,
                                border: BoxBorder.all(width: 2, color: Color(0xFF6d74de)),
                                borderRadius: BorderRadius.circular(6.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 9)
                                ],
                              ),
                              child: Container(
                                alignment: AlignmentDirectional.bottomEnd,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(child: SizedBox.shrink(),),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Control de'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFF6d74de)
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                            SizedBox(height: 2.h,),
                                            Text(
                                              'Vacunas'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFF6d74de)
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () => Get.toNamed(MonitoringVaccinationTrackingScreen.routeName),
                          ),
                          SizedBox(height: 15.h,),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(MonitoringDevelopmentListScreen.routeName);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              //height: 120.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/child_slide3.png'), fit: BoxFit.cover),
                                // color: Color(0xFFddb216), //ffd050
                                color: Colors.white, //ffd050
                                borderRadius: BorderRadius.circular(6.r),
                                border: BoxBorder.all(width: 2, color: Color(0xFFddb216)),
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 9)],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(child: SizedBox.shrink(),),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Desarrollo'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.2,
                                                  color: Color(0xFFddb216)
                                                  // color: Theme.of(context).colorScheme.secondary
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                            SizedBox(height: 2.h,),
                                            Text(
                                              'Infantil'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.2,
                                                  color: Color(0xFFddb216)
                                                  // color: Theme.of(context).colorScheme.secondary
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),

                    SizedBox(height: 25.h,),
                  ]
              )
            )
          ]
      ),
      ),
    );
  }
}
