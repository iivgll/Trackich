import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Ref, StateNotifier, StateNotifierProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/settings.dart';
import '../../../../core/services/storage_service.dart';

part 'settings_provider.g.dart';

/// Provider for app settings
@riverpod
class Settings extends _$Settings {
  @override
  Future<AppSettings> build() async {
    final storage = ref.read(storageServiceProvider);
    return await storage.getSettings();
  }

  /// Update settings
  Future<void> updateSettings(AppSettings settings) async {
    state = const AsyncValue.loading();
    try {
      final storage = ref.read(storageServiceProvider);
      await storage.saveSettings(settings);
      state = AsyncValue.data(settings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(language: language));
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(themeMode: themeMode));
  }

  /// Update break interval
  Future<void> updateBreakInterval(Duration breakInterval) async {
    final currentSettings = await future;
    await updateSettings(
      currentSettings.copyWith(breakInterval: breakInterval),
    );
  }

  /// Update notification settings
  Future<void> updateNotificationSettings({
    bool? enableNotifications,
    bool? enableSoundNotifications,
    bool? enableBreakReminders,
    bool? enableHealthTips,
    bool? enablePostureReminders,
    Duration? postureReminderInterval,
  }) async {
    final currentSettings = await future;
    await updateSettings(
      currentSettings.copyWith(
        enableNotifications:
            enableNotifications ?? currentSettings.enableNotifications,
        enableSoundNotifications:
            enableSoundNotifications ??
            currentSettings.enableSoundNotifications,
        enableBreakReminders:
            enableBreakReminders ?? currentSettings.enableBreakReminders,
        enableHealthTips: enableHealthTips ?? currentSettings.enableHealthTips,
        enablePostureReminders:
            enablePostureReminders ?? currentSettings.enablePostureReminders,
        postureReminderInterval:
            postureReminderInterval ?? currentSettings.postureReminderInterval,
      ),
    );
  }

  /// Update time format
  Future<void> updateTimeFormat(TimeFormat timeFormat) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(timeFormat: timeFormat));
  }

  /// Update week start day
  Future<void> updateWeekStartDay(WeekStartDay weekStartDay) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(weekStartDay: weekStartDay));
  }

  /// Update working hours
  Future<void> updateWorkingHours(List<WorkingHours> workingHours) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(workingHours: workingHours));
  }

  /// Update daily work limit
  Future<void> updateDailyWorkLimit(Duration dailyWorkLimit) async {
    final currentSettings = await future;
    await updateSettings(
      currentSettings.copyWith(dailyWorkLimit: dailyWorkLimit),
    );
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    await updateSettings(const AppSettings());
  }
}

/// Provider for watching specific setting values
@riverpod
ThemeMode themeMode(Ref ref) {
  return ref
      .watch(settingsProvider)
      .when(
        data: (settings) => settings.themeMode,
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      );
}

@riverpod
String language(Ref ref) {
  return ref
      .watch(settingsProvider)
      .when(
        data: (settings) => settings.language,
        loading: () => 'en',
        error: (_, __) => 'en',
      );
}

@riverpod
bool notificationsEnabled(Ref ref) {
  return ref
      .watch(settingsProvider)
      .when(
        data: (settings) => settings.enableNotifications,
        loading: () => true,
        error: (_, __) => true,
      );
}

@riverpod
TimeFormat timeFormat(Ref ref) {
  return ref
      .watch(settingsProvider)
      .when(
        data: (settings) => settings.timeFormat,
        loading: () => TimeFormat.format24h,
        error: (_, __) => TimeFormat.format24h,
      );
}

@riverpod
WeekStartDay weekStartDay(Ref ref) {
  return ref
      .watch(settingsProvider)
      .when(
        data: (settings) => settings.weekStartDay,
        loading: () => WeekStartDay.monday,
        error: (_, __) => WeekStartDay.monday,
      );
}

final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingCompletedNotifier, bool>((ref) {
      return OnboardingCompletedNotifier(ref);
    });

class OnboardingCompletedNotifier extends StateNotifier<bool> {
  final Ref ref;

  OnboardingCompletedNotifier(this.ref) : super(false) {
    _loadOnboardingStatus();
  }

  void _loadOnboardingStatus() {
    try {
      final storage = ref.read(storageServiceProvider);
      storage.init().then((_) {
        state = storage.prefs.getBool('onboarding_completed') ?? false;
      });
    } catch (e) {
      debugPrint('Failed to get onboarding status: $e');
      state = false;
    }
  }

  Future<void> setCompleted(bool completed) async {
    try {
      final storage = ref.read(storageServiceProvider);
      await storage.init();
      await storage.prefs.setBool('onboarding_completed', completed);
      state = completed;
    } catch (e) {
      debugPrint('Failed to set onboarding status: $e');
    }
  }
}
