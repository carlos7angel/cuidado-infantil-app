import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Child/ui/widgets/child_identification_tab.dart';
import 'package:cuidado_infantil/Child/ui/widgets/child_medical_tab.dart';
import 'package:cuidado_infantil/Child/ui/widgets/child_social_tab.dart';
import 'package:cuidado_infantil/Child/ui/widgets/child_enrollment_tab.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChildFormScreen extends StatefulWidget {
  static final String routeName = '/child_form';
  const ChildFormScreen({super.key});

  @override
  State<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends State<ChildFormScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Animation animationOpacity;
  late AnimationController animationController;
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    ChildFormController childFormController = Get.put(ChildFormController());
    childFormController.fbKey = GlobalKey<FormBuilderState>();

    animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)..addListener(() {setState(() {});});
    animationController.forward();

    tabController = TabController(length: 4, initialIndex: tabIndex, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });

    super.initState();
    
    // Asegurar que el TabBar scrollable comience desde la izquierda
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tabController.index != 0) {
        tabController.animateTo(0);
      }
      // Configurar callbacks para navegar a tabs y obtener tab actual
      childFormController.onNavigateToTab = (int tabIndex) {
        tabController.animateTo(tabIndex);
      };
      childFormController.onGetCurrentTab = () {
        return tabController.index;
      };
    });
  }

  void handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        tabIndex = tabController.index;
      });
    }
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
      child: GetBuilder<ChildFormController>(
        id: 'form_child',
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Get.offAllNamed(HomeScreen.routeName);
                  },
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                title: GradientText(
                  config.GRAY_LIGHT_GRADIENT_BUBBLE,
                  controller.isEditing ? "Editar Infante" : "Nuevo Infante",
                  size: 25.sp,
                  weight: FontWeight.w700,
                ),
                actions: <Widget>[
                  // GestureDetector(
                  //   onTap: () async {
                  //     await controller.saveChild();
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 15.w),
                  //     child: Chip(
                  //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                  //       label: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: <Widget>[
                  //           Obx(() => controller.isSaving
                  //             ? SizedBox(
                  //                 width: 16.w,
                  //                 height: 16.w,
                  //                 child: CircularProgressIndicator(
                  //                   strokeWidth: 2,
                  //                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  //                 ),
                  //               )
                  //             : Text(
                  //               'Guardar', style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.white)))
                  //           ),
                  //         ],
                  //       ),
                  //       backgroundColor: controller.isSaving ? Colors.grey : Colors.lightBlueAccent,// Theme.of(context).colorScheme.secondary,
                  //       shape: StadiumBorder(side: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary.withOpacity(0))),
                  //     ),
                  //   ),
                  // ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(75.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    ),
                    padding: EdgeInsets.all(0.w),
                    child: TabBar(
                      controller: tabController,
                      indicatorPadding: EdgeInsets.all(0.w),
                      labelPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                      unselectedLabelColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).colorScheme.secondary,
                      isScrollable: true,
                      indicatorWeight: 0,
                      tabAlignment: TabAlignment.start,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        // border: Border.all(color: Colors.white, width: 3), //Theme.of(context).colorScheme.secondary
                        // gradient: config.GRAY_LIGHT_GRADIENT_BUBBLE,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),

                      tabs: [
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(UiIcons.idCard),
                                  ),
                                  Text("Ficha de Identificación")
                                ],
                              ),
                            ),
                          )
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(UiIcons.heart),
                                  ),
                                  Text("Ficha Médica")
                                ],
                              ),
                            ),
                          )
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(UiIcons.home),
                                  ),
                                  Text("Ficha Social")
                                ],
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(UiIcons.folder_1),
                                  ),
                                  Text("Ficha de Inscripción")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: FormBuilder(
                key: controller.fbKey,
                initialValue: controller.initialValues,
                autovalidateMode: controller.hasAttemptedSave
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ChildIdentificationTab(controller: controller),
                    ChildMedicalTab(controller: controller),
                    ChildSocialTab(controller: controller),
                    ChildEnrollmentTab(controller: controller),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await controller.saveChild(currentTabIndex: tabController.index);
                      },
                      child: Container(
                        height: 50.h,
                        width: 150.w,
                        padding: EdgeInsets.only(left: 15.w),
                        decoration: BoxDecoration(
                            gradient: config.PRIMARY_GRADIENT,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(100.r))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(UiIcons.cursor, size: 20.sp, color: Colors.white),
                            Container(margin: EdgeInsets.only(left: 10.w)),
                            Text(
                              'Guardar',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
