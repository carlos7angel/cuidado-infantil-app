import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: constant_identifier_names
const GRAY_LIGHT_GRADIENT_BUBBLE = LinearGradient(
  colors: [
    Color.fromRGBO(245, 247, 250, 0.8),
    Color.fromRGBO(245, 247, 250, 1)
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
// ignore: constant_identifier_names
const GRAY_DARK_GRADIENT_BUBBLE = LinearGradient(
  colors: [
    Color.fromRGBO(230, 233, 237, 1),
    Color.fromRGBO(230, 233, 237, 0.7)
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
// ignore: constant_identifier_names
const PRIMARY_GRADIENT = LinearGradient(
  colors: [Color(0xFF009DB5), Color(0xFF00B1CC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class Themes {
  static ThemeData darkTheme() {
    final ThemeData themeDark = ThemeData.dark();

    return themeDark.copyWith(
      primaryColor: const Color(0xFF252525),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF2C2C2C),
      dividerColor: AppColors.hintColor(1),
      focusColor: AppColors.accentDarkColor(1),
      hintColor: AppColors.secondDarkColor(1),
      colorScheme: themeDark.colorScheme.copyWith(
        secondary: AppColors.mainColor(1),
        surface: const Color(0xFF2C2C2C),
      ),
      appBarTheme: const AppBarTheme(color: Color(0xFF2C2C2C)),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.0,
          color: AppColors.secondDarkColor(1),
        ),
        displayMedium: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.0,
          height: 1.0,
          color: AppColors.mainDarkColor(1),
        ),
        displaySmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.0,
          height: 1.2,
          color: AppColors.secondDarkColor(1),
        ),
        headlineLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.0,
          height: 1.0,
          color: AppColors.accentDarkColor(1),
        ),
        headlineMedium: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFe4e4e4),
        ),
        headlineSmall: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFdddddd),
        ),
        titleLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.mainDarkColor(1),
        ),
        titleMedium: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondDarkColor(1),
        ),
        titleSmall: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondDarkColor(0.6),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondDarkColor(1),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondDarkColor(1),
        ),
        bodySmall: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondDarkColor(1),
        ),
      ).apply(fontFamily: 'Poppins'),
    );
  }

  static ThemeData primaryTheme() {
    final ThemeData themeLight = ThemeData.light();

    return themeLight.copyWith(
      primaryColor: const Color(0xFFFFFFFF),
      brightness: Brightness.light,
      colorScheme: themeLight.colorScheme.copyWith(
        secondary: AppColors.mainColor(1),
      ),
      focusColor: AppColors.accentColor(1),
      hintColor: AppColors.secondColor(1),
      dividerColor: AppColors.secondColor(1),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.0,
          color: AppColors.secondColor(1),
        ),
        displayMedium: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.0,
          height: 1.0,
          color: AppColors.mainColor(1),
        ),
        displaySmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.0,
          height: 1.2,
          color: AppColors.secondColor(1),
        ),
        headlineLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.0,
          height: 1.0,
          color: AppColors.accentColor(1),
        ),
        headlineMedium: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.gray66Color(1),
        ),
        headlineSmall: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.gray66Color(1),
        ),
        titleLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.gray66Color(1),
        ),
        titleMedium: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondColor(1),
        ),
        titleSmall: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondColor(1),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondColor(1),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.secondColor(1),
        ),
        bodySmall: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondColor(1),
        ),
      ).apply(fontFamily: 'Poppins'),
    );
  }
}

class AppColors {
  static const Color _mainColor = Color(0xFF009DB5);
  static const Color _mainDarkColor = Color(0xFF22B7CE);
  static const Color _secondColor = Color(0xFF04526B);
  static const Color _secondDarkColor = Color(0xFFE7F6F8);
  static const Color _accentColor = Color(0xFFADC4C8);
  static const Color _accentDarkColor = Color(0xFFADC4C8);
  static const Color _gray66Color = Color(0xFF666666);
  static const Color _gray99Color = Color(0xFF9E9E9E);

  static Color mainColor(double opacity) {
    return _mainColor.withOpacity(opacity);
  }

  static Color secondColor(double opacity) {
    return _secondColor.withOpacity(opacity);
  }

  static Color accentColor(double opacity) {
    return _accentColor.withOpacity(opacity);
  }

  static Color mainDarkColor(double opacity) {
    return _mainDarkColor.withOpacity(opacity);
  }

  static Color secondDarkColor(double opacity) {
    return _secondDarkColor.withOpacity(opacity);
  }

  static Color hintColor(double opacity) {
    return _accentDarkColor.withOpacity(opacity);
  }

  static Color accentDarkColor(double opacity) {
    return _accentDarkColor.withOpacity(opacity);
  }

  static Color gray66Color(double opacity) {
    return _gray66Color.withOpacity(opacity);
  }

  static Color gray99Color(double opacity) {
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
    this.context = context;
    MediaQueryData queryData = MediaQuery.of(context);
    _height = queryData.size.height / 100.0;
    _width = queryData.size.width / 100.0;
    _heightPadding =
        _height - ((queryData.padding.top + queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (queryData.padding.left + queryData.padding.right) / 100.0;
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