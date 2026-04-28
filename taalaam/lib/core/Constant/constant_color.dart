import 'package:flutter/material.dart';

class KColors {
  static const Color startGradient = Color(0xFF007A6C);
  static const Color lightGRayContainer = Color(0xFFE0F2F1);
  static const Color primaryAlpha20 = Color(0xFFEBF9F8);
  static const Color bordorGreen = Color(0xFFBCEBE7);
  static const Color darkGray = Color(0XFF00695C);

  static const Color primary = Color(0xFF009788);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteAlpha15 = Color(0x26FFFFFF);

  static const Color title = Color(0xFF78909C);

  static const Color lightPrimary = Color(0xFF01AD9C);
  static const Color secondary = Color(0xFF78909C);
  static const Color background = Color(0xFFF8FFFE);
  static const Color bordorColor = Color(0xFFF0F0F0);
  static const Color backgroundCourse = Color(0xFFF4FAF9);

  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color lightblue = Color(0xFFE3F2FD);
  static const Color darkblue = Color(0xFF1565C0);
  static const Color lightred = Color(0xFFFCE4EC);
  static const Color darkred = Color(0xFFC62828);
  static const Color borderComplete = Color(0xFFC6E5C8);
  static const Color containerComplete = Color(0xFFF5FAF5);

  static const Color borderDefault = Color(0xFFB2D8D8);
  static const Color borderFocused = Color(0xFF7BBCBC);
  static const Color borderDisabled = Color(0xFFD6ECEC);
  static const Color borderError = Color(0xFFE24B4A);

  static const Color hint = Color(0xFFE0ECEA);
  static const Color icon = Color(0xFFAAC8C8);
  static const Color fill = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF2C4A4A);
  static const Color error = Color(0xFFE24B4A);

  static const linearGradiunt = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [KColors.startGradient, KColors.primary],
  );
}

OutlineInputBorder border(Color color, {double width = 1.2}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
// static const Color secondary = Color(0xFF8B8B8B);

const List<BoxShadow> shadowBlack = [
  BoxShadow(color: Color(0x04000000), spreadRadius: 8, blurRadius: 8),
];
const List<BoxShadow> shadowGreen = [
  BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 14,
    color: KColors.primaryAlpha20,
  ),
];

const BoxBorder bottomBorder = Border(
  bottom: BorderSide(color: KColors.bordorColor, width: 1),
);
