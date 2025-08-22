// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) {
  return _TimeEntry.fromJson(json);
}

/// @nodoc
mixin _$TimeEntry {
  String get id => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get taskName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get duration => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration get totalAccumulatedTime => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isBreak => throw _privateConstructorUsedError;
  BreakType? get breakType => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this TimeEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeEntryCopyWith<TimeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeEntryCopyWith<$Res> {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) then) =
      _$TimeEntryCopyWithImpl<$Res, TimeEntry>;
  @useResult
  $Res call({
    String id,
    String projectId,
    String taskName,
    String description,
    DateTime startTime,
    DateTime? endTime,
    @DurationConverter() Duration duration,
    @DurationConverter() Duration totalAccumulatedTime,
    List<String> tags,
    bool isBreak,
    BreakType? breakType,
    bool isCompleted,
  });

  $BreakTypeCopyWith<$Res>? get breakType;
}

/// @nodoc
class _$TimeEntryCopyWithImpl<$Res, $Val extends TimeEntry>
    implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? taskName = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? duration = null,
    Object? totalAccumulatedTime = null,
    Object? tags = null,
    Object? isBreak = null,
    Object? breakType = freezed,
    Object? isCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            taskName: null == taskName
                ? _value.taskName
                : taskName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            totalAccumulatedTime: null == totalAccumulatedTime
                ? _value.totalAccumulatedTime
                : totalAccumulatedTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isBreak: null == isBreak
                ? _value.isBreak
                : isBreak // ignore: cast_nullable_to_non_nullable
                      as bool,
            breakType: freezed == breakType
                ? _value.breakType
                : breakType // ignore: cast_nullable_to_non_nullable
                      as BreakType?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BreakTypeCopyWith<$Res>? get breakType {
    if (_value.breakType == null) {
      return null;
    }

    return $BreakTypeCopyWith<$Res>(_value.breakType!, (value) {
      return _then(_value.copyWith(breakType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimeEntryImplCopyWith<$Res>
    implements $TimeEntryCopyWith<$Res> {
  factory _$$TimeEntryImplCopyWith(
    _$TimeEntryImpl value,
    $Res Function(_$TimeEntryImpl) then,
  ) = __$$TimeEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String projectId,
    String taskName,
    String description,
    DateTime startTime,
    DateTime? endTime,
    @DurationConverter() Duration duration,
    @DurationConverter() Duration totalAccumulatedTime,
    List<String> tags,
    bool isBreak,
    BreakType? breakType,
    bool isCompleted,
  });

  @override
  $BreakTypeCopyWith<$Res>? get breakType;
}

/// @nodoc
class __$$TimeEntryImplCopyWithImpl<$Res>
    extends _$TimeEntryCopyWithImpl<$Res, _$TimeEntryImpl>
    implements _$$TimeEntryImplCopyWith<$Res> {
  __$$TimeEntryImplCopyWithImpl(
    _$TimeEntryImpl _value,
    $Res Function(_$TimeEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? taskName = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? duration = null,
    Object? totalAccumulatedTime = null,
    Object? tags = null,
    Object? isBreak = null,
    Object? breakType = freezed,
    Object? isCompleted = null,
  }) {
    return _then(
      _$TimeEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        taskName: null == taskName
            ? _value.taskName
            : taskName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        totalAccumulatedTime: null == totalAccumulatedTime
            ? _value.totalAccumulatedTime
            : totalAccumulatedTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isBreak: null == isBreak
            ? _value.isBreak
            : isBreak // ignore: cast_nullable_to_non_nullable
                  as bool,
        breakType: freezed == breakType
            ? _value.breakType
            : breakType // ignore: cast_nullable_to_non_nullable
                  as BreakType?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeEntryImpl implements _TimeEntry {
  const _$TimeEntryImpl({
    required this.id,
    required this.projectId,
    required this.taskName,
    this.description = '',
    required this.startTime,
    this.endTime,
    @DurationConverter() required this.duration,
    @DurationConverter() this.totalAccumulatedTime = Duration.zero,
    final List<String> tags = const [],
    this.isBreak = false,
    this.breakType,
    this.isCompleted = false,
  }) : _tags = tags;

  factory _$TimeEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String projectId;
  @override
  final String taskName;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  @DurationConverter()
  final Duration duration;
  @override
  @JsonKey()
  @DurationConverter()
  final Duration totalAccumulatedTime;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isBreak;
  @override
  final BreakType? breakType;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'TimeEntry(id: $id, projectId: $projectId, taskName: $taskName, description: $description, startTime: $startTime, endTime: $endTime, duration: $duration, totalAccumulatedTime: $totalAccumulatedTime, tags: $tags, isBreak: $isBreak, breakType: $breakType, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.taskName, taskName) ||
                other.taskName == taskName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.totalAccumulatedTime, totalAccumulatedTime) ||
                other.totalAccumulatedTime == totalAccumulatedTime) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isBreak, isBreak) || other.isBreak == isBreak) &&
            (identical(other.breakType, breakType) ||
                other.breakType == breakType) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    projectId,
    taskName,
    description,
    startTime,
    endTime,
    duration,
    totalAccumulatedTime,
    const DeepCollectionEquality().hash(_tags),
    isBreak,
    breakType,
    isCompleted,
  );

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      __$$TimeEntryImplCopyWithImpl<_$TimeEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeEntryImplToJson(this);
  }
}

