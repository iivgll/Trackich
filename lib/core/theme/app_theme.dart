import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme system based on the UI/UX design specification
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color palette from UI/UX specification
  static const _primaryBlue50 = Color(0xFFEFF6FF);
  static const _primaryBlue100 = Color(0xFFDBEAFE);
  static const _primaryBlue500 = Color(0xFF3B82F6);
  static const _primaryBlue600 = Color(0xFF2563EB);
  static const _primaryBlue700 = Color(0xFF1D4ED8);
  static const _primaryBlue900 = Color(0xFF1E3A8A);

  // Gray palette
  static const _gray50 = Color(0xFFF9FAFB);
  static const _gray100 = Color(0xFFF3F4F6);
  static const _gray200 = Color(0xFFE5E7EB);
  static const _gray400 = Color(0xFF9CA3AF);
  static const _gray600 = Color(0xFF4B5563);
  static const _gray700 = Color(0xFF374151);
  static const _gray900 = Color(0xFF111827);

  // Accent colors
  static const _green500 = Color(0xFF10B981);
  static const _green100 = Color(0xFFD1FAE5);
  static const _amber500 = Color(0xFFF59E0B);
  static const _amber100 = Color(0xFFFEF3C7);
  static const _red500 = Color(0xFFEF4444);
  static const _red100 = Color(0xFFFEE2E2);

  // Project colors
  static const List<Color> projectColors = [
    _primaryBlue500,
    _green500,
    Color(0xFF8B5CF6), // purple
    Color(0xFFEC4899), // pink
    Color(0xFFF97316), // orange
    Color(0xFF14B8A6), // teal
    Color(0xFF6366F1), // indigo
    Color(0xFFEAB308), // yellow
  ];

  // Dark theme colors
  static const _darkBgPrimary = Color(0xFF0F172A);
  static const _darkBgSecondary = Color(0xFF1E293B);
  static const _darkBgTertiary = Color(0xFF334155);
  static const _darkTextPrimary = Color(0xFFF1F5F9);
  static const _darkTextSecondary = Color(0xFF94A3B8);
  static const _darkBorder = Color(0xFF475569);

  /// Light theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: _primaryBlue600,
      primaryContainer: _primaryBlue100,
      secondary: _green500,
      secondaryContainer: _green100,
      surface: Colors.white,
      surfaceContainerHighest: _gray50,
      surfaceContainerHigh: _gray100,
      surfaceContainer: _gray100,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _gray900,
      onSurfaceVariant: _gray700,
      outline: _gray200,
      outlineVariant: _gray100,
      error: _red500,
      errorContainer: _red100,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      switchTheme: _buildSwitchTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
      radioTheme: _buildRadioTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(colorScheme),
      extensions: [
        _AppColorsExtension.light(),
      ],
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: _primaryBlue500,
      primaryContainer: _primaryBlue900,
      secondary: Color(0xFF22C55E),
      secondaryContainer: Color(0xFF166534),
      surface: _darkBgSecondary,
      surfaceContainerHighest: _darkBgTertiary,
      surfaceContainerHigh: _darkBgSecondary,
      surfaceContainer: _darkBgPrimary,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _darkTextPrimary,
      onSurfaceVariant: _darkTextSecondary,
      outline: _darkBorder,
      outlineVariant: Color(0xFF334155),
      error: _red500,
      errorContainer: Color(0xFF7F1D1D),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      switchTheme: _buildSwitchTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
      radioTheme: _buildRadioTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(colorScheme),
      extensions: [
        _AppColorsExtension.dark(),
      ],
    );
  }

  // Typography system based on UI/UX specification
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return baseTextTheme.copyWith(
      // Page titles
      displayLarge: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
      // Section headers
      displayMedium: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        height: 1.3,
      ),
      // Card titles
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        height: 1.3,
      ),
      // Subheadings
      headlineLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      // Large body text
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      // Primary body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        height: 1.5,
      ),
      // Secondary text, labels
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      // Captions, metadata
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
        height: 1.3,
      ),
      // Button text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        height: 1.2,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
    );
  }

  static DividerThemeData _buildDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: 1,
    );
  }

  static ChipThemeData _buildChipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      selectedColor: colorScheme.primaryContainer,
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
    );
  }

  static SwitchThemeData _buildSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerHigh;
      }),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surface;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  static RadioThemeData _buildRadioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.outline;
      }),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      elevation: 1,
      height: 56,
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.primary);
        }
        return IconThemeData(color: colorScheme.onSurfaceVariant);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      elevation: 8,
    );
  }

  static DialogThemeData _buildDialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static FloatingActionButtonThemeData _buildFloatingActionButtonTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

/// Extension for custom colors not covered by Material Design
@immutable
class _AppColorsExtension extends ThemeExtension<_AppColorsExtension> {
  const _AppColorsExtension({
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarning,
    required this.onWarningContainer,
    required this.timerActive,
    required this.timerPaused,
    required this.projectColors,
  });

  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color onWarningContainer;
  final Color timerActive;
  final Color timerPaused;
  final List<Color> projectColors;

  factory _AppColorsExtension.light() {
    return const _AppColorsExtension(
      success: Color(0xFF10B981), // _green500
      successContainer: Color(0xFFD1FAE5), // _green100
      onSuccess: Colors.white,
      onSuccessContainer: Color(0xFF064E3B),
      warning: Color(0xFFF59E0B), // _amber500
      warningContainer: Color(0xFFFEF3C7), // _amber100
      onWarning: Colors.white,
      onWarningContainer: Color(0xFF92400E),
      timerActive: Color(0xFF10B981), // _green500
      timerPaused: Color(0xFFF59E0B), // _amber500
      projectColors: AppTheme.projectColors,
    );
  }

  factory _AppColorsExtension.dark() {
    return const _AppColorsExtension(
      success: Color(0xFF22C55E),
      successContainer: Color(0xFF166534),
      onSuccess: Colors.white,
      onSuccessContainer: Color(0xFFDCFCE7),
      warning: Color(0xFFFBBF24),
      warningContainer: Color(0xFF92400E),
      onWarning: Colors.black,
      onWarningContainer: Color(0xFFFEF3C7),
      timerActive: Color(0xFF22C55E),
      timerPaused: Color(0xFFFBBF24),
      projectColors: AppTheme.projectColors,
    );
  }

  @override
  ThemeExtension<_AppColorsExtension> copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccess,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarning,
    Color? onWarningContainer,
    Color? timerActive,
    Color? timerPaused,
    List<Color>? projectColors,
  }) {
    return _AppColorsExtension(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccess: onSuccess ?? this.onSuccess,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarning: onWarning ?? this.onWarning,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      timerActive: timerActive ?? this.timerActive,
      timerPaused: timerPaused ?? this.timerPaused,
      projectColors: projectColors ?? this.projectColors,
    );
  }

  @override
  ThemeExtension<_AppColorsExtension> lerp(
    covariant ThemeExtension<_AppColorsExtension>? other,
    double t,
  ) {
    if (other is! _AppColorsExtension) {
      return this;
    }

    return _AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      timerActive: Color.lerp(timerActive, other.timerActive, t)!,
      timerPaused: Color.lerp(timerPaused, other.timerPaused, t)!,
      projectColors: projectColors, // Can't lerp lists
    );
  }
}

/// Extension to access custom colors from BuildContext
extension AppColorsExtension on BuildContext {
  _AppColorsExtension get appColors =>
      Theme.of(this).extension<_AppColorsExtension>()!;
}