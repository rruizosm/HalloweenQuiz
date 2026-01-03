import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HalloweenTheme {
  // Colors
  static const Color bloodRed = Color(0xFF8A0303);
  static const Color darkBloodRed = Color(0xFF4B0000);
  static const Color pumpkinOrange = Color(0xFFFF6F00);
  static const Color midnightBlack = Color(0xFF000000);
  static const Color ghostWhite = Color(0xFFF5F5F5);
  static const Color charcoal = Color(0xFF1A1A1A);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      midnightBlack,
      darkBloodRed,
      bloodRed,
      pumpkinOrange,
    ],
    stops: [0.1, 0.4, 0.7, 1.0],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xD9000000), // Black with 85% opacity
      Color(0xD92C0404), // Dark red with 85% opacity
    ],
  );

  // Text Styles
  static TextStyle get titleStyle => GoogleFonts.creepster(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: pumpkinOrange,
        shadows: [
          const Shadow(
            blurRadius: 10,
            color: bloodRed,
            offset: Offset(2, 2),
          ),
        ],
      );

  static TextStyle get headerStyle => GoogleFonts.creepster(
        fontSize: 28,
        color: ghostWhite,
        letterSpacing: 1.2,
      );

  static TextStyle get bodyStyle => GoogleFonts.montserrat(
        fontSize: 16,
        color: ghostWhite,
        height: 1.5,
      );
      
  static TextStyle get buttonTextStyle => GoogleFonts.creepster(
        fontSize: 22,
        color: midnightBlack, 
        letterSpacing: 1.5,
  );
}
