import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/notifications/notification_service.dart';
import '../../features/settings/providers/settings_provider.dart';
import '../screens/main_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _enableNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notificationService = ref.read(notificationServiceProvider);
      final granted = await notificationService.requestPermissions();

      if (granted) {
        // Save that onboarding is complete
        ref.read(onboardingCompletedProvider.notifier).setCompleted(true);

        // Navigate to main screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).notificationPermissionDenied,
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to request notification permissions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorOccurred),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _skipOnboarding() {
    // Save that onboarding is complete
    ref.read(onboardingCompletedProvider.notifier).setCompleted(true);

    // Navigate to main screen
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space8),
          child: Column(
            children: [
              // Skip button in top right
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(l10n.skip),
                ),
              ),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Notification icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        Symbols.notifications,
                        size: 60,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),

                    const SizedBox(height: AppTheme.space8),

                    // Title
                    Text(
                      l10n.notificationPermissionTitle,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.space6),

                    // Description
                    Text(
                      l10n.notificationPermissionBody,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.space10),

                    // Enable button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _enableNotifications,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(l10n.enableNotifications),
                      ),
                    ),

                    const SizedBox(height: AppTheme.space4),

                    // Skip button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _skipOnboarding,
                        child: Text(l10n.skip),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
