// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  String get language => throw _privateConstructorUsedError;
  @ThemeModeConverter()
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get shortBreakInterval => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get longBreakInterval => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get shortBreakDuration => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get longBreakDuration => throw _privateConstructorUsedError;
  bool get enableNotifications => throw _privateConstructorUsedError;
  bool get enableSoundNotifications => throw _privateConstructorUsedError;
  TimeFormat get timeFormat => throw _privateConstructorUsedError;
  WeekStartDay get weekStartDay => throw _privateConstructorUsedError;
  List<WorkingHours> get workingHours => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get dailyWorkLimit => throw _privateConstructorUsedError;
  bool get enableBreakReminders => throw _privateConstructorUsedError;
  bool get enableHealthTips => throw _privateConstructorUsedError;
  bool get enablePostureReminders => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get postureReminderInterval => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    String language,
    @ThemeModeConverter() ThemeMode themeMode,
    @DurationConverter() Duration shortBreakInterval,
    @DurationConverter() Duration longBreakInterval,
    @DurationConverter() Duration shortBreakDuration,
    @DurationConverter() Duration longBreakDuration,
    bool enableNotifications,
    bool enableSoundNotifications,
    TimeFormat timeFormat,
    WeekStartDay weekStartDay,
    List<WorkingHours> workingHours,
    @DurationConverter() Duration dailyWorkLimit,
    bool enableBreakReminders,
    bool enableHealthTips,
    bool enablePostureReminders,
    @DurationConverter() Duration postureReminderInterval,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? themeMode = null,
    Object? shortBreakInterval = null,
    Object? longBreakInterval = null,
    Object? shortBreakDuration = null,
    Object? longBreakDuration = null,
    Object? enableNotifications = null,
    Object? enableSoundNotifications = null,
    Object? timeFormat = null,
    Object? weekStartDay = null,
    Object? workingHours = null,
    Object? dailyWorkLimit = null,
    Object? enableBreakReminders = null,
    Object? enableHealthTips = null,
    Object? enablePostureReminders = null,
    Object? postureReminderInterval = null,
  }) {
    return _then(
      _value.copyWith(
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String,
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            shortBreakInterval: null == shortBreakInterval
                ? _value.shortBreakInterval
                : shortBreakInterval // ignore: cast_nullable_to_non_nullable
                      as Duration,
            longBreakInterval: null == longBreakInterval
                ? _value.longBreakInterval
                : longBreakInterval // ignore: cast_nullable_to_non_nullable
                      as Duration,
            shortBreakDuration: null == shortBreakDuration
                ? _value.shortBreakDuration
                : shortBreakDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            longBreakDuration: null == longBreakDuration
                ? _value.longBreakDuration
                : longBreakDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            enableNotifications: null == enableNotifications
                ? _value.enableNotifications
                : enableNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableSoundNotifications: null == enableSoundNotifications
                ? _value.enableSoundNotifications
                : enableSoundNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            timeFormat: null == timeFormat
                ? _value.timeFormat
                : timeFormat // ignore: cast_nullable_to_non_nullable
                      as TimeFormat,
            weekStartDay: null == weekStartDay
                ? _value.weekStartDay
                : weekStartDay // ignore: cast_nullable_to_non_nullable
                      as WeekStartDay,
            workingHours: null == workingHours
                ? _value.workingHours
                : workingHours // ignore: cast_nullable_to_non_nullable
                      as List<WorkingHours>,
            dailyWorkLimit: null == dailyWorkLimit
                ? _value.dailyWorkLimit
                : dailyWorkLimit // ignore: cast_nullable_to_non_nullable
                      as Duration,
            enableBreakReminders: null == enableBreakReminders
                ? _value.enableBreakReminders
                : enableBreakReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableHealthTips: null == enableHealthTips
                ? _value.enableHealthTips
                : enableHealthTips // ignore: cast_nullable_to_non_nullable
                      as bool,
            enablePostureReminders: null == enablePostureReminders
                ? _value.enablePostureReminders
                : enablePostureReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            postureReminderInterval: null == postureReminderInterval
                ? _value.postureReminderInterval
                : postureReminderInterval // ignore: cast_nullable_to_non_nullable
                      as Duration,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String language,
    @ThemeModeConverter() ThemeMode themeMode,
    @DurationConverter() Duration shortBreakInterval,
    @DurationConverter() Duration longBreakInterval,
    @DurationConverter() Duration shortBreakDuration,
    @DurationConverter() Duration longBreakDuration,
    bool enableNotifications,
    bool enableSoundNotifications,
    TimeFormat timeFormat,
    WeekStartDay weekStartDay,
    List<WorkingHours> workingHours,
    @DurationConverter() Duration dailyWorkLimit,
    bool enableBreakReminders,
    bool enableHealthTips,
    bool enablePostureReminders,
    @DurationConverter() Duration postureReminderInterval,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? themeMode = null,
    Object? shortBreakInterval = null,
    Object? longBreakInterval = null,
    Object? shortBreakDuration = null,
    Object? longBreakDuration = null,
    Object? enableNotifications = null,
    Object? enableSoundNotifications = null,
    Object? timeFormat = null,
    Object? weekStartDay = null,
    Object? workingHours = null,
    Object? dailyWorkLimit = null,
    Object? enableBreakReminders = null,
    Object? enableHealthTips = null,
    Object? enablePostureReminders = null,
    Object? postureReminderInterval = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String,
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        shortBreakInterval: null == shortBreakInterval
            ? _value.shortBreakInterval
            : shortBreakInterval // ignore: cast_nullable_to_non_nullable
                  as Duration,
        longBreakInterval: null == longBreakInterval
            ? _value.longBreakInterval
            : longBreakInterval // ignore: cast_nullable_to_non_nullable
                  as Duration,
        shortBreakDuration: null == shortBreakDuration
            ? _value.shortBreakDuration
            : shortBreakDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        longBreakDuration: null == longBreakDuration
            ? _value.longBreakDuration
            : longBreakDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        enableNotifications: null == enableNotifications
            ? _value.enableNotifications
            : enableNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableSoundNotifications: null == enableSoundNotifications
            ? _value.enableSoundNotifications
            : enableSoundNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        timeFormat: null == timeFormat
            ? _value.timeFormat
            : timeFormat // ignore: cast_nullable_to_non_nullable
                  as TimeFormat,
        weekStartDay: null == weekStartDay
            ? _value.weekStartDay
            : weekStartDay // ignore: cast_nullable_to_non_nullable
                  as WeekStartDay,
        workingHours: null == workingHours
            ? _value._workingHours
            : workingHours // ignore: cast_nullable_to_non_nullable
                  as List<WorkingHours>,
        dailyWorkLimit: null == dailyWorkLimit
            ? _value.dailyWorkLimit
            : dailyWorkLimit // ignore: cast_nullable_to_non_nullable
                  as Duration,
        enableBreakReminders: null == enableBreakReminders
            ? _value.enableBreakReminders
            : enableBreakReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableHealthTips: null == enableHealthTips
            ? _value.enableHealthTips
            : enableHealthTips // ignore: cast_nullable_to_non_nullable
                  as bool,
        enablePostureReminders: null == enablePostureReminders
            ? _value.enablePostureReminders
            : enablePostureReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        postureReminderInterval: null == postureReminderInterval
            ? _value.postureReminderInterval
            : postureReminderInterval // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.language = 'en',
    @ThemeModeConverter() this.themeMode = ThemeMode.system,
    @DurationConverter() this.shortBreakInterval = const Duration(minutes: 25),
    @DurationConverter() this.longBreakInterval = const Duration(hours: 2),
    @DurationConverter() this.shortBreakDuration = const Duration(minutes: 5),
    @DurationConverter() this.longBreakDuration = const Duration(minutes: 15),
    this.enableNotifications = true,
    this.enableSoundNotifications = true,
    this.timeFormat = TimeFormat.format24h,
    this.weekStartDay = WeekStartDay.monday,
    final List<WorkingHours> workingHours = const [],
    @DurationConverter() this.dailyWorkLimit = const Duration(hours: 8),
    this.enableBreakReminders = true,
    this.enableHealthTips = true,
    this.enablePostureReminders = false,
    @DurationConverter()
    this.postureReminderInterval = const Duration(minutes: 30),
  }) : _workingHours = workingHours;

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  @ThemeModeConverter()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  @DurationConverter()
  final Duration shortBreakInterval;
  @override
  @JsonKey()
  @DurationConverter()
  final Duration longBreakInterval;
  @override
  @JsonKey()
  @DurationConverter()
  final Duration shortBreakDuration;
  @override
  @JsonKey()
  @DurationConverter()
  final Duration longBreakDuration;
  @override
  @JsonKey()
  final bool enableNotifications;
  @override
  @JsonKey()
  final bool enableSoundNotifications;
  @override
  @JsonKey()
  final TimeFormat timeFormat;
  @override
  @JsonKey()
  final WeekStartDay weekStartDay;
  final List<WorkingHours> _workingHours;
  @override
  @JsonKey()
  List<WorkingHours> get workingHours {
    if (_workingHours is EqualUnmodifiableListView) return _workingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workingHours);
  }

  @override
  @JsonKey()
  @DurationConverter()
  final Duration dailyWorkLimit;
  @override
  @JsonKey()
  final bool enableBreakReminders;
  @override
  @JsonKey()
  final bool enableHealthTips;
  @override
  @JsonKey()
  final bool enablePostureReminders;
  @override
  @JsonKey()
  @DurationConverter()
  final Duration postureReminderInterval;

  @override
  String toString() {
    return 'AppSettings(language: $language, themeMode: $themeMode, shortBreakInterval: $shortBreakInterval, longBreakInterval: $longBreakInterval, shortBreakDuration: $shortBreakDuration, longBreakDuration: $longBreakDuration, enableNotifications: $enableNotifications, enableSoundNotifications: $enableSoundNotifications, timeFormat: $timeFormat, weekStartDay: $weekStartDay, workingHours: $workingHours, dailyWorkLimit: $dailyWorkLimit, enableBreakReminders: $enableBreakReminders, enableHealthTips: $enableHealthTips, enablePostureReminders: $enablePostureReminders, postureReminderInterval: $postureReminderInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.shortBreakInterval, shortBreakInterval) ||
                other.shortBreakInterval == shortBreakInterval) &&
            (identical(other.longBreakInterval, longBreakInterval) ||
                other.longBreakInterval == longBreakInterval) &&
            (identical(other.shortBreakDuration, shortBreakDuration) ||
                other.shortBreakDuration == shortBreakDuration) &&
            (identical(other.longBreakDuration, longBreakDuration) ||
                other.longBreakDuration == longBreakDuration) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(
                  other.enableSoundNotifications,
                  enableSoundNotifications,
                ) ||
                other.enableSoundNotifications == enableSoundNotifications) &&
            (identical(other.timeFormat, timeFormat) ||
                other.timeFormat == timeFormat) &&
            (identical(other.weekStartDay, weekStartDay) ||
                other.weekStartDay == weekStartDay) &&
            const DeepCollectionEquality().equals(
              other._workingHours,
              _workingHours,
            ) &&
            (identical(other.dailyWorkLimit, dailyWorkLimit) ||
                other.dailyWorkLimit == dailyWorkLimit) &&
            (identical(other.enableBreakReminders, enableBreakReminders) ||
                other.enableBreakReminders == enableBreakReminders) &&
            (identical(other.enableHealthTips, enableHealthTips) ||
                other.enableHealthTips == enableHealthTips) &&
            (identical(other.enablePostureReminders, enablePostureReminders) ||
                other.enablePostureReminders == enablePostureReminders) &&
            (identical(
                  other.postureReminderInterval,
                  postureReminderInterval,
                ) ||
                other.postureReminderInterval == postureReminderInterval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    language,
    themeMode,
    shortBreakInterval,
    longBreakInterval,
    shortBreakDuration,
    longBreakDuration,
    enableNotifications,
    enableSoundNotifications,
    timeFormat,
    weekStartDay,
    const DeepCollectionEquality().hash(_workingHours),
    dailyWorkLimit,
    enableBreakReminders,
    enableHealthTips,
    enablePostureReminders,
    postureReminderInterval,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final String language,
    @ThemeModeConverter() final ThemeMode themeMode,
    @DurationConverter() final Duration shortBreakInterval,
    @DurationConverter() final Duration longBreakInterval,
    @DurationConverter() final Duration shortBreakDuration,
    @DurationConverter() final Duration longBreakDuration,
    final bool enableNotifications,
    final bool enableSoundNotifications,
    final TimeFormat timeFormat,
    final WeekStartDay weekStartDay,
    final List<WorkingHours> workingHours,
    @DurationConverter() final Duration dailyWorkLimit,
    final bool enableBreakReminders,
    final bool enableHealthTips,
    final bool enablePostureReminders,
    @DurationConverter() final Duration postureReminderInterval,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  String get language;
  @override
  @ThemeModeConverter()
  ThemeMode get themeMode;
  @override
  @DurationConverter()
  Duration get shortBreakInterval;
  @override
  @DurationConverter()
  Duration get longBreakInterval;
  @override
  @DurationConverter()
  Duration get shortBreakDuration;
  @override
  @DurationConverter()
  Duration get longBreakDuration;
  @override
  bool get enableNotifications;
  @override
  bool get enableSoundNotifications;
  @override
  TimeFormat get timeFormat;
  @override
  WeekStartDay get weekStartDay;
  @override
  List<WorkingHours> get workingHours;
  @override
  @DurationConverter()
  Duration get dailyWorkLimit;
  @override
  bool get enableBreakReminders;
  @override
  bool get enableHealthTips;
  @override
  bool get enablePostureReminders;
  @override
  @DurationConverter()
  Duration get postureReminderInterval;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkingHours _$WorkingHoursFromJson(Map<String, dynamic> json) {
  return _WorkingHours.fromJson(json);
}

/// @nodoc
mixin _$WorkingHours {
  WeekDay get day => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get startTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get endTime => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this WorkingHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkingHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkingHoursCopyWith<WorkingHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkingHoursCopyWith<$Res> {
  factory $WorkingHoursCopyWith(
    WorkingHours value,
    $Res Function(WorkingHours) then,
  ) = _$WorkingHoursCopyWithImpl<$Res, WorkingHours>;
  @useResult
  $Res call({
    WeekDay day,
    @TimeOfDayConverter() TimeOfDay startTime,
    @TimeOfDayConverter() TimeOfDay endTime,
    bool isEnabled,
  });
}

/// @nodoc
class _$WorkingHoursCopyWithImpl<$Res, $Val extends WorkingHours>
    implements $WorkingHoursCopyWith<$Res> {
  _$WorkingHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkingHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as WeekDay,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkingHoursImplCopyWith<$Res>
    implements $WorkingHoursCopyWith<$Res> {
  factory _$$WorkingHoursImplCopyWith(
    _$WorkingHoursImpl value,
    $Res Function(_$WorkingHoursImpl) then,
  ) = __$$WorkingHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WeekDay day,
    @TimeOfDayConverter() TimeOfDay startTime,
    @TimeOfDayConverter() TimeOfDay endTime,
    bool isEnabled,
  });
}

/// @nodoc
class __$$WorkingHoursImplCopyWithImpl<$Res>
    extends _$WorkingHoursCopyWithImpl<$Res, _$WorkingHoursImpl>
    implements _$$WorkingHoursImplCopyWith<$Res> {
  __$$WorkingHoursImplCopyWithImpl(
    _$WorkingHoursImpl _value,
    $Res Function(_$WorkingHoursImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkingHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _$WorkingHoursImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as WeekDay,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkingHoursImpl implements _WorkingHours {
  const _$WorkingHoursImpl({
    required this.day,
    @TimeOfDayConverter() required this.startTime,
    @TimeOfDayConverter() required this.endTime,
    this.isEnabled = true,
  });

  factory _$WorkingHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkingHoursImplFromJson(json);

  @override
  final WeekDay day;
  @override
  @TimeOfDayConverter()
  final TimeOfDay startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay endTime;
  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'WorkingHours(day: $day, startTime: $startTime, endTime: $endTime, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkingHoursImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, day, startTime, endTime, isEnabled);

  /// Create a copy of WorkingHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkingHoursImplCopyWith<_$WorkingHoursImpl> get copyWith =>
      __$$WorkingHoursImplCopyWithImpl<_$WorkingHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkingHoursImplToJson(this);
  }
}

abstract class _WorkingHours implements WorkingHours {
  const factory _WorkingHours({
    required final WeekDay day,
    @TimeOfDayConverter() required final TimeOfDay startTime,
    @TimeOfDayConverter() required final TimeOfDay endTime,
    final bool isEnabled,
  }) = _$WorkingHoursImpl;

  factory _WorkingHours.fromJson(Map<String, dynamic> json) =
      _$WorkingHoursImpl.fromJson;

  @override
  WeekDay get day;
  @override
  @TimeOfDayConverter()
  TimeOfDay get startTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay get endTime;
  @override
  bool get isEnabled;

  /// Create a copy of WorkingHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkingHoursImplCopyWith<_$WorkingHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
