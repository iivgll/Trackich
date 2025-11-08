import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/time_entry.dart';
import '../../../../core/services/storage_service.dart';

// Calendar view providers
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

enum CalendarViewMode { day, week, month, year }

final calendarViewModeProvider = StateProvider<CalendarViewMode>(
  (ref) => CalendarViewMode.month,
);

// Calendar filtering providers
final calendarSelectedProjectProvider = StateProvider<String?>((ref) => null);
final calendarDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);
final calendarYearProvider = StateProvider<int>((ref) => DateTime.now().year);

// Unfiltered time entries provider - shows ALL completed tasks regardless of filter settings
final unfilteredTimeEntriesProvider = FutureProvider<List<TimeEntry>>((
  ref,
) async {
  final storage = ref.read(storageServiceProvider);
  final allEntries = await storage.getTimeEntries();

  // Only filter by completion status - no project or date filtering for main calendar
  return allEntries.where((entry) => entry.isCompleted).toList();
});

// Filtered time entries provider - used only for filtered results screen
final filteredTimeEntriesProvider = FutureProvider<List<TimeEntry>>((
  ref,
) async {
  final storage = ref.read(storageServiceProvider);
  final allEntries = await storage.getTimeEntries();
  final selectedProject = ref.watch(calendarSelectedProjectProvider);
  final dateRange = ref.watch(calendarDateRangeProvider);

  // Filter by completion status
  var filteredEntries = allEntries.where((entry) => entry.isCompleted).toList();

  // Filter by project if selected
  if (selectedProject != null) {
    filteredEntries = filteredEntries
        .where((entry) => entry.projectId == selectedProject)
        .toList();
  }

  // Filter by date range if selected
  if (dateRange != null) {
    filteredEntries = filteredEntries.where((entry) {
      final entryTime = entry.startTime;
      // Use actual time for more precise filtering
      return entryTime.isAfter(dateRange.start) &&
          entryTime.isBefore(dateRange.end);
    }).toList();
  }

  return filteredEntries;
});

// Grouped calendar data by date - now uses filtered data
final calendarDataByDateProvider =
    FutureProvider<Map<DateTime, List<TimeEntry>>>((ref) async {
      final filteredEntries = await ref.watch(
        filteredTimeEntriesProvider.future,
      );

      final entriesByDate = <DateTime, List<TimeEntry>>{};
      for (final entry in filteredEntries) {
        final entryDate = DateTime(
          entry.startTime.year,
          entry.startTime.month,
          entry.startTime.day,
        );
        if (entriesByDate[entryDate] == null) {
          entriesByDate[entryDate] = [];
        }
        entriesByDate[entryDate]!.add(entry);
      }

      return entriesByDate;
    });
