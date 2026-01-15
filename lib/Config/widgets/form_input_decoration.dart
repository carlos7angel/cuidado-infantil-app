import 'package:flutter/material.dart';

class FormInputDecoration extends InputDecoration {

  final BuildContext context;

  FormInputDecoration({ required this.context, String? placeholder = '', Widget? icon}): super(
    hintText: placeholder,
    suffixIcon: icon,
    hintStyle: Theme.of(context).textTheme.bodySmall!.merge(
      TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)
      )
    ), // placeholder
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    suffixStyle: Theme.of(context).textTheme.headlineMedium!,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        // color: Colors.grey.withOpacity(0.2),
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color:Theme.of(context).colorScheme.secondary,
          width: 1.2
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Color(0xFFff0000),
          width: 1.2
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.2
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
          width: 1.2
      ),
    ),
    errorStyle: Theme.of(context).textTheme.bodySmall?.merge(
      TextStyle(
        color: Colors.redAccent,
        fontSize: 11,
        height: 1.2,
      )
    ),
    errorMaxLines: 2,
    filled: true,
    fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0),
  );

}
