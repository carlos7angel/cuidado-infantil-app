import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {

  final Gradient gradient;
  final String text;
  final double size;
  final FontWeight weight;
  final TextAlign align;
  // final String fontFamily;

  const GradientText(
    this.gradient, 
    this.text, 
    {super.key, this.size = 48, this.weight = FontWeight.w600, this.align = TextAlign.center}
  );

  @override
  Widget build(BuildContext context) {

    final rect = Rect.fromLTWH(0.0, 0.0, 120.0, 70.0);
    final Shader linearGradient = gradient.createShader(rect);

    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          foreground: Paint()..shader = linearGradient
      ),
    );
  }
}
