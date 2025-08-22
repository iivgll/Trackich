import 'package:freezed_annotation/freezed_annotation.dart';
import 'settings.dart'; // Import for DurationConverter

part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required String id,
    required String projectId,
    required String taskName,
    @Default('') String description,
    required DateTime startTime,
    DateTime? endTime,
    @DurationConverter() required Duration duration,
    @DurationConverter() @Default(Duration.zero) Duration totalAccumulatedTime,
    @Default([]) List<String> tags,
    @Default(false) bool isBreak,
    BreakType? breakType,
    @Default(false) bool isCompleted,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(Map<String, dynamic> json) => _$TimeEntryFromJson(json);
}

@freezed
class BreakType with _$BreakType {
  const factory BreakType.short() = ShortBreak;
  const factory BreakType.long() = LongBreak;
  const factory BreakType.custom({required String name, @DurationConverter() required Duration duration}) = CustomBreak;

  factory BreakType.fromJson(Map<String, dynamic> json) => _$BreakTypeFromJson(json);
}

extension TimeEntryExtension on TimeEntry {
  double get durationInHours => duration.inMilliseconds / (1000 * 60 * 60);
  double get totalAccumulatedHours => totalAccumulatedTime.inMilliseconds / (1000 * 60 * 60);
  
  bool get isRunning => endTime == null && !isCompleted;
  
  DateTime get effectiveEndTime => endTime ?? DateTime.now();
  
  /// Get the display duration (accumulated + current session)
  Duration get displayDuration => totalAccumulatedTime + duration;
  
  /// Get a unique key for grouping tasks (project + task name)
  String get taskGroupKey => '${projectId}_${taskName.trim().toLowerCase()}';
}