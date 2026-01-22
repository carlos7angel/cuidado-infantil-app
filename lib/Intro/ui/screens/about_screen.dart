import 'package:cuidado_infantil/Config/general/env.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {

  static final String routeName = '/about';
  const AboutScreen({super.key});
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          SizedBox.shrink()
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Acerca de la APP',
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 15.h,),
            Image.asset('assets/images/logo_cuidado_activo.png', height: 100.h,),
            SizedBox(height: 15.h,),
            Text(
              'Versión $APP_VERSION',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400)),
            ),
            Text(
              '© 2026 VMB',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 20.h,),
            Text(
              APP_DESCRIPTION,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h,),
            Row(
              children: <Widget>[
                Icon(UiIcons.envelope, size: 16.sp),
                SizedBox(width: 5.w,),
                Text(
                  EMAIL_SUPPORT,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                ),
              ],
            ),

            SizedBox(height: 40.h,),

            Text(
              'Acerca de la Institución',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 15.h,),
            Image.asset('assets/images/logo_vmb.png', height: 40.h),
            SizedBox(height: 15.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.shield, size: 16.sp, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Organización',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Flexible(
                  child: Text(
                    ORGANIZATION_NAME,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Row(
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.envelope, size: 16.sp, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Correo electrónico',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Text(
                  ORGANIZATION_EMAIL,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Row(
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.smartphone, size: 16, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Teléfono de contacto',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Text(
                  ORGANIZATION_PHONE,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.placeholder, size: 16.sp, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Dirección',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Flexible(
                  child: Text(
                    ORGANIZATION_ADDRESS,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40.h,),

            Text(
              'Instituciones Aliadas',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 15.h,),
            Image.asset('assets/images/logo_koica.png', height: 40.h),
            SizedBox(height: 15.h,),
            Image.asset('assets/images/logo_onu.png', height: 40.h),
            SizedBox(height: 15.h,),

            SizedBox(height: 40.h,),

            Text(
              'Créditos',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 20.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.laptop, size: 20.sp, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Desarrollado por: ',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Flexible(
                  child: Text(
                    CREDITS_DEVELOPMENT,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.paintBrush, size: 20.sp, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Dibujos: ',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Flexible(
                  child: Text(
                    CREDITS_DRAWS,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 20.w,
                    alignment: Alignment.centerLeft,
                    child: Icon(UiIcons.image, size: 20.sp, color: Theme.of(context).colorScheme.secondary,)
                ),
                SizedBox(width: 5.w,),
                Text(
                  'Recursos gráficos: ',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                ),
                SizedBox(width: 10.w,),
                Flexible(
                  child: Text(
                    CREDITS_GRAPHICS_RESOURCES,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40.h,),
          ],
        ),
      ),
    );
  }
}
