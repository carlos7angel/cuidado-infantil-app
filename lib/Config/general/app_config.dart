import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_config.dart' as config;
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const GRAY_LIGHT_GRADIENT_BUBBLE = LinearGradient(colors: [Color.fromRGBO(245, 247, 250, 0.8), Color.fromRGBO(245, 247, 250, 1)], begin: Alignment.topLeft, end: Alignment.bottomRight);
// ignore: constant_identifier_names
const GRAY_DARK_GRADIENT_BUBBLE = LinearGradient(colors: [Color.fromRGBO(230, 233, 237, 1), Color.fromRGBO(230, 233, 237, 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight);
// ignore: constant_identifier_names
const PRIMARY_GRADIENT = LinearGradient(colors: [Color(0xFF009DB5), Color(0xFF00B1CC)], begin: Alignment.topLeft, end: Alignment.bottomRight);


class Themes {

  static ThemeData darkTheme() {

    final ThemeData themeDark = ThemeData();

    return themeDark.copyWith(
      // fontFamily: 'Poppins',
      // primaryColor: Color(0xFF252525),
      // brightness: Brightness.dark,
      // scaffoldBackgroundColor: Color(0xFF2C2C2C),
      // appBarTheme: AppBarTheme(color: Color(0xFF2C2C2C)),
      // // accentColor: config.Colors().mainDarkColor(1),
      // colorScheme: themeDark.colorScheme.copyWith(secondary: config.Colors().mainColor(1)),
      // hintColor: config.Colors().secondDarkColor(1),
      // dividerColor: config.Colors().hintDarkColor(1),
      // focusColor: config.Colors().accentDarkColor(1),

      textTheme: TextTheme(
        // button: TextStyle(color: Color(0xFF252525)),
        // headline1: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.0, color: config.Colors().secondDarkColor(1)),
        // headline2: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.0, height: 1.0, color: config.Colors().secondDarkColor(1)),
        // headline3: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w600, letterSpacing: -0.0, height: 1.2, color: config.Colors().secondDarkColor(1)),
        // headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: -0.0, height: 1.2, color: config.Colors().secondDarkColor(1)),
        // headline5: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color(0xFFe4e4e4)),
        // headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xFFdddddd)),
        // subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainDarkColor(1)),
        // subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
        // caption: TextStyle(fontSize: 13.0, color: config.Colors().secondDarkColor(0.6)),
        // bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
        // bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1)),
        // overline: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Color(0xFFaaaaaa)),
      ).apply(
          fontFamily: 'Poppins'
      ),
    );
  }

  static ThemeData primaryTheme() {

    final ThemeData themeLight = ThemeData();

    return themeLight.copyWith(
      primaryColor: Color(0xFFFFFFFF),
      brightness: Brightness.light,
      colorScheme: themeLight.colorScheme.copyWith(secondary: config.Colors().mainColor(1)),
      focusColor: config.Colors().accentColor(1),
      hintColor: config.Colors().secondColor(1),
      dividerColor: config.Colors().secondColor(1),
      scaffoldBackgroundColor: Color(0xFFFAFAFA),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.0, color: config.Colors().secondColor(1)),
        displayMedium: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, letterSpacing: -0.0, height: 1.0, color: config.Colors().mainColor(1)),
        displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, letterSpacing: -0.0, height: 1.2, color: config.Colors().secondColor(1)),

        headlineLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500, letterSpacing: -0.0, height: 1.0, color: config.Colors().accentColor(1)),
        headlineMedium: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500, color: config.Colors().gray66Color(1)),
        headlineSmall: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: config.Colors().gray66Color(1)),

        titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: config.Colors().gray66Color(1)),
        titleMedium: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
        titleSmall: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),

        bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
        bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
        bodySmall: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),

        // button: TextStyle(color: Color(0xFFFFFFFF)),
        // caption: TextStyle(fontSize: 13.sp, color: config.Colors().secondColor(0.6)),
        // overline: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Color(0xFFaaaaaa)),

      ).apply(
          fontFamily: 'Poppins'
      ),
    );
  }

}

class Colors {
  final Color _mainColor = Color(0xFF009DB5);
  final Color _mainDarkColor = Color(0xFF22B7CE);
  final Color _secondColor = Color(0xFF04526B);
  final Color _secondDarkColor = Color(0xFFE7F6F8);
  final Color _accentColor = Color(0xFFADC4C8);
  final Color _accentDarkColor = Color(0xFFADC4C8);
  final Color _gray66Color = Color(0xFF666666);
  final Color _gray99Color = Color(0xFF9E9E9E);


  Color mainColor(double opacity) {
    return  _mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return _secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return _accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return _mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return _secondDarkColor.withOpacity(opacity);
  }

  Color hintColor(double opacity) {
    return _accentDarkColor.withOpacity(opacity);
  }

  Color gray66Color(double opacity) {
    return _gray66Color.withOpacity(opacity);
  }

  Color gray99Color(double opacity) {
    return _gray99Color.withOpacity(opacity);
  }

}

class App {

  late BuildContext context;
  late double _height;
  late double _width;
  late double _heightPadding;
  late double _widthPadding;

  App(BuildContext context) {
    context = context;
    MediaQueryData queryData = MediaQuery.of(context);
    _height = queryData.size.height / 100.0;
    _width = queryData.size.width / 100.0;
    _heightPadding = _height - ((queryData.padding.top + queryData.padding.bottom) / 100.0);
    _widthPadding = _width - (queryData.padding.left + queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}