import 'package:flutter/material.dart';

class AppTheme {
  // YouTube-inspired Color Palette
  static const Color youtubeRed = Color(0xFFFF0000);
  static const Color youtubeRedDark = Color(0xFFCC0000);
  static const Color youtubeBlue = Color(0xFF065FD4);
  static const Color youtubeBlueDark = Color(0xFF0D47A1);
  
  // YouTube Dark Theme Colors (Primary)
  static const Color youtubeDarkBg = Color(0xFF0F0F0F);
  static const Color youtubeDarkSurface = Color(0xFF1F1F1F);
  static const Color youtubeDarkSurfaceVariant = Color(0xFF272727);
  static const Color youtubeDarkBorder = Color(0xFF303030);
  static const Color youtubeDarkText = Color(0xFFFFFFFF);
  static const Color youtubeDarkTextSecondary = Color(0xFFAAAAAA);
  static const Color youtubeDarkTextTertiary = Color(0xFF717171);
  
  // YouTube Light Theme Colors
  static const Color youtubeLightBg = Color(0xFFFFFFFF);
  static const Color youtubeLightSurface = Color(0xFFF9F9F9);
  static const Color youtubeLightSurfaceVariant = Color(0xFFF2F2F2);
  static const Color youtubeLightBorder = Color(0xFFE5E5E5);
  static const Color youtubeLightText = Color(0xFF0F0F0F);
  static const Color youtubeLightTextSecondary = Color(0xFF606060);
  static const Color youtubeLightTextTertiary = Color(0xFF909090);

  // Neutral Grays (YouTube style)
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // Semantic Colors (YouTube style)
  static const Color successGreen = Color(0xFF00FF00);
  static const Color warningAmber = Color(0xFFFFD600);
  static const Color warningOrange = Color(0xFFFF8C00);
  static const Color errorRed = youtubeRed;
  static const Color focusPurple = Color(0xFF9C27B0);
  static const Color accentBlue = youtubeBlue;
  
  // Legacy color aliases for backward compatibility
  static const Color primaryBlue = youtubeBlue;
  static const Color breakBlue = Color(0xFF00FFFF);

  // Project Colors (YouTube-inspired vibrant palette)
  static const List<Color> projectColors = [
    youtubeRed,          // YouTube Red
    Color(0xFFFF8C00),   // Orange
    Color(0xFFFFD600),   // Yellow
    Color(0xFF00FF00),   // Green
    Color(0xFF00FFFF),   // Cyan
    youtubeBlue,         // YouTube Blue
    Color(0xFF9C27B0),   // Purple
    Color(0xFFE91E63),   // Pink
  ];

  // Typography - YouTube uses Roboto
  static const String primaryFontFamily = 'Roboto';
  static const String monospaceFontFamily = 'Roboto Mono';

  // Spacing System (YouTube uses 8px base unit)
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;
  static const double space20 = 80;
  static const double space24 = 96;

  // Border Radius (YouTube style - minimal radius)
  static const double radiusNone = 0;
  static const double radiusSm = 2;
  static const double radiusMd = 4;
  static const double radiusLg = 8;
  static const double radiusXl = 12;
  static const double radiusFull = 9999;

  // Component Spacing
  static const double buttonPaddingVertical = 12;
  static const double buttonPaddingHorizontal = 24;
  static const double inputPaddingVertical = 12;
  static const double inputPaddingHorizontal = 16;
  static const double cardPadding = 24;
  static const double modalPadding = 32;
  static const double sectionMargin = 48;
  static const double navigationHeight = 64;
  static const double sidebarWidth = 280;

  // Shadows (YouTube style - subtle elevation)
  static const BoxShadow shadowSm = BoxShadow(
    offset: Offset(0, 1),
    blurRadius: 3,
    color: Color(0x0A000000),
  );

  static const BoxShadow shadowMd = BoxShadow(
    offset: Offset(0, 2),
    blurRadius: 8,
    color: Color(0x10000000),
  );

