import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'analytics_data.freezed.dart';

@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    required Duration totalWorkTime,
    required Duration totalBreakTime,
    required int completedTasks,
    required Map<String, ProjectAnalytics> projectAnalytics,
    required List<DailyData> dailyData,
    required double focusScore,
    required double productivityScore,
  }) = _AnalyticsData;
}

@freezed
class ProjectAnalytics with _$ProjectAnalytics {
  const factory ProjectAnalytics({
    required String projectId,
    required String projectName,
    required Color projectColor,
    required Duration totalTime,
    required int taskCount,
    required double percentage,
  }) = _ProjectAnalytics;
}

@freezed
class DailyData with _$DailyData {
  const factory DailyData({
    required DateTime date,
    required Duration workTime,
    required Duration breakTime,
    required int taskCount,
  }) = _DailyData;
}

enum AnalyticsTimeRange { week, month, quarter, year }
