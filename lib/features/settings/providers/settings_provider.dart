import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/settings.dart';

part 'settings_provider.g.dart';

/// Provider for app settings with persistence
@riverpod
class Settings extends _$Settings {
  static const String _settingsKey = 'app_settings';

  @override
  FutureOr<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      try {
        final settingsMap = Map<String, dynamic>.from(
          // In a real app, you'd use json.decode here
          // For now, return default settings
          <String, dynamic>{},
        );
        return AppSettings.fromJson(settingsMap);
      } catch (e) {
        // If parsing fails, return defaults
        return const AppSettings();
      }
    }
    
    return const AppSettings();
  }

  /// Update settings and persist to storage
  Future<void> updateSettings(AppSettings settings) async {
    state = AsyncValue.data(settings);
    await _saveSettings(settings);
  }

  /// Update language setting
  Future<void> updateLanguage(String language) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(language: language);
    await updateSettings(newSettings);
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(themeMode: themeMode);
    await updateSettings(newSettings);
  }

  /// Update time format
  Future<void> updateTimeFormat(bool use24Hour) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(use24HourFormat: use24Hour);
    await updateSettings(newSettings);
  }

  /// Update week start day
  Future<void> updateWeekStartDay(bool startsOnMonday) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(weekStartsOnMonday: startsOnMonday);
    await updateSettings(newSettings);
  }

  /// Update default project
  Future<void> updateDefaultProject(String? projectId) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(defaultProjectId: projectId);
    await updateSettings(newSettings);
  }

  /// Update work session duration
  Future<void> updateWorkSessionDuration(int minutes) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(workSessionDuration: minutes);
    await updateSettings(newSettings);
  }

  /// Update short break duration
  Future<void> updateShortBreakDuration(int minutes) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(shortBreakDuration: minutes);
    await updateSettings(newSettings);
  }

  /// Update long break duration
  Future<void> updateLongBreakDuration(int minutes) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(longBreakDuration: minutes);
    await updateSettings(newSettings);
  }

  /// Update long break interval
  Future<void> updateLongBreakInterval(int sessions) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(longBreakInterval: sessions);
    await updateSettings(newSettings);
  }

  /// Update break notifications setting
  Future<void> updateBreakNotifications(bool enabled) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(enableBreakNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Update notification sound
  Future<void> updateNotificationSound(String sound) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(notificationSound: sound);
    await updateSettings(newSettings);
  }

  /// Update system notifications
  Future<void> updateSystemNotifications(bool enabled) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(enableSystemNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Update break reminders
  Future<void> updateBreakReminders(bool enabled) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(enableBreakReminders: enabled);
    await updateSettings(newSettings);
  }

  /// Update daily summary
  Future<void> updateDailySummary(bool enabled) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(enableDailySummary: enabled);
    await updateSettings(newSettings);
  }

  /// Update quiet hours
  Future<void> updateQuietHours({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(
      quietHoursStart: startTime ?? currentSettings.quietHoursStart,
      quietHoursEnd: endTime ?? currentSettings.quietHoursEnd,
    );
    await updateSettings(newSettings);
  }

  /// Update daily goal
  Future<void> updateDailyGoal(double hours) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(dailyGoalHours: hours);
    await updateSettings(newSettings);
  }

  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    await updateSettings(const AppSettings());
  }

  /// Clear all settings data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
    state = const AsyncValue.data(AppSettings());
  }

  Future<void> _saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = settings.toJson();
      // In a real app, you'd use json.encode here
      await prefs.setString(_settingsKey, settingsJson.toString());
    } catch (e) {
      // Handle error - maybe show a notification
      debugPrint('Failed to save settings: $e');
    }
  }
}

/// Provider for current theme mode
@riverpod
ThemeMode currentThemeMode(Ref ref) {
  final settings = ref.watch(settingsProvider);
  return settings.when(
    data: (settings) => settings.themeMode,
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
}

/// Provider for current language
@riverpod
String currentLanguage(Ref ref) {
  final settings = ref.watch(settingsProvider);
  return settings.when(
    data: (settings) => settings.language,
    loading: () => 'en',
    error: (_, __) => 'en',
  );
}

/// Provider for break settings
@riverpod
BreakSettings breakSettings(Ref ref) {
  final settings = ref.watch(settingsProvider);
  return settings.when(
    data: (settings) => BreakSettings(
      workSessionDuration: settings.workSessionDuration,
      shortBreakDuration: settings.shortBreakDuration,
      longBreakDuration: settings.longBreakDuration,
      longBreakInterval: settings.longBreakInterval,
      enableBreakNotifications: settings.enableBreakNotifications,
      notificationSound: settings.notificationSound,
    ),
    loading: () => const BreakSettings(
      workSessionDuration: 25,
      shortBreakDuration: 5,
      longBreakDuration: 15,
      longBreakInterval: 4,
      enableBreakNotifications: true,
      notificationSound: 'gentle_bell',
    ),
    error: (_, __) => const BreakSettings(
      workSessionDuration: 25,
      shortBreakDuration: 5,
      longBreakDuration: 15,
      longBreakInterval: 4,
      enableBreakNotifications: true,
      notificationSound: 'gentle_bell',
    ),
  );
}

/// Break settings helper class
class BreakSettings {
  const BreakSettings({
    required this.workSessionDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.longBreakInterval,
    required this.enableBreakNotifications,
    required this.notificationSound,
  });

  final int workSessionDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int longBreakInterval;
  final bool enableBreakNotifications;
  final String notificationSound;
}