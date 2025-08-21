import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  const AppSettings({
    this.language = 'en',
    this.themeMode = ThemeMode.system,
    this.use24HourFormat = true,
    this.weekStartsOnMonday = true,
    this.defaultProjectId,
    this.workSessionDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakInterval = 4,
    this.enableBreakNotifications = true,
    this.notificationSound = 'gentle_bell',
    this.enableSystemNotifications = true,
    this.enableBreakReminders = true,
    this.enableDailySummary = true,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 8, minute: 0),
    this.dailyGoalHours = 8.0,
  });

  /// User interface language (ISO 639-1 code)
  final String language;
  
  /// Theme mode preference
  @ThemeModeConverter()
  final ThemeMode themeMode;
  
  /// Use 24-hour time format
  final bool use24HourFormat;
  
  /// Week starts on Monday (true) or Sunday (false)
  final bool weekStartsOnMonday;
  
  /// Default project for new tasks
  final String? defaultProjectId;
  
  /// Work session duration in minutes (Pomodoro technique)
  final int workSessionDuration;
  
  /// Short break duration in minutes
  final int shortBreakDuration;
  
  /// Long break duration in minutes
  final int longBreakDuration;
  
  /// Number of work sessions before a long break
  final int longBreakInterval;
  
  /// Enable break notifications
  final bool enableBreakNotifications;
  
  /// Notification sound identifier
  final String notificationSound;
  
  /// Enable system notifications
  final bool enableSystemNotifications;
  
  /// Enable break reminders
  final bool enableBreakReminders;
  
  /// Enable daily summary notifications
  final bool enableDailySummary;
  
  /// Quiet hours start time
  @TimeOfDayConverter()
  final TimeOfDay quietHoursStart;
  
  /// Quiet hours end time
  @TimeOfDayConverter()
  final TimeOfDay quietHoursEnd;
  
  /// Daily work goal in hours
  final double dailyGoalHours;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  AppSettings copyWith({
    String? language,
    ThemeMode? themeMode,
    bool? use24HourFormat,
    bool? weekStartsOnMonday,
    String? defaultProjectId,
    int? workSessionDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? longBreakInterval,
    bool? enableBreakNotifications,
    String? notificationSound,
    bool? enableSystemNotifications,
    bool? enableBreakReminders,
    bool? enableDailySummary,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
    double? dailyGoalHours,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      weekStartsOnMonday: weekStartsOnMonday ?? this.weekStartsOnMonday,
      defaultProjectId: defaultProjectId ?? this.defaultProjectId,
      workSessionDuration: workSessionDuration ?? this.workSessionDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      enableBreakNotifications: enableBreakNotifications ?? this.enableBreakNotifications,
      notificationSound: notificationSound ?? this.notificationSound,
      enableSystemNotifications: enableSystemNotifications ?? this.enableSystemNotifications,
      enableBreakReminders: enableBreakReminders ?? this.enableBreakReminders,
      enableDailySummary: enableDailySummary ?? this.enableDailySummary,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      dailyGoalHours: dailyGoalHours ?? this.dailyGoalHours,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          themeMode == other.themeMode &&
          use24HourFormat == other.use24HourFormat &&
          weekStartsOnMonday == other.weekStartsOnMonday &&
          defaultProjectId == other.defaultProjectId &&
          workSessionDuration == other.workSessionDuration &&
          shortBreakDuration == other.shortBreakDuration &&
          longBreakDuration == other.longBreakDuration &&
          longBreakInterval == other.longBreakInterval &&
          enableBreakNotifications == other.enableBreakNotifications &&
          notificationSound == other.notificationSound &&
          enableSystemNotifications == other.enableSystemNotifications &&
          enableBreakReminders == other.enableBreakReminders &&
          enableDailySummary == other.enableDailySummary &&
          quietHoursStart == other.quietHoursStart &&
          quietHoursEnd == other.quietHoursEnd &&
          dailyGoalHours == other.dailyGoalHours;

  @override
  int get hashCode => Object.hash(
        language,
        themeMode,
        use24HourFormat,
        weekStartsOnMonday,
        defaultProjectId,
        workSessionDuration,
        shortBreakDuration,
        longBreakDuration,
        longBreakInterval,
        enableBreakNotifications,
        notificationSound,
        enableSystemNotifications,
        enableBreakReminders,
        enableDailySummary,
        quietHoursStart,
        quietHoursEnd,
        dailyGoalHours,
      );

  @override
  String toString() {
    return 'AppSettings{language: $language, themeMode: $themeMode, '
        'use24HourFormat: $use24HourFormat, weekStartsOnMonday: $weekStartsOnMonday, '
        'defaultProjectId: $defaultProjectId, workSessionDuration: $workSessionDuration, '
        'shortBreakDuration: $shortBreakDuration, longBreakDuration: $longBreakDuration, '
        'longBreakInterval: $longBreakInterval, enableBreakNotifications: $enableBreakNotifications, '
        'notificationSound: $notificationSound, enableSystemNotifications: $enableSystemNotifications, '
        'enableBreakReminders: $enableBreakReminders, enableDailySummary: $enableDailySummary, '
        'quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, '
        'dailyGoalHours: $dailyGoalHours}';
  }
}

/// JSON converter for ThemeMode
class ThemeModeConverter implements JsonConverter<ThemeMode, String> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(String json) {
    switch (json) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  String toJson(ThemeMode object) {
    switch (object) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

/// JSON converter for TimeOfDay
class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, int>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, int> json) {
    return TimeOfDay(hour: json['hour']!, minute: json['minute']!);
  }

  @override
  Map<String, int> toJson(TimeOfDay object) {
    return {'hour': object.hour, 'minute': object.minute};
  }
}