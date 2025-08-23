import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors - Apple-inspired Clean Palette
  static const Color lightPrimary = Color(0xFF007AFF);        // iOS Blue
  static const Color lightPrimaryVariant = Color(0xFF5856D6);  // iOS Purple  
  static const Color lightSecondary = Color(0xFF32D74B);      // iOS Green
  static const Color lightAccent = Color(0xFFFF9500);         // iOS Orange
  
  // Light Theme Backgrounds
  static const Color lightBackground = Color(0xFFFAFAFA);     // System background
  static const Color lightSurface = Color(0xFFFFFFFF);       // Card surface
  static const Color lightSurfaceSecondary = Color(0xFFF2F2F7); // Secondary background
  static const Color lightSurfaceGrouped = Color(0xFFF2F2F7);   // Grouped background

  // Light Theme Text
  static const Color lightText = Color(0xFF000000);           // Primary text
  static const Color lightTextSecondary = Color(0xFF3C3C43);  // Secondary text 
  static const Color lightTextTertiary = Color(0xFF6D6D7A);   // Tertiary text
  static const Color lightTextQuaternary = Color(0xFF8E8E93); // Quaternary text

  // Light Theme Separators
  static const Color lightSeparator = Color(0x3C3C4336);      // Separator
  static const Color lightSeparatorOpaque = Color(0xFFC6C6C8); // Opaque separator
  
  // Dark Theme Colors - Apple Dark Mode
  static const Color darkPrimary = Color(0xFF0A84FF);         // iOS Dark Blue
  static const Color darkPrimaryVariant = Color(0xFF5E5CE6);   // iOS Dark Purple
  static const Color darkSecondary = Color(0xFF30D158);       // iOS Dark Green
  static const Color darkAccent = Color(0xFFFF9F0A);          // iOS Dark Orange
  
  // Dark Theme Backgrounds  
  static const Color darkBackground = Color(0xFF000000);      // System background
  static const Color darkSurface = Color(0xFF1C1C1E);        // Card surface
  static const Color darkSurfaceSecondary = Color(0xFF2C2C2E); // Secondary surface
  static const Color darkSurfaceGrouped = Color(0xFF000000);    // Grouped background

  // Dark Theme Text
  static const Color darkText = Color(0xFFFFFFFF);            // Primary text
  static const Color darkTextSecondary = Color(0xFFEBEBF5);   // Secondary text
  static const Color darkTextTertiary = Color(0xFF9999A3);    // Tertiary text  
  static const Color darkTextQuaternary = Color(0xFF6D6D7A);  // Quaternary text

  // Dark Theme Separators
  static const Color darkSeparator = Color(0x54545458);       // Separator
  static const Color darkSeparatorOpaque = Color(0xFF38383A); // Opaque separator
  
  // Legacy support - mapping old constants to new ones
  static const Color lightBorder = lightSeparatorOpaque;
  static const Color darkBorder = darkSeparatorOpaque;
  static const Color darkSurfaceVariant = darkSurfaceSecondary;
  static const Color lightSurfaceVariant = lightSurfaceSecondary;
  static const Color lightAccentDark = Color(0xFF7A6900);
  static const Color darkPrimaryDark = darkPrimaryVariant;
  static const Color darkForest = Color(0xFF1C1C1E);
  
  // Legacy radius mapping
  static const double radiusLg = radiusLarge;
  static const double radiusMd = radiusSmall;
  static const double radiusSm = radiusTight;

  // Neutral Grays adapted to our palette
  static const Color gray50 = lightBackground;
  static const Color gray100 = lightSurface;
  static const Color gray200 = Color(0xFFE8E0E0);
  static const Color gray300 = lightSurfaceVariant;
  static const Color gray400 = lightBorder;
  static const Color gray500 = lightTextSecondary;
  static const Color gray600 = lightText;
  static const Color gray700 = lightAccentDark;
  static const Color gray800 = darkSurface;
  static const Color gray900 = darkBackground;

  // Semantic Colors
  static const Color successLight = lightAccent;             // Sage green for success
  static const Color warningLight = Color(0xFFD4A574);       // Warm beige for warnings
  static const Color errorLight = Color(0xFFC89B9B);         // Muted red from palette
  static const Color focusLight = lightPrimary;              // Lavender for focus
  
  // Dark theme semantic colors
  static const Color successDark = darkPrimary;              // Bright green for success
  static const Color warningDark = Color(0xFFA3B875);        // Harmonious yellow-green
  static const Color errorDark = Color(0xFFFF453A);          // iOS Dark Red for errors
  static const Color focusDark = darkAccent;                 // Accent green for focus
  
  // Legacy aliases for backward compatibility
  static const Color primaryBlue = lightPrimary;
  static const Color breakBlue = lightAccent;
  static const Color errorRed = errorLight;
  static const Color successGreen = successLight;
  static const Color focusPurple = focusLight;
  static const Color warningAmber = warningLight;
  static const Color warningOrange = warningLight;
  
  // More legacy aliases
  static const Color calmLightSurface = lightSurface;
  static const Color calmLightSurfaceVariant = lightSurfaceVariant;
  static const Color calmLightBorder = lightBorder;
  static const Color calmLightText = lightText;
  static const Color calmLightTextSecondary = lightTextSecondary;
  static const Color calmLightTextTertiary = lightTextTertiary;
  static const Color calmWhite = lightBackground;
  static const Color falloutBlack = darkBackground;
  static const Color falloutSurface = darkSurface;
  static const Color falloutSurfaceVariant = darkSurfaceVariant;
  static const Color falloutBorder = darkBorder;
  static const Color falloutText = darkText;
  static const Color falloutTextSecondary = darkTextSecondary;
  static const Color falloutTextTertiary = darkTextTertiary;
  static const Color calmBlue = lightPrimary;
  static const Color calmTeal = lightAccent;

  // Project Colors - Light Theme (Harmonious pastels)
  static const List<Color> projectColorsLight = [
    lightPrimary,        // #BBACC1 - Lavender gray
    lightSecondary,      // #F1DEDE - Soft pink
    lightAccent,         // #909580 - Sage green
    Color(0xFFC8B5B5),   // Harmonious dusty rose
    Color(0xFFA69B9B),   // Warm taupe
    Color(0xFF8FA68F),   // Soft mint
    Color(0xFFB5A8C8),   // Light lavender
    Color(0xFF9FAF9F),   // Pale sage
  ];

  // Project Colors - Dark Theme (Professional greens)
  static const List<Color> projectColorsDark = [
    darkPrimary,         // #49E448 - Bright green
    darkPrimaryDark,     // #68E85F - Secondary green
    darkAccent,          // #80EB75 - Accent green
    Color(0xFF5FE65E),   // Vibrant green
    Color(0xFF73E772),   // Medium bright green
    Color(0xFF8BE88A),   // Soft bright green
    Color(0xFF9EEA9D),   // Light green
    Color(0xFF6EE46D),   // Fresh green
  ];

  // Dynamic project colors based on theme
  static List<Color> getProjectColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? projectColorsDark : projectColorsLight;
  }

  // Backward compatibility - defaults to light theme colors for providers without context
  static const List<Color> projectColors = projectColorsLight;

  // Typography - Clean, modern fonts
  static const String primaryFontFamily = 'SF Pro Display';
  static const String monospaceFontFamily = 'SF Mono';

  // Apple Spacing System (4pt base unit)
  static const double space1 = 2;   // Extra tight
  static const double space2 = 4;   // Tight  
  static const double space3 = 8;   // Small
  static const double space4 = 12;  // Medium-small
  static const double space5 = 16;  // Medium (standard)
  static const double space6 = 20;  // Medium-large
  static const double space7 = 24;  // Large
  static const double space8 = 32;  // Extra large
  static const double space9 = 40;  // Extra extra large
  static const double space10 = 48; // Huge
  static const double space16 = 64; // Legacy support

  // Apple Border Radius System
  static const double radiusTight = 6;
  static const double radiusSmall = 8;
  static const double radiusMedium = 10;
  static const double radiusLarge = 12; 
  static const double radiusXLarge = 16;
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

  // Apple-style shadows
  static List<BoxShadow> get appleShadowSmall => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get appleShadowMedium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];
  
  // Legacy shadow support
  static BoxShadow get shadowMd => const BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color(0x0D000000),
  );

  // Apple-style Animation System
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationExtraSlow = Duration(milliseconds: 700);

  // Apple Easing Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut; 
  static const Curve easeInOutQuint = Cubic(0.86, 0, 0.07, 1);
  static const Curve springCurve = Curves.elasticOut;

  // Light Theme
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: lightPrimary,
      onPrimary: Colors.white,
      secondary: lightAccent,
      onSecondary: Colors.white,
      surface: lightSurface,
      onSurface: lightText,
      error: errorLight,
      onError: Colors.white,
      outline: lightBorder,
      outlineVariant: gray200,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      fontFamily: primaryFontFamily,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        toolbarHeight: 56,
      ),

      // Card Theme - Apple Style
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge), // Apple card radius
          side: BorderSide(
            color: lightSeparator,
            width: 0.33, // Apple border width
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme - Apple Style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: lightTextQuaternary,
          disabledForegroundColor: lightTextTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium), // Apple corner radius
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13, // Apple button height ~44pt
          ),
          minimumSize: const Size(44, 44), // Apple minimum tap target
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimary,
          side: const BorderSide(color: lightBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
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
          foregroundColor: lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
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

      // Input Decoration Theme - Apple Style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: lightSeparatorOpaque,
            width: 0.33,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: lightSeparatorOpaque,
            width: 0.33,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: lightPrimary,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16, // Apple input padding
        ),
        hintStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: lightTextTertiary,
          height: 1.29,
        ),
      ),

      // Apple Typography Scale
      textTheme: const TextTheme(
        // Large Title - 34pt Regular
        displayLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.37,
          color: lightText,
        ),
        
        // Title 1 - 28pt Regular  
        displayMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          height: 1.29,
          letterSpacing: 0.36,
          color: lightText,
        ),
        
        // Title 2 - 22pt Regular
        headlineMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w400,
          height: 1.27,
          letterSpacing: 0.35,
          color: lightText,
        ),
        
        // Title 3 - 20pt Regular
        headlineSmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.25,
          letterSpacing: 0.38,
          color: lightText,
        ),
        
        // Headline - 17pt Semibold
        titleLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.29,
          letterSpacing: -0.41,
          color: lightText,
        ),
        
        // Body - 17pt Regular
        bodyLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.29,
          letterSpacing: -0.41,
          color: lightText,
        ),
        
        // Callout - 16pt Regular
        titleMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.31,
          letterSpacing: -0.32,
          color: lightText,
        ),
        
        // Subhead - 15pt Regular
        bodyMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: -0.24,
          color: lightTextSecondary,
        ),
        
        // Footnote - 13pt Regular
        bodySmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.38,
          letterSpacing: -0.08,
          color: lightTextSecondary,
        ),
        
        // Caption 1 - 12pt Regular
        labelMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0,
          color: lightTextSecondary,
        ),
        
        // Caption 2 - 11pt Regular
        labelSmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.36,
          letterSpacing: 0.07,
          color: lightTextSecondary,
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
          borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
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
            return lightPrimary;
          }
          return gray300;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: lightPrimary,
        inactiveTrackColor: gray300,
        thumbColor: lightPrimary,
        overlayColor: lightPrimary.withValues(alpha: 0.1),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: darkBackground,
      secondary: darkAccent,
      onSecondary: darkBackground,
      surface: darkSurface,
      onSurface: darkText,
      error: errorDark,
      onError: darkBackground,
      outline: darkBorder,
      outlineVariant: darkForest,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      fontFamily: primaryFontFamily,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          inherit: true,
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        toolbarHeight: 56,
      ),

      // Card Theme - Apple Dark Style
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge), // Apple card radius
          side: BorderSide(
            color: darkSeparator,
            width: 0.33, // Apple border width
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme - Apple Dark Style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: darkTextQuaternary,
          disabledForegroundColor: darkTextTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium), // Apple corner radius
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13, // Apple button height ~44pt
          ),
          minimumSize: const Size(44, 44), // Apple minimum tap target
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
          ),
        ),
      ),

      // Input Decoration Theme - Apple Dark Style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: darkSeparatorOpaque,
            width: 0.33,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: darkSeparatorOpaque,
            width: 0.33,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: darkPrimary,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16, // Apple input padding
        ),
        hintStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: darkTextTertiary,
          height: 1.29,
        ),
      ),

      // Apple Typography Scale for Dark Mode
      textTheme: const TextTheme(
        // Large Title - 34pt Regular
        displayLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.37,
          color: darkText,
        ),
        
        // Title 1 - 28pt Regular  
        displayMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          height: 1.29,
          letterSpacing: 0.36,
          color: darkText,
        ),
        
        // Title 2 - 22pt Regular
        headlineMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w400,
          height: 1.27,
          letterSpacing: 0.35,
          color: darkText,
        ),
        
        // Title 3 - 20pt Regular
        headlineSmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.25,
          letterSpacing: 0.38,
          color: darkText,
        ),
        
        // Headline - 17pt Semibold
        titleLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.29,
          letterSpacing: -0.41,
          color: darkText,
        ),
        
        // Body - 17pt Regular
        bodyLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.29,
          letterSpacing: -0.41,
          color: darkText,
        ),
        
        // Callout - 16pt Regular
        titleMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.31,
          letterSpacing: -0.32,
          color: darkText,
        ),
        
        // Subhead - 15pt Regular
        bodyMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: -0.24,
          color: darkTextSecondary,
        ),
        
        // Footnote - 13pt Regular
        bodySmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.38,
          letterSpacing: -0.08,
          color: darkTextSecondary,
        ),
        
        // Caption 1 - 12pt Regular
        labelMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0,
          color: darkTextSecondary,
        ),
        
        // Caption 2 - 11pt Regular
        labelSmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.36,
          letterSpacing: 0.07,
          color: darkTextSecondary,
        ),
      ),

      // Navigation Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: darkBackground,
        width: sidebarWidth,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          return darkBackground;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return darkBorder;
        }),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        elevation: 3,
        shape: CircleBorder(),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Timer-specific text styles
  static TextStyle timerLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      inherit: true,
      fontFamily: monospaceFontFamily,
      fontSize: 48,
      fontWeight: FontWeight.w300,
      color: isDark ? darkText : lightText,
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
      color: isDark ? darkText : lightText,
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
      color: isDark ? darkText : lightText,
      height: 1.33,
    );
  }

  // Active timer styles
  static TextStyle timerActiveStyle(BuildContext context, TextStyle baseStyle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return baseStyle.copyWith(color: isDark ? darkAccent : lightPrimary);
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

  // Helper methods for theme-appropriate colors
  static Color getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkPrimary : lightPrimary;
  }

  static Color getSecondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkAccent : lightAccent;
  }

  static Color getErrorColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? errorDark : errorLight;
  }

  static Color getWarningColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? warningDark : warningLight;
  }

  static Color getSuccessColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? successDark : successLight;
  }

  static Color getAccentColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? focusDark : focusLight;
  }
}