// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      language: json['language'] as String? ?? 'en',
      themeMode: json['themeMode'] == null
          ? ThemeMode.system
          : const ThemeModeConverter().fromJson(json['themeMode'] as String),
      breakInterval: json['breakInterval'] == null
          ? const Duration(minutes: 30)
          : const DurationConverter().fromJson(
              (json['breakInterval'] as num).toInt(),
            ),
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableSoundNotifications:
          json['enableSoundNotifications'] as bool? ?? true,
      timeFormat:
          $enumDecodeNullable(_$TimeFormatEnumMap, json['timeFormat']) ??
          TimeFormat.format24h,
      weekStartDay:
          $enumDecodeNullable(_$WeekStartDayEnumMap, json['weekStartDay']) ??
          WeekStartDay.monday,
      workingHours:
          (json['workingHours'] as List<dynamic>?)
              ?.map((e) => WorkingHours.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyWorkLimit: json['dailyWorkLimit'] == null
          ? const Duration(hours: 8)
          : const DurationConverter().fromJson(
              (json['dailyWorkLimit'] as num).toInt(),
            ),
      enableBreakReminders: json['enableBreakReminders'] as bool? ?? true,
      enableHealthTips: json['enableHealthTips'] as bool? ?? true,
      enablePostureReminders: json['enablePostureReminders'] as bool? ?? false,
      postureReminderInterval: json['postureReminderInterval'] == null
          ? const Duration(minutes: 30)
          : const DurationConverter().fromJson(
              (json['postureReminderInterval'] as num).toInt(),
            ),
    );

Map<String, dynamic> _$$AppSettingsImplToJson(
  _$AppSettingsImpl instance,
) => <String, dynamic>{
  'language': instance.language,
  'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
  'breakInterval': const DurationConverter().toJson(instance.breakInterval),
  'enableNotifications': instance.enableNotifications,
  'enableSoundNotifications': instance.enableSoundNotifications,
  'timeFormat': _$TimeFormatEnumMap[instance.timeFormat]!,
  'weekStartDay': _$WeekStartDayEnumMap[instance.weekStartDay]!,
  'workingHours': instance.workingHours,
  'dailyWorkLimit': const DurationConverter().toJson(instance.dailyWorkLimit),
  'enableBreakReminders': instance.enableBreakReminders,
  'enableHealthTips': instance.enableHealthTips,
  'enablePostureReminders': instance.enablePostureReminders,
  'postureReminderInterval': const DurationConverter().toJson(
    instance.postureReminderInterval,
  ),
};

const _$TimeFormatEnumMap = {
  TimeFormat.format12h: '12h',
  TimeFormat.format24h: '24h',
};

const _$WeekStartDayEnumMap = {
  WeekStartDay.monday: 'monday',
  WeekStartDay.sunday: 'sunday',
};

_$WorkingHoursImpl _$$WorkingHoursImplFromJson(Map<String, dynamic> json) =>
    _$WorkingHoursImpl(
      day: $enumDecode(_$WeekDayEnumMap, json['day']),
      startTime: const TimeOfDayConverter().fromJson(
        json['startTime'] as Map<String, dynamic>,
      ),
      endTime: const TimeOfDayConverter().fromJson(
        json['endTime'] as Map<String, dynamic>,
      ),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$WorkingHoursImplToJson(_$WorkingHoursImpl instance) =>
    <String, dynamic>{
      'day': _$WeekDayEnumMap[instance.day]!,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'endTime': const TimeOfDayConverter().toJson(instance.endTime),
      'isEnabled': instance.isEnabled,
    };

const _$WeekDayEnumMap = {
  WeekDay.monday: 'monday',
  WeekDay.tuesday: 'tuesday',
  WeekDay.wednesday: 'wednesday',
  WeekDay.thursday: 'thursday',
  WeekDay.friday: 'friday',
  WeekDay.saturday: 'saturday',
  WeekDay.sunday: 'sunday',
};
