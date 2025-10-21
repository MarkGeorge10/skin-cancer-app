import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF1976D2); // Professional blue
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color primaryTextColor = Colors.black87;

  static const Color accentColor = Color(0xFF4CAF50); // Green for secondary actions
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light gray for light theme
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark background for dark theme
  static const Color textColor = Color(0xFF212121); // Dark gray for text
  static const Color secondaryTextColor = Color(0xFF757575); // Lighter gray for hints/labels
  static const Color errorColor = Color(0xFFD32F2F); // Red for errors
  static const Color borderColor = Color(0xFFB0BEC5); // Light gray for borders
  static const Color disabledColor = Color(0xFFE0E0E0); // Gray for disabled elements
  static const Color cardColorLight = Colors.white; // White cards for light theme
  static const Color cardColorDark = Color(0xFF1E1E1E); // Dark cards for dark theme
  static const Color inputFillColorLight = Color(0xFFF8FAFC); // Off-white for input fields in light theme
  static const Color inputFillColorDark = Color(0xFF2A2A2A); // Dark gray for input fields in dark theme

  // Theme-aware input fill color
  static Color inputFillColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? inputFillColorDark : inputFillColorLight;
  }

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  );

  static const TextStyle headlineText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  );

  static const TextStyle subHeadlineText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: textColor,
    height: 1.5,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    color: errorColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardTitleText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  // Padding and Margins
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
  static const EdgeInsets inputPadding = EdgeInsets.all(12.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);

  // Border Radii
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(12.0));

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 4.0,
    spreadRadius: 1.0,
    offset: Offset(0, 2),
  );

  // Input Decoration Theme
  static InputDecorationTheme inputDecorationTheme(BuildContext context) {
    return InputDecorationTheme(
      filled: true, // Enable fill color
      fillColor: inputFillColor(context), // Use theme-aware input fill color
      border: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: BorderSide(color: errorColor, width: 2.0),
      ),
      labelStyle: labelText,
      hintStyle: hintText,
      errorStyle: errorText,
      contentPadding: inputPadding,
    );
  }

  // Button Theme
  static ButtonStyle elevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: buttonPadding,
      textStyle: buttonText,
      shape: RoundedRectangleBorder(
        borderRadius: buttonBorderRadius,
      ),
      elevation: 2.0,
      disabledBackgroundColor: disabledColor,
      disabledForegroundColor: secondaryTextColor,
    );
  }

  // Card Theme
  static CardThemeData cardTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CardThemeData(
      color: isDark ? cardColorDark : cardColorLight,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: cardBorderRadius,
      ),
      shadowColor: Colors.black12,
      margin: cardMargin,
    );
  }

  // AppBar Theme
  static AppBarTheme appBarTheme(BuildContext context) {
    return AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2.0,
      titleTextStyle: headingStyle.copyWith(color: Colors.white), // Use headingStyle
    );
  }

  // Theme Data
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
      ),
      textTheme: TextTheme(
        headlineLarge: headingStyle, // Map headingStyle to headlineLarge
        headlineMedium: headlineText,
        headlineSmall: subHeadlineText,
        bodyMedium: bodyText,
        labelMedium: labelText,
        bodySmall: hintText,
      ),
      inputDecorationTheme: inputDecorationTheme(context),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle(context),
      ),
      cardTheme: cardTheme(context),
      appBarTheme: appBarTheme(context),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        background: darkBackgroundColor,
      ),
      textTheme: TextTheme(
        headlineLarge: headingStyle.copyWith(color: Colors.white), // Theme-aware headingStyle
        headlineMedium: headlineText.copyWith(color: Colors.white),
        headlineSmall: subHeadlineText.copyWith(color: Colors.white),
        bodyMedium: bodyText.copyWith(color: Colors.white),
        labelMedium: labelText.copyWith(color: Colors.white70),
        bodySmall: hintText.copyWith(color: Colors.white70),
      ),
      inputDecorationTheme: inputDecorationTheme(context).copyWith(
        border: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(color: Colors.white30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(color: Colors.white30),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle(context),
      ),
      cardTheme: cardTheme(context),
      appBarTheme: appBarTheme(context),
    );
  }
}