import 'package:cuidado_infantil/Auth/controllers/login_controller.dart';
import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Intro/ui/screens/about_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/change_password_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/educator_profile_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/select_childcare_center.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PreferencesScreen extends StatefulWidget {
  static final String routeName = '/preferences';
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String _getAvatarImage(String? gender) {
    String avatarImage = 'assets/images/blank.png';
    
    if (gender == null || gender.isEmpty) {
      return avatarImage;
    }
    
    final genderLower = gender.toLowerCase();
    
    if (genderLower == 'masculino') {
      avatarImage = 'assets/images/user_man.png';
    }
    
    if (genderLower == 'femenino') {
      avatarImage = 'assets/images/user_woman.png';
    }
    
    return avatarImage;
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        key: _scaffoldKey,
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
            "Preferencias",
            size: 20.sp,
            weight: FontWeight.w600,
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () { LoginController().logout(); },
              child: Container(
                margin: EdgeInsets.only(right: 15.w),
                child: Chip(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Salir', style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.white))),
                    ],
                  ),
                  backgroundColor: Color(0xFFED5565),
                  shape: StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.h),
              GetBuilder<SessionController>(
                  builder: (controller) {
                    return InkWell(
                      onTap: () async {
                        await Get.toNamed(EducatorProfileScreen.routeName);
                        // Refrescar SessionController después de regresar
                        if (Get.isRegistered<SessionController>()) {
                          Get.find<SessionController>().loadSession();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1.w, color: Theme.of(context).highlightColor)
                              ),
                              child: CachedImage(
                                image: _getAvatarImage(controller.user?.educator?.gender),
                                isRound: true,
                                radius: 75.r,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              controller.user?.educator?.fullName ?? 'Unknown',
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              maxLines: 1,
                                              style: Theme.of(context).textTheme.titleMedium
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(UiIcons.users, color: Theme.of(context).colorScheme.secondary, size: 18.sp),
                                                    SizedBox(width: 5.w),
                                                    Text(
                                                      'Educador',
                                                      style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: config.AppColors.gray99Color(1))),
                                                      overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 10.w,),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      UiIcons.envelope,
                                                      color: Theme.of(context).colorScheme.secondary,
                                                      size: 16.sp,
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Text(
                                                      controller.user?.email ?? '',
                                                      style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: config.AppColors.gray99Color(1))),
                                                      overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Theme.of(context).highlightColor,
                                        size: 32.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
              SizedBox(height: 10.h,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15.h),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Perfil",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(SelectChildcareCenterScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          overlayColor: Colors.grey.withOpacity(0.2),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            UiIcons.layers,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          title: Row(
                            children: <Widget>[
                              Text(
                                "Centro de Cuidado",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          subtitle: Text("Cambiar el Centro a administrar", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Configuraciones",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    SizedBox(height: 10.h,),
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(ChangePasswordScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          overlayColor: Colors.grey.withOpacity(0.2),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            UiIcons.padlock_1,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          title: Row(
                            children: <Widget>[
                              Text(
                                "Cambiar contraseña",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          subtitle: Text("Actualizar tu contraseña por seguridad", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AboutScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.h),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          overlayColor: Colors.grey.withOpacity(0.2),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            UiIcons.information,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          title: Row(
                            children: <Widget>[
                              Text(
                                "Acerca",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          subtitle: Text("Información de la aplicación", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),),
                          trailing: Icon(Icons.keyboard_arrow_right),
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
    );
  }
}

