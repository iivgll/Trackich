import 'package:json_annotation/json_annotation.dart';

part 'time_entry.g.dart';

@JsonSerializable()
class TimeEntry {
  const TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskName,
    required this.startTime,
    this.endTime,
    this.duration,
    this.notes,
    this.isBreak = false,
    this.breakType,
    this.tags = const [],
  });

  final String id;
  final String projectId;
  final String taskName;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;
  final String? notes;
  final bool isBreak;
  final BreakType? breakType;
  final List<String> tags;

  factory TimeEntry.fromJson(Map<String, dynamic> json) => _$TimeEntryFromJson(json);
  Map<String, dynamic> toJson() => _$TimeEntryToJson(this);

  TimeEntry copyWith({
    String? id,
    String? projectId,
    String? taskName,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    String? notes,
    bool? isBreak,
    BreakType? breakType,
    List<String>? tags,
  }) {
    return TimeEntry(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      taskName: taskName ?? this.taskName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      isBreak: isBreak ?? this.isBreak,
      breakType: breakType ?? this.breakType,
      tags: tags ?? this.tags,
    );
  }

  /// Calculate duration based on start and end time if not provided
  Duration get calculatedDuration {
    if (duration != null) return duration!;
    if (endTime != null) return endTime!.difference(startTime);
    return Duration.zero;
  }

  /// Check if the entry is currently active (no end time)
  bool get isActive => endTime == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TimeEntry{id: $id, projectId: $projectId, taskName: $taskName, '
        'startTime: $startTime, endTime: $endTime, duration: $duration, '
        'notes: $notes, isBreak: $isBreak, breakType: $breakType, tags: $tags}';
  }
}

@JsonEnum()
enum BreakType {
  @JsonValue('short')
  short,
  @JsonValue('long')
  long,
  @JsonValue('custom')
  custom,
  @JsonValue('lunch')
  lunch,
}