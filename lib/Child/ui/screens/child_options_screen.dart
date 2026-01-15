import 'package:cuidado_infantil/Child/controllers/child_options_controller.dart';
import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_identification_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_medical_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_social_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_enrollment_details_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_list_screen.dart';
import 'package:cuidado_infantil/Child/ui/widgets/child_option_tile.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/card_child.dart';
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChildOptionsScreen extends StatefulWidget {
  static final String routeName = '/child_options';
  const ChildOptionsScreen({super.key});

  @override
  State<ChildOptionsScreen> createState() => _ChildOptionsScreenState();
}

class _ChildOptionsScreenState extends State<ChildOptionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    Get.put(ChildOptionsController());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offNamed(ChildListScreen.routeName);
        }
      },
      child: GetBuilder<ChildOptionsController>(
        builder: (controller) {
          return Scaffold(
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
                  onPressed: () => Get.offNamed(ChildListScreen.routeName),
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
                                  margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0),
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
              // Mostrar loading o botones según el estado
              if (controller.isLoading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              else if (controller.child == null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No se encontraron datos del infante',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              else
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
                            'Datos del Infante por ficha',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          primary: false,
                          children: [
                            ChildOptionTile(
                              icon: UiIcons.idCard,
                              title: 'Ficha de Identificación',
                              onTap: () => Get.toNamed(ChildIdentificationDetailsScreen.routeName)
                            ),
                            SizedBox(height: 15.h),
                            ChildOptionTile(
                                icon: UiIcons.heart,
                                title: 'Ficha Médica',
                                onTap: () => Get.toNamed(ChildMedicalDetailsScreen.routeName)
                            ),
                            SizedBox(height: 15.h),
                            ChildOptionTile(
                                icon: UiIcons.home,
                                title: 'Ficha Social',
                                onTap: () => Get.toNamed(ChildSocialDetailsScreen.routeName)
                            ),
                            SizedBox(height: 15.h),
                            ChildOptionTile(
                                icon: UiIcons.edit,
                                title: 'Ficha de Inscripción',
                                onTap: () => Get.toNamed(ChildEnrollmentDetailsScreen.routeName)
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25.h,),
                    ]
                  )
                )
            ]
          ),
          floatingActionButton: controller.child != null
              ? FloatingActionButton( //.extended
                  onPressed: () async {
                    // Navegar al formulario de edición con el child precargado
                    final childFormController = Get.put(ChildFormController());
                    await childFormController.setInitialData({}, child: controller.child);
                    Get.toNamed('/child_form');
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: StadiumBorder(side: BorderSide(width: 0, color: Theme.of(context).colorScheme.secondary.withOpacity(0))),
                  child: Icon(Icons.edit, color: Colors.white),
                  // icon: Icon(UiIcons.edit, color: Colors.white),
                  // label: Text(
                  //   'Editar',
                  //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  // ),
                )
              : null,
        );
        },
      ),
    );
  }
}
