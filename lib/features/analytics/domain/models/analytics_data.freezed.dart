// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AnalyticsData {
  Duration get totalWorkTime => throw _privateConstructorUsedError;
  Duration get totalBreakTime => throw _privateConstructorUsedError;
  int get completedTasks => throw _privateConstructorUsedError;
  Map<String, ProjectAnalytics> get projectAnalytics =>
      throw _privateConstructorUsedError;
  List<DailyData> get dailyData => throw _privateConstructorUsedError;
  double get focusScore => throw _privateConstructorUsedError;
  double get productivityScore => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
    AnalyticsData value,
    $Res Function(AnalyticsData) then,
  ) = _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call({
    Duration totalWorkTime,
    Duration totalBreakTime,
    int completedTasks,
    Map<String, ProjectAnalytics> projectAnalytics,
    List<DailyData> dailyData,
    double focusScore,
    double productivityScore,
  });
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalWorkTime = null,
    Object? totalBreakTime = null,
    Object? completedTasks = null,
    Object? projectAnalytics = null,
    Object? dailyData = null,
    Object? focusScore = null,
    Object? productivityScore = null,
  }) {
    return _then(
      _value.copyWith(
            totalWorkTime: null == totalWorkTime
                ? _value.totalWorkTime
                : totalWorkTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            totalBreakTime: null == totalBreakTime
                ? _value.totalBreakTime
                : totalBreakTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            completedTasks: null == completedTasks
                ? _value.completedTasks
                : completedTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            projectAnalytics: null == projectAnalytics
                ? _value.projectAnalytics
                : projectAnalytics // ignore: cast_nullable_to_non_nullable
                      as Map<String, ProjectAnalytics>,
            dailyData: null == dailyData
                ? _value.dailyData
                : dailyData // ignore: cast_nullable_to_non_nullable
                      as List<DailyData>,
            focusScore: null == focusScore
                ? _value.focusScore
                : focusScore // ignore: cast_nullable_to_non_nullable
                      as double,
            productivityScore: null == productivityScore
                ? _value.productivityScore
                : productivityScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
    _$AnalyticsDataImpl value,
    $Res Function(_$AnalyticsDataImpl) then,
  ) = __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Duration totalWorkTime,
    Duration totalBreakTime,
    int completedTasks,
    Map<String, ProjectAnalytics> projectAnalytics,
    List<DailyData> dailyData,
    double focusScore,
    double productivityScore,
  });
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
    _$AnalyticsDataImpl _value,
    $Res Function(_$AnalyticsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalWorkTime = null,
    Object? totalBreakTime = null,
    Object? completedTasks = null,
    Object? projectAnalytics = null,
    Object? dailyData = null,
    Object? focusScore = null,
    Object? productivityScore = null,
  }) {
    return _then(
      _$AnalyticsDataImpl(
        totalWorkTime: null == totalWorkTime
            ? _value.totalWorkTime
            : totalWorkTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        totalBreakTime: null == totalBreakTime
            ? _value.totalBreakTime
            : totalBreakTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        completedTasks: null == completedTasks
            ? _value.completedTasks
            : completedTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        projectAnalytics: null == projectAnalytics
            ? _value._projectAnalytics
            : projectAnalytics // ignore: cast_nullable_to_non_nullable
                  as Map<String, ProjectAnalytics>,
        dailyData: null == dailyData
            ? _value._dailyData
            : dailyData // ignore: cast_nullable_to_non_nullable
                  as List<DailyData>,
        focusScore: null == focusScore
            ? _value.focusScore
            : focusScore // ignore: cast_nullable_to_non_nullable
                  as double,
        productivityScore: null == productivityScore
            ? _value.productivityScore
            : productivityScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl({
    required this.totalWorkTime,
    required this.totalBreakTime,
    required this.completedTasks,
    required final Map<String, ProjectAnalytics> projectAnalytics,
    required final List<DailyData> dailyData,
    required this.focusScore,
    required this.productivityScore,
  }) : _projectAnalytics = projectAnalytics,
       _dailyData = dailyData;

  @override
  final Duration totalWorkTime;
  @override
  final Duration totalBreakTime;
  @override
  final int completedTasks;
  final Map<String, ProjectAnalytics> _projectAnalytics;
  @override
  Map<String, ProjectAnalytics> get projectAnalytics {
    if (_projectAnalytics is EqualUnmodifiableMapView) return _projectAnalytics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_projectAnalytics);
  }

  final List<DailyData> _dailyData;
  @override
  List<DailyData> get dailyData {
    if (_dailyData is EqualUnmodifiableListView) return _dailyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyData);
  }

  @override
  final double focusScore;
  @override
  final double productivityScore;

  @override
  String toString() {
    return 'AnalyticsData(totalWorkTime: $totalWorkTime, totalBreakTime: $totalBreakTime, completedTasks: $completedTasks, projectAnalytics: $projectAnalytics, dailyData: $dailyData, focusScore: $focusScore, productivityScore: $productivityScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.totalWorkTime, totalWorkTime) ||
                other.totalWorkTime == totalWorkTime) &&
            (identical(other.totalBreakTime, totalBreakTime) ||
                other.totalBreakTime == totalBreakTime) &&
            (identical(other.completedTasks, completedTasks) ||
                other.completedTasks == completedTasks) &&
            const DeepCollectionEquality().equals(
              other._projectAnalytics,
              _projectAnalytics,
            ) &&
            const DeepCollectionEquality().equals(
              other._dailyData,
              _dailyData,
            ) &&
            (identical(other.focusScore, focusScore) ||
                other.focusScore == focusScore) &&
            (identical(other.productivityScore, productivityScore) ||
                other.productivityScore == productivityScore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalWorkTime,
    totalBreakTime,
    completedTasks,
    const DeepCollectionEquality().hash(_projectAnalytics),
    const DeepCollectionEquality().hash(_dailyData),
    focusScore,
    productivityScore,
  );

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData({
    required final Duration totalWorkTime,
    required final Duration totalBreakTime,
    required final int completedTasks,
    required final Map<String, ProjectAnalytics> projectAnalytics,
    required final List<DailyData> dailyData,
    required final double focusScore,
    required final double productivityScore,
  }) = _$AnalyticsDataImpl;

  @override
  Duration get totalWorkTime;
  @override
  Duration get totalBreakTime;
  @override
  int get completedTasks;
  @override
  Map<String, ProjectAnalytics> get projectAnalytics;
  @override
  List<DailyData> get dailyData;
  @override
  double get focusScore;
  @override
  double get productivityScore;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProjectAnalytics {
  String get projectId => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  Color get projectColor => throw _privateConstructorUsedError;
  Duration get totalTime => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectAnalyticsCopyWith<ProjectAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectAnalyticsCopyWith<$Res> {
  factory $ProjectAnalyticsCopyWith(
    ProjectAnalytics value,
    $Res Function(ProjectAnalytics) then,
  ) = _$ProjectAnalyticsCopyWithImpl<$Res, ProjectAnalytics>;
  @useResult
  $Res call({
    String projectId,
    String projectName,
    Color projectColor,
    Duration totalTime,
    int taskCount,
    double percentage,
  });
}

/// @nodoc
class _$ProjectAnalyticsCopyWithImpl<$Res, $Val extends ProjectAnalytics>
    implements $ProjectAnalyticsCopyWith<$Res> {
  _$ProjectAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? projectName = null,
    Object? projectColor = null,
    Object? totalTime = null,
    Object? taskCount = null,
    Object? percentage = null,
  }) {
    return _then(
      _value.copyWith(
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectName: null == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String,
            projectColor: null == projectColor
                ? _value.projectColor
                : projectColor // ignore: cast_nullable_to_non_nullable
                      as Color,
            totalTime: null == totalTime
                ? _value.totalTime
                : totalTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            taskCount: null == taskCount
                ? _value.taskCount
                : taskCount // ignore: cast_nullable_to_non_nullable
                      as int,
            percentage: null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectAnalyticsImplCopyWith<$Res>
    implements $ProjectAnalyticsCopyWith<$Res> {
  factory _$$ProjectAnalyticsImplCopyWith(
    _$ProjectAnalyticsImpl value,
    $Res Function(_$ProjectAnalyticsImpl) then,
  ) = __$$ProjectAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String projectId,
    String projectName,
    Color projectColor,
    Duration totalTime,
    int taskCount,
    double percentage,
  });
}

/// @nodoc
class __$$ProjectAnalyticsImplCopyWithImpl<$Res>
    extends _$ProjectAnalyticsCopyWithImpl<$Res, _$ProjectAnalyticsImpl>
    implements _$$ProjectAnalyticsImplCopyWith<$Res> {
  __$$ProjectAnalyticsImplCopyWithImpl(
    _$ProjectAnalyticsImpl _value,
    $Res Function(_$ProjectAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? projectName = null,
    Object? projectColor = null,
    Object? totalTime = null,
    Object? taskCount = null,
    Object? percentage = null,
  }) {
    return _then(
      _$ProjectAnalyticsImpl(
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectName: null == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String,
        projectColor: null == projectColor
            ? _value.projectColor
            : projectColor // ignore: cast_nullable_to_non_nullable
                  as Color,
        totalTime: null == totalTime
            ? _value.totalTime
            : totalTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        taskCount: null == taskCount
            ? _value.taskCount
            : taskCount // ignore: cast_nullable_to_non_nullable
                  as int,
        percentage: null == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$ProjectAnalyticsImpl implements _ProjectAnalytics {
  const _$ProjectAnalyticsImpl({
    required this.projectId,
    required this.projectName,
    required this.projectColor,
    required this.totalTime,
    required this.taskCount,
    required this.percentage,
  });

  @override
  final String projectId;
  @override
  final String projectName;
  @override
  final Color projectColor;
  @override
  final Duration totalTime;
  @override
  final int taskCount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'ProjectAnalytics(projectId: $projectId, projectName: $projectName, projectColor: $projectColor, totalTime: $totalTime, taskCount: $taskCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectAnalyticsImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.projectColor, projectColor) ||
                other.projectColor == projectColor) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    projectId,
    projectName,
    projectColor,
    totalTime,
    taskCount,
    percentage,
  );

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectAnalyticsImplCopyWith<_$ProjectAnalyticsImpl> get copyWith =>
      __$$ProjectAnalyticsImplCopyWithImpl<_$ProjectAnalyticsImpl>(
        this,
        _$identity,
      );
}

abstract class _ProjectAnalytics implements ProjectAnalytics {
  const factory _ProjectAnalytics({
    required final String projectId,
    required final String projectName,
    required final Color projectColor,
    required final Duration totalTime,
    required final int taskCount,
    required final double percentage,
  }) = _$ProjectAnalyticsImpl;

  @override
  String get projectId;
  @override
  String get projectName;
  @override
  Color get projectColor;
  @override
  Duration get totalTime;
  @override
  int get taskCount;
  @override
  double get percentage;

  /// Create a copy of ProjectAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectAnalyticsImplCopyWith<_$ProjectAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyData {
  DateTime get date => throw _privateConstructorUsedError;
  Duration get workTime => throw _privateConstructorUsedError;
  Duration get breakTime => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyDataCopyWith<DailyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyDataCopyWith<$Res> {
  factory $DailyDataCopyWith(DailyData value, $Res Function(DailyData) then) =
      _$DailyDataCopyWithImpl<$Res, DailyData>;
  @useResult
  $Res call({
    DateTime date,
    Duration workTime,
    Duration breakTime,
    int taskCount,
  });
}

/// @nodoc
class _$DailyDataCopyWithImpl<$Res, $Val extends DailyData>
    implements $DailyDataCopyWith<$Res> {
  _$DailyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? workTime = null,
    Object? breakTime = null,
    Object? taskCount = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            workTime: null == workTime
                ? _value.workTime
                : workTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            breakTime: null == breakTime
                ? _value.breakTime
                : breakTime // ignore: cast_nullable_to_non_nullable
                      as Duration,
            taskCount: null == taskCount
                ? _value.taskCount
                : taskCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyDataImplCopyWith<$Res>
    implements $DailyDataCopyWith<$Res> {
  factory _$$DailyDataImplCopyWith(
    _$DailyDataImpl value,
    $Res Function(_$DailyDataImpl) then,
  ) = __$$DailyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    Duration workTime,
    Duration breakTime,
    int taskCount,
  });
}

/// @nodoc
class __$$DailyDataImplCopyWithImpl<$Res>
    extends _$DailyDataCopyWithImpl<$Res, _$DailyDataImpl>
    implements _$$DailyDataImplCopyWith<$Res> {
  __$$DailyDataImplCopyWithImpl(
    _$DailyDataImpl _value,
    $Res Function(_$DailyDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? workTime = null,
    Object? breakTime = null,
    Object? taskCount = null,
  }) {
    return _then(
      _$DailyDataImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        workTime: null == workTime
            ? _value.workTime
            : workTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        breakTime: null == breakTime
            ? _value.breakTime
            : breakTime // ignore: cast_nullable_to_non_nullable
                  as Duration,
        taskCount: null == taskCount
            ? _value.taskCount
            : taskCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DailyDataImpl implements _DailyData {
  const _$DailyDataImpl({
    required this.date,
    required this.workTime,
    required this.breakTime,
    required this.taskCount,
  });

  @override
  final DateTime date;
  @override
  final Duration workTime;
  @override
  final Duration breakTime;
  @override
  final int taskCount;

  @override
  String toString() {
    return 'DailyData(date: $date, workTime: $workTime, breakTime: $breakTime, taskCount: $taskCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.workTime, workTime) ||
                other.workTime == workTime) &&
            (identical(other.breakTime, breakTime) ||
                other.breakTime == breakTime) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, workTime, breakTime, taskCount);

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyDataImplCopyWith<_$DailyDataImpl> get copyWith =>
      __$$DailyDataImplCopyWithImpl<_$DailyDataImpl>(this, _$identity);
}

abstract class _DailyData implements DailyData {
  const factory _DailyData({
    required final DateTime date,
    required final Duration workTime,
    required final Duration breakTime,
    required final int taskCount,
  }) = _$DailyDataImpl;

  @override
  DateTime get date;
  @override
  Duration get workTime;
  @override
  Duration get breakTime;
  @override
  int get taskCount;

  /// Create a copy of DailyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyDataImplCopyWith<_$DailyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
