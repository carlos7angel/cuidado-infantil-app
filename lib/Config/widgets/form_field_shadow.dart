import 'package:flutter/material.dart';

class FormFieldShadow extends StatelessWidget {

  final Widget child;
  final double? fixedHeight;
  final BoxShadow? customShadow;

  const FormFieldShadow({
    super.key,
    required this.child,
    this.fixedHeight,
    this.customShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fixedHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // color: Colors.transparent,
        color: Theme.of(context).primaryColor,
        // boxShadow: customShadow != null ? [customShadow!] : [
        //   BoxShadow(
        //     color: Colors.black45.withOpacity(0.15),
        //     offset: Offset(1.0, 2.0),
        //     blurRadius: 2,
        //   )
        // ],
      ),
      child: child,
    );
  }
}