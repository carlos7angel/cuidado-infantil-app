import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyList extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final bool useFullHeight;

  const EmptyList({
    super.key,
    this.message,
    this.icon,
    this.useFullHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      height: useFullHeight ? null : config.App(context).appHeight(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                      Theme.of(context).focusColor,
                      Theme.of(context).focusColor.withOpacity(0.1),
                    ])),
                child: Icon(
                  icon ?? UiIcons.bell,
                  color: Theme.of(context).primaryColor,
                  size: 70.sp,
                ),
              ),
              Positioned(
                right: -30.w,
                bottom: -50.h,
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(150.r),
                  ),
                ),
              ),
              Positioned(
                left: -20.w,
                top: -50.h,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150.r),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15.h),
          Opacity(
            opacity: 0.4,
            child: Text(
              message ?? 'No hay Registros',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }
}