abstract class _TimeEntry implements TimeEntry {
  const factory _TimeEntry({
    required final String id,
    required final String projectId,
    required final String taskName,
    final String description,
    required final DateTime startTime,
    final DateTime? endTime,
    @DurationConverter() required final Duration duration,
    @DurationConverter() final Duration totalAccumulatedTime,
    final List<String> tags,
    final bool isBreak,
    final BreakType? breakType,
    final bool isCompleted,
  }) = _$TimeEntryImpl;

  factory _TimeEntry.fromJson(Map<String, dynamic> json) =
      _$TimeEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get projectId;
  @override
  String get taskName;
  @override
  String get description;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  @DurationConverter()
  Duration get duration;
  @override
  @DurationConverter()
  Duration get totalAccumulatedTime;
  @override
  List<String> get tags;
  @override
  bool get isBreak;
  @override
  BreakType? get breakType;
  @override
  bool get isCompleted;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreakType _$BreakTypeFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'short':
      return ShortBreak.fromJson(json);
    case 'long':
      return LongBreak.fromJson(json);
    case 'custom':
      return CustomBreak.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'BreakType',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$BreakType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() short,
    required TResult Function() long,
    required TResult Function(
      String name,
      @DurationConverter() Duration duration,
    )
    custom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? short,
    TResult? Function()? long,
    TResult? Function(String name, @DurationConverter() Duration duration)?
    custom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? short,
    TResult Function()? long,
    TResult Function(String name, @DurationConverter() Duration duration)?
    custom,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShortBreak value) short,
    required TResult Function(LongBreak value) long,
    required TResult Function(CustomBreak value) custom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShortBreak value)? short,
    TResult? Function(LongBreak value)? long,
    TResult? Function(CustomBreak value)? custom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShortBreak value)? short,
    TResult Function(LongBreak value)? long,
    TResult Function(CustomBreak value)? custom,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this BreakType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakTypeCopyWith<$Res> {
  factory $BreakTypeCopyWith(BreakType value, $Res Function(BreakType) then) =
      _$BreakTypeCopyWithImpl<$Res, BreakType>;
}