  static const BoxShadow shadowLg = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color(0x15000000),
  );

  static const BoxShadow shadowXl = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    color: Color(0x15000000),
  );

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  // Light Theme (YouTube style)
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: youtubeRed,
      onPrimary: Colors.white,
      secondary: youtubeBlue,
      onSecondary: Colors.white,
      surface: youtubeLightSurface,
      onSurface: youtubeLightText,
      error: errorRed,
      onError: Colors.white,
      outline: youtubeLightBorder,
      outlineVariant: gray200,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      fontFamily: primaryFontFamily,
      
      // App Bar Theme (YouTube style)
      appBarTheme: const AppBarTheme(
        backgroundColor: youtubeLightBg,
        foregroundColor: youtubeLightText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: youtubeLightText,
        ),
        toolbarHeight: 56,
      ),

      // Card Theme (YouTube style)
      cardTheme: CardThemeData(
        color: youtubeLightBg,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide.none,
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Elevated Button Theme (YouTube style)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: youtubeRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: gray300,
          disabledForegroundColor: gray500,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: buttonPaddingHorizontal,
            vertical: 10,
          ),
          textStyle: const TextStyle(
            inherit: true,
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: youtubeBlue,
          side: const BorderSide(color: gray300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: buttonPaddingHorizontal,
            vertical: buttonPaddingVertical,
          ),
          textStyle: const TextStyle(
            inherit: true,
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: youtubeBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: buttonPaddingHorizontal,
            vertical: buttonPaddingVertical,
          ),
          textStyle: const TextStyle(
            inherit: true,
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: youtubeBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: inputPaddingHorizontal,
          vertical: inputPaddingVertical,
        ),
        hintStyle: const TextStyle(
          inherit: true,
          color: gray400,
          fontFamily: primaryFontFamily,
        ),
      ),

      // Typography Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: gray900,
          height: 1.25,
        ),
        displayMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: gray900,
          height: 1.29,
        ),
        headlineLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: gray900,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: gray900,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: gray900,
          height: 1.33,
        ),
        bodyLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: gray900,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: gray600,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: gray500,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: gray900,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: gray700,
          height: 1.33,
        ),
      ),

      // Navigation Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: gray50,
        width: sidebarWidth,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: space6),
        minVerticalPadding: space3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue;
          }
          return gray300;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: youtubeBlue,
        inactiveTrackColor: gray300,
        thumbColor: youtubeBlue,
        overlayColor: Color(0x1A065FD4),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: youtubeRed,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: gray200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Dark Theme (YouTube style)
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: youtubeRed,
      onPrimary: Colors.white,
      secondary: youtubeBlue,
      onSecondary: Colors.white,
      surface: youtubeDarkSurface,
      onSurface: youtubeDarkText,
      error: errorRed,
      onError: Colors.white,
      outline: youtubeDarkBorder,
      outlineVariant: youtubeDarkBorder,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      fontFamily: primaryFontFamily,
      
      // App Bar Theme (YouTube Dark)
      appBarTheme: const AppBarTheme(
        backgroundColor: youtubeDarkBg,
        foregroundColor: youtubeDarkText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: youtubeDarkText,
        ),
        toolbarHeight: 56,
      ),

      // Card Theme (YouTube Dark)
      cardTheme: CardThemeData(
        color: youtubeDarkSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide.none,
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Elevated Button Theme (YouTube Dark)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: youtubeRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: gray600,
          disabledForegroundColor: gray400,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: buttonPaddingHorizontal,
            vertical: 10,
          ),
          textStyle: const TextStyle(
            inherit: true,
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme (YouTube Dark)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: youtubeDarkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: youtubeDarkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: youtubeDarkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: youtubeBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: inputPaddingHorizontal,
          vertical: inputPaddingVertical,
        ),
        hintStyle: const TextStyle(
          inherit: true,
          color: youtubeDarkTextTertiary,
          fontFamily: primaryFontFamily,
        ),
      ),

      // Typography Theme for Dark Mode (YouTube style)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: youtubeDarkText,
          height: 1.25,
        ),
        displayMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: youtubeDarkText,
          height: 1.29,
        ),
        headlineLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: youtubeDarkText,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: youtubeDarkText,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: youtubeDarkText,
          height: 1.33,
        ),
        bodyLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: youtubeDarkText,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: youtubeDarkTextSecondary,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: youtubeDarkTextTertiary,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: youtubeDarkText,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: youtubeDarkTextSecondary,
          height: 1.33,
        ),
      ),

      // Navigation Drawer Theme (YouTube Dark)
      drawerTheme: const DrawerThemeData(
        backgroundColor: youtubeDarkBg,
        width: sidebarWidth,
      ),

      // Switch Theme (YouTube style)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return youtubeBlue;
          }
          return youtubeDarkBorder;
        }),
      ),

      // Floating Action Button Theme (YouTube style)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: youtubeRed,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),

      // Divider Theme (YouTube Dark)
      dividerTheme: const DividerThemeData(
        color: youtubeDarkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Timer-specific text styles (YouTube style)
  static TextStyle timerLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      inherit: true,
      fontFamily: monospaceFontFamily,
      fontSize: 48,
      fontWeight: FontWeight.w300,
      color: isDark ? youtubeDarkText : youtubeLightText,
      height: 1.17,
    );
  }

  static TextStyle timerMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      inherit: true,
      fontFamily: monospaceFontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w300,
      color: isDark ? youtubeDarkText : youtubeLightText,
      height: 1.25,
    );
  }

  static TextStyle timerSmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      inherit: true,
      fontFamily: monospaceFontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: isDark ? youtubeDarkText : youtubeLightText,
      height: 1.33,
    );
  }

  // Active timer styles (with YouTube red)
  static TextStyle timerActiveStyle(BuildContext context, TextStyle baseStyle) {
    return baseStyle.copyWith(color: youtubeRed);
  }

  // Responsive breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Helper methods for responsive design
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) return 4;
    if (width >= tabletBreakpoint) return 3;
    if (width >= mobileBreakpoint) return 2;
    return 1;
  }
}