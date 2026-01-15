import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSnackBar {

  late BuildContext context;
  String message = "";
  String title = "Advertencia";

  CustomSnackBar._internal();
  static final CustomSnackBar _instance = CustomSnackBar._internal();
  factory CustomSnackBar({required BuildContext context}) {
    _instance.context = context;
    return _instance;
  }

  void show({ String? message, String? title}) {
    _instance.message = message ?? "-";
    _instance.title = title ?? _instance.title;
    Get.snackbar('', '',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        backgroundColor: Color(0xFF222222),
        colorText: Colors.white,
        titleText: Text(_instance.title, style: Theme.of(_instance.context).textTheme.labelSmall?.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),),
        messageText: Text(_instance.message, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 13.sp),),
        margin: EdgeInsets.only(bottom: 5.h, right: 5.0, left: 5.w),
        isDismissible: true,
        dismissDirection:  DismissDirection.horizontal
    );
  }

}