import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstantUi {
  static double fontSize = 60;

  static Color textColor1 = Colors.black;

  static Color guildLineColor = Colors.blue;

  static TextStyle textStyle1 = GoogleFonts.getFont(
    'Lato',
    fontSize: fontSize,
    color: textColor1,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );
}
