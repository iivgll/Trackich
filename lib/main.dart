import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService.initialize();

  // Initialize system tray for desktop platforms
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    try {
      SystemTrayService.initialize();
      debugPrint('System tray service started for ${Platform.operatingSystem}');
    } catch (e) {
      debugPrint('System tray initialization failed: $e');
      debugPrint('Platform: ${Platform.operatingSystem}');
    }
  }

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

      // Home screen - show onboarding for new users
      home: const AppRouter(),

      // Route configuration for navigation
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const MainScreen());
      },
    );
  }
}
