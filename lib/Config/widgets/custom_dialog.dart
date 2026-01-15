import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;


class CustomDialog {
  late ProgressDialog _progressDialog;
  late BuildContext _context;

  String message = "Espere por favor...";

  CustomDialog._internal();

  static final CustomDialog _instance = CustomDialog._internal();

  factory CustomDialog({required BuildContext context}) {
    _instance._context = context;

    _instance._progressDialog = ProgressDialog(
      context,
      blur: 0,
      title: SizedBox.shrink(),
      message: Text(
        _instance.message,
        style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
      ),
    );

    _instance._progressDialog.setLoadingWidget(CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(config.Colors().accentColor(1))));

    return _instance;
  }

  void show() {
    _instance._progressDialog.show();
  }

  void hide() {
    _instance._progressDialog.dismiss();
  }
}