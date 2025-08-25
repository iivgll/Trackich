import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:window_manager/window_manager.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'l10n/generated/app_localizations.dart';
import 'features/system_tray/system_tray_service.dart';
import 'features/notifications/notification_service.dart';
import 'features/notifications/providers/notification_permission_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Desktop-specific initialization
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    // Initialize window manager for desktop platforms to avoid black screen
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800),
      center: true,
      backgroundColor: Colors.transparent,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    // Initialize system tray
    try {
      SystemTrayService.initialize();
      debugPrint('System tray service started for ${Platform.operatingSystem}');
    } catch (e) {
      debugPrint('System tray initialization failed: $e');
      debugPrint('Platform: ${Platform.operatingSystem}');
    }
  } else {
    // Mobile platforms - preserve native splash screen
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  // Initialize notifications
  await NotificationService.initialize();

  runApp(
    const ProviderScope(child: _EagerInitialization(child: TrackichApp())),
  );
}

/// Eager initialization widget to properly initialize providers that need early setup
class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the notification permission provider by watching it
    // This ensures it's created and ready to use throughout the app
    ref.watch(notificationPermissionProvider);

    // Trigger initial permission check after the provider is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationPermissionProvider.notifier)
          .refreshPermissionStatus();
    });

    return child;
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  _initializeApp() async {
    // Wait for a minimum splash duration for better UX
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Remove native splash screen on mobile platforms
      if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) {
        FlutterNativeSplash.remove();
      }

      // Navigate to main app
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AppRouter(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkSurface : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/logo_500x500.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            // App Name
            Text(
              'Trackich',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            // Tagline
            Text(
              'Personal Time Tracking',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleted = ref.watch(onboardingCompletedProvider);

    return onboardingCompleted ? const MainScreen() : const OnboardingScreen();
  }
}

class TrackichApp extends ConsumerWidget {
  const TrackichApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp(
      title: AppConstants.appName,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localization Configuration
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Russian
      ],
      locale: Locale(language),

      // Remove debug banner
      debugShowCheckedModeBanner: false,

      // Home screen - show splash screen first
      home: const SplashScreen(),

      // Route configuration for navigation
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const MainScreen());
      },
    );
  }
}
