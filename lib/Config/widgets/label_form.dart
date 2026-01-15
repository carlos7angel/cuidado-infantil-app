import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class LabelForm extends StatelessWidget {

  String text;

  LabelForm({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
      // padding: EdgeInsets.only(bottom: 10.h),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.left,
      ),
    );
  }
}
