import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultThemeGetter {
  static ThemeData get() {
    const primary = Color(0xFFFF8A00);
    const primaryDark = Color(0xFFE57C00);
    const primaryContainer = Color(0xFFFFB800);
    const onBackground = Colors.black;
    const surface = Colors.white;
    const onSurface = Color(0xFFFFD027);

    return ThemeData(
      primaryColor: primary,
      primaryColorDark: primaryDark,
      textTheme: TextTheme(
        bodyText1: GoogleFonts.firaSans(
          fontWeight: FontWeight.w400,
          fontSize: 17.0,
          height: 1.1,
        ),
        bodyText2: GoogleFonts.firaSans(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          height: 1.1,
        ),
        headline1: GoogleFonts.firaSans(
          fontWeight: FontWeight.w700,
          fontSize: 37.0,
          height: 1.1,
        ),
        headline2: GoogleFonts.firaSans(
          fontWeight: FontWeight.w700,
          fontSize: 30.0,
          height: 1.1,
        ),
        headline3: GoogleFonts.firaSans(
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
          height: 1.1,
        ),
        subtitle1: GoogleFonts.firaSans(
          fontWeight: FontWeight.w700,
          fontSize: 25.0,
          height: 1.1,
        ),
        subtitle2: GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          height: 1.1,
        ),
        overline: GoogleFonts.firaSans(
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
          height: 1.1,
        ),
        button: GoogleFonts.firaSans(
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
          height: 1.1,
        ),
      ).apply(
        bodyColor: onBackground,
        displayColor: onBackground,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          minimumSize: MaterialStateProperty.all(
            const Size(
              double.infinity,
              68,
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(61),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return const Color.fromARGB(255, 186, 186, 185);
              }
              return primary;
            },
          ),
        ),
      ),
      colorScheme: const ColorScheme(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        background: Colors.white,
        secondaryContainer: Colors.white,
        onBackground: onBackground,
        error: Colors.white,
        onError: Colors.white,
        brightness: Brightness.light,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );
  }
}
