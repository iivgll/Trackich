// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  language: json['language'] as String? ?? 'en',
  themeMode: json['themeMode'] == null
      ? ThemeMode.system
      : const ThemeModeConverter().fromJson(json['themeMode'] as String),
  use24HourFormat: json['use24HourFormat'] as bool? ?? true,
  weekStartsOnMonday: json['weekStartsOnMonday'] as bool? ?? true,
  defaultProjectId: json['defaultProjectId'] as String?,
  workSessionDuration: (json['workSessionDuration'] as num?)?.toInt() ?? 25,
  shortBreakDuration: (json['shortBreakDuration'] as num?)?.toInt() ?? 5,
  longBreakDuration: (json['longBreakDuration'] as num?)?.toInt() ?? 15,
  longBreakInterval: (json['longBreakInterval'] as num?)?.toInt() ?? 4,
  enableBreakNotifications: json['enableBreakNotifications'] as bool? ?? true,
  notificationSound: json['notificationSound'] as String? ?? 'gentle_bell',
  enableSystemNotifications: json['enableSystemNotifications'] as bool? ?? true,
  enableBreakReminders: json['enableBreakReminders'] as bool? ?? true,
  enableDailySummary: json['enableDailySummary'] as bool? ?? true,
  quietHoursStart: json['quietHoursStart'] == null
      ? const TimeOfDay(hour: 22, minute: 0)
      : const TimeOfDayConverter().fromJson(
          json['quietHoursStart'] as Map<String, int>,
        ),
  quietHoursEnd: json['quietHoursEnd'] == null
      ? const TimeOfDay(hour: 8, minute: 0)
      : const TimeOfDayConverter().fromJson(
          json['quietHoursEnd'] as Map<String, int>,
        ),
  dailyGoalHours: (json['dailyGoalHours'] as num?)?.toDouble() ?? 8.0,
);

Map<String, dynamic> _$AppSettingsToJson(
  AppSettings instance,
) => <String, dynamic>{
  'language': instance.language,
  'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
  'use24HourFormat': instance.use24HourFormat,
  'weekStartsOnMonday': instance.weekStartsOnMonday,
  'defaultProjectId': instance.defaultProjectId,
  'workSessionDuration': instance.workSessionDuration,
  'shortBreakDuration': instance.shortBreakDuration,
  'longBreakDuration': instance.longBreakDuration,
  'longBreakInterval': instance.longBreakInterval,
  'enableBreakNotifications': instance.enableBreakNotifications,
  'notificationSound': instance.notificationSound,
  'enableSystemNotifications': instance.enableSystemNotifications,
  'enableBreakReminders': instance.enableBreakReminders,
  'enableDailySummary': instance.enableDailySummary,
  'quietHoursStart': const TimeOfDayConverter().toJson(
    instance.quietHoursStart,
  ),
  'quietHoursEnd': const TimeOfDayConverter().toJson(instance.quietHoursEnd),
  'dailyGoalHours': instance.dailyGoalHours,
};