/// @nodoc
class _$BreakTypeCopyWithImpl<$Res, $Val extends BreakType>
    implements $BreakTypeCopyWith<$Res> {
  _$BreakTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreakType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ShortBreakImplCopyWith<$Res> {
  factory _$$ShortBreakImplCopyWith(
    _$ShortBreakImpl value,
    $Res Function(_$ShortBreakImpl) then,
  ) = __$$ShortBreakImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShortBreakImplCopyWithImpl<$Res>
    extends _$BreakTypeCopyWithImpl<$Res, _$ShortBreakImpl>
    implements _$$ShortBreakImplCopyWith<$Res> {
  __$$ShortBreakImplCopyWithImpl(
    _$ShortBreakImpl _value,
    $Res Function(_$ShortBreakImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ShortBreakImpl implements ShortBreak {
  const _$ShortBreakImpl({final String? $type}) : $type = $type ?? 'short';

  factory _$ShortBreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortBreakImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BreakType.short()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ShortBreakImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() short,
    required TResult Function() long,
    required TResult Function(
      String name,
      @DurationConverter() Duration duration,
    )
    custom,
  }) {
    return short();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? short,
    TResult? Function()? long,
    TResult? Function(String name, @DurationConverter() Duration duration)?
    custom,
  }) {
    return short?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? short,
    TResult Function()? long,
    TResult Function(String name, @DurationConverter() Duration duration)?
    custom,
    required TResult orElse(),
  }) {
    if (short != null) {
      return short();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShortBreak value) short,
    required TResult Function(LongBreak value) long,
    required TResult Function(CustomBreak value) custom,
  }) {
    return short(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShortBreak value)? short,
    TResult? Function(LongBreak value)? long,
    TResult? Function(CustomBreak value)? custom,
  }) {
    return short?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShortBreak value)? short,
    TResult Function(LongBreak value)? long,
    TResult Function(CustomBreak value)? custom,
    required TResult orElse(),
  }) {
    if (short != null) {
      return short(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortBreakImplToJson(this);
  }
}

abstract class ShortBreak implements BreakType {
  const factory ShortBreak() = _$ShortBreakImpl;

  factory ShortBreak.fromJson(Map<String, dynamic> json) =
      _$ShortBreakImpl.fromJson;
}

/// @nodoc
abstract class _$$LongBreakImplCopyWith<$Res> {
  factory _$$LongBreakImplCopyWith(
    _$LongBreakImpl value,
    $Res Function(_$LongBreakImpl) then,
  ) = __$$LongBreakImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LongBreakImplCopyWithImpl<$Res>
    extends _$BreakTypeCopyWithImpl<$Res, _$LongBreakImpl>
    implements _$$LongBreakImplCopyWith<$Res> {
  __$$LongBreakImplCopyWithImpl(
    _$LongBreakImpl _value,
    $Res Function(_$LongBreakImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LongBreakImpl implements LongBreak {
  const _$LongBreakImpl({final String? $type}) : $type = $type ?? 'long';

  factory _$LongBreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$LongBreakImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BreakType.long()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LongBreakImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() short,
    required TResult Function() long,
    required TResult Function(
      String name,
      @DurationConverter() Duration duration,
    )
    custom,
  }) {
    return long();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? short,
    TResult? Function()? long,
    TResult? Function(String name, @DurationConverter() Duration duration)?
    custom,
  }) {
    return long?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? short,
    TResult Function()? long,
    TResult Function(String name, @DurationConverter() Duration duration)?
    custom,
    required TResult orElse(),
  }) {
    if (long != null) {
      return long();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShortBreak value) short,
    required TResult Function(LongBreak value) long,
    required TResult Function(CustomBreak value) custom,
  }) {
    return long(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShortBreak value)? short,
    TResult? Function(LongBreak value)? long,
    TResult? Function(CustomBreak value)? custom,
  }) {
    return long?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShortBreak value)? short,
    TResult Function(LongBreak value)? long,
    TResult Function(CustomBreak value)? custom,
    required TResult orElse(),
  }) {
    if (long != null) {
      return long(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LongBreakImplToJson(this);
  }
}

abstract class LongBreak implements BreakType {
  const factory LongBreak() = _$LongBreakImpl;

  factory LongBreak.fromJson(Map<String, dynamic> json) =
      _$LongBreakImpl.fromJson;
}

/// @nodoc
abstract class _$$CustomBreakImplCopyWith<$Res> {
  factory _$$CustomBreakImplCopyWith(
    _$CustomBreakImpl value,
    $Res Function(_$CustomBreakImpl) then,
  ) = __$$CustomBreakImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, @DurationConverter() Duration duration});
}

/// @nodoc
class __$$CustomBreakImplCopyWithImpl<$Res>
    extends _$BreakTypeCopyWithImpl<$Res, _$CustomBreakImpl>
    implements _$$CustomBreakImplCopyWith<$Res> {
  __$$CustomBreakImplCopyWithImpl(
    _$CustomBreakImpl _value,
    $Res Function(_$CustomBreakImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? duration = null}) {
    return _then(
      _$CustomBreakImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomBreakImpl implements CustomBreak {
  const _$CustomBreakImpl({
    required this.name,
    @DurationConverter() required this.duration,
    final String? $type,
  }) : $type = $type ?? 'custom';

  factory _$CustomBreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomBreakImplFromJson(json);

  @override
  final String name;
  @override
  @DurationConverter()
  final Duration duration;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BreakType.custom(name: $name, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomBreakImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, duration);

  /// Create a copy of BreakType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomBreakImplCopyWith<_$CustomBreakImpl> get copyWith =>
      __$$CustomBreakImplCopyWithImpl<_$CustomBreakImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() short,
    required TResult Function() long,
    required TResult Function(
      String name,
      @DurationConverter() Duration duration,
    )
    custom,
  }) {
    return custom(name, duration);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? short,
    TResult? Function()? long,
    TResult? Function(String name, @DurationConverter() Duration duration)?
    custom,
  }) {
    return custom?.call(name, duration);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? short,
    TResult Function()? long,
    TResult Function(String name, @DurationConverter() Duration duration)?
    custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(name, duration);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShortBreak value) short,
    required TResult Function(LongBreak value) long,
    required TResult Function(CustomBreak value) custom,
  }) {
    return custom(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShortBreak value)? short,
    TResult? Function(LongBreak value)? long,
    TResult? Function(CustomBreak value)? custom,
  }) {
    return custom?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShortBreak value)? short,
    TResult Function(LongBreak value)? long,
    TResult Function(CustomBreak value)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomBreakImplToJson(this);
  }
}

abstract class CustomBreak implements BreakType {
  const factory CustomBreak({
    required final String name,
    @DurationConverter() required final Duration duration,
  }) = _$CustomBreakImpl;

  factory CustomBreak.fromJson(Map<String, dynamic> json) =
      _$CustomBreakImpl.fromJson;

  String get name;
  @DurationConverter()
  Duration get duration;

  /// Create a copy of BreakType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomBreakImplCopyWith<_$CustomBreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
