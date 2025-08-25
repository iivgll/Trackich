import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/analytics_data.dart';
import '../../domain/services/analytics_calculator.dart';
import '../../../../core/services/storage_service.dart';
import '../../../projects/presentation/providers/projects_provider.dart';

part 'analytics_provider.g.dart';

// Analytics time range provider
final analyticsTimeRangeProvider = StateProvider<AnalyticsTimeRange>(
  (ref) => AnalyticsTimeRange.week,
);

// Analytics data provider
@riverpod
Future<AnalyticsData> analyticsData(Ref ref) async {
  try {
    final timeRange = ref.watch(analyticsTimeRangeProvider);
    final storage = ref.read(storageServiceProvider);
    final projects = await ref.watch(projectsProvider.future);

    debugPrint('Analytics: Loading data for ${projects.length} projects');

    final now = DateTime.now();
    final startDate = _getStartDateForRange(now, timeRange);

    final allEntries = await storage.getTimeEntries();
    final rangeEntries = allEntries.where((entry) {
      return entry.isCompleted &&
          entry.startTime.isAfter(startDate) &&
          entry.startTime.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    debugPrint('Analytics: Found ${rangeEntries.length} entries in range');

    // Use domain service for calculation
    final analyticsData = AnalyticsCalculator.calculateAnalytics(
      rangeEntries,
      projects,
    );

    // Calculate percentages for project analytics
    final totalWorkTime = analyticsData.totalWorkTime;
    final updatedProjectAnalytics = <String, ProjectAnalytics>{};

    for (final entry in analyticsData.projectAnalytics.entries) {
      final projectAnalytics = entry.value;
      final percentage = totalWorkTime.inMilliseconds > 0
          ? (projectAnalytics.totalTime.inMilliseconds /
                    totalWorkTime.inMilliseconds) *
                100
          : 0.0;

      updatedProjectAnalytics[entry.key] = projectAnalytics.copyWith(
        percentage: percentage,
      );
    }

    return analyticsData.copyWith(projectAnalytics: updatedProjectAnalytics);
  } catch (e, stackTrace) {
    debugPrint('Analytics error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

DateTime _getStartDateForRange(DateTime now, AnalyticsTimeRange range) {
  switch (range) {
    case AnalyticsTimeRange.week:
      return now.subtract(Duration(days: now.weekday - 1));
    case AnalyticsTimeRange.month:
      return DateTime(now.year, now.month, 1);
    case AnalyticsTimeRange.quarter:
      final quarterStart = ((now.month - 1) ~/ 3) * 3 + 1;
      return DateTime(now.year, quarterStart, 1);
    case AnalyticsTimeRange.year:
      return DateTime(now.year, 1, 1);
  }
}
