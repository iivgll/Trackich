import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('en') String language,
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,
    @DurationConverter() @Default(Duration(minutes: 25)) Duration shortBreakInterval,
    @DurationConverter() @Default(Duration(hours: 2)) Duration longBreakInterval,
    @DurationConverter() @Default(Duration(minutes: 5)) Duration shortBreakDuration,
    @DurationConverter() @Default(Duration(minutes: 15)) Duration longBreakDuration,
    @Default(true) bool enableNotifications,
    @Default(true) bool enableSoundNotifications,
    @Default(TimeFormat.format24h) TimeFormat timeFormat,
    @Default(WeekStartDay.monday) WeekStartDay weekStartDay,
    @Default([]) List<WorkingHours> workingHours,
    @DurationConverter() @Default(Duration(hours: 8)) Duration dailyWorkLimit,
    @Default(true) bool enableBreakReminders,
    @Default(true) bool enableHealthTips,
    @Default(false) bool enablePostureReminders,
    @DurationConverter() @Default(Duration(minutes: 30)) Duration postureReminderInterval,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}

@freezed
class WorkingHours with _$WorkingHours {
  const factory WorkingHours({
    required WeekDay day,
    @TimeOfDayConverter() required TimeOfDay startTime,
    @TimeOfDayConverter() required TimeOfDay endTime,
    @Default(true) bool isEnabled,
  }) = _WorkingHours;

  factory WorkingHours.fromJson(Map<String, dynamic> json) => _$WorkingHoursFromJson(json);
}

enum TimeFormat {
  @JsonValue('12h')
  format12h,
  @JsonValue('24h')
  format24h,
}

enum WeekStartDay {
  @JsonValue('monday')
  monday,
  @JsonValue('sunday')
  sunday,
}

enum WeekDay {
  @JsonValue('monday')
  monday,
  @JsonValue('tuesday')
  tuesday,
  @JsonValue('wednesday')
  wednesday,
  @JsonValue('thursday')
  thursday,
  @JsonValue('friday')
  friday,
  @JsonValue('saturday')
  saturday,
  @JsonValue('sunday')
  sunday,
}

// Custom converters for serialization
class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int json) => Duration(milliseconds: json);

  @override
  int toJson(Duration duration) => duration.inMilliseconds;
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay timeOfDay) {
    return {'hour': timeOfDay.hour, 'minute': timeOfDay.minute};
  }
}

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
  String toJson(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}