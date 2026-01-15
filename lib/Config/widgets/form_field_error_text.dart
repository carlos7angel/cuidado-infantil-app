import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Widget que muestra el error de un campo del formulario con padding personalizado
/// Úsalo después de un FormBuilderTextField para mostrar el error con padding personalizado
class FormFieldErrorText extends StatelessWidget {
  final String fieldName;
  final double paddingLeft;
  final int maxLines;
  final TextStyle? textStyle;

  const FormFieldErrorText({
    super.key,
    required this.fieldName,
    this.paddingLeft = 0,
    this.maxLines = 2,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final formState = FormBuilder.of(context);
        if (formState == null) return const SizedBox.shrink();

        final field = formState.fields[fieldName];
        if (field == null || field.isValid || field.errorText == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(
            left: paddingLeft,
            top: 4,
          ),
          child: Text(
            field.errorText!,
            style: textStyle ??
                Theme.of(context).textTheme.bodySmall?.merge(
                      TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

