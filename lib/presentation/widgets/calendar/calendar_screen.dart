import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/time_entry.dart';
import '../../../core/models/project.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/excel_export_service.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../features/projects/providers/projects_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'filtered_results_screen.dart';

// Calendar view providers
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

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

enum CalendarViewMode { day, week, month, year }

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final viewMode = ref.watch(calendarViewModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppTheme.gray50
          : AppTheme.gray900,
      body: Column(
        children: [
          // Header with controls
          _buildHeader(context, l10n, selectedDate, viewMode),

          // Calendar content
          Expanded(
            child: _buildCalendarContent(context, selectedDate, viewMode),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    DateTime selectedDate,
    CalendarViewMode viewMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Navigation buttons
          IconButton(
            onPressed: () => _navigateDate(-1, viewMode),
            icon: const Icon(Symbols.chevron_left),
            tooltip: 'Previous',
          ),
          const SizedBox(width: AppTheme.space2),

          // Current period title
          Expanded(
            child: Text(
              _getHeaderTitle(selectedDate, viewMode),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: AppTheme.space2),

          IconButton(
            onPressed: () => _navigateDate(1, viewMode),
            icon: const Icon(Symbols.chevron_right),
            tooltip: 'Next',
          ),

          const SizedBox(width: AppTheme.space4),

          // Today button
          TextButton(onPressed: () => _goToToday(), child: Text(l10n.today)),

          const SizedBox(width: AppTheme.space4),

          // View mode toggle
          SegmentedButton<CalendarViewMode>(
            segments: [
              ButtonSegment(
                value: CalendarViewMode.day,
                label: Text(l10n.day),
                icon: const Icon(Symbols.today, size: 16),
              ),
              ButtonSegment(
                value: CalendarViewMode.week,
                label: Text(l10n.week),
                icon: const Icon(Symbols.view_week, size: 16),
              ),
              ButtonSegment(
                value: CalendarViewMode.month,
                label: Text(l10n.month),
                icon: const Icon(Symbols.calendar_view_month, size: 16),
              ),
              ButtonSegment(
                value: CalendarViewMode.year,
                label: Text(l10n.year),
                icon: const Icon(Symbols.calendar_today, size: 16),
              ),
            ],
            selected: {viewMode},
            onSelectionChanged: (Set<CalendarViewMode> selection) {
              if (selection.isNotEmpty) {
                ref.read(calendarViewModeProvider.notifier).state =
                    selection.first;
              }
            },
          ),

          const SizedBox(width: AppTheme.space4),

          // Export to Excel button
          IconButton(
            onPressed: () => _exportToExcel(context),
            icon: const Icon(Symbols.file_download),
            tooltip: 'Export to Excel',
          ),

          const SizedBox(width: AppTheme.space2),

          // Filter button
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Icon(Symbols.filter_list),
            tooltip: 'Filter',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(
    BuildContext context,
    DateTime selectedDate,
    CalendarViewMode viewMode,
  ) {
    switch (viewMode) {
      case CalendarViewMode.day:
        return _DayView(selectedDate: selectedDate);
      case CalendarViewMode.week:
        return _WeekView(selectedDate: selectedDate);
      case CalendarViewMode.month:
        return _MonthView(selectedDate: selectedDate);
      case CalendarViewMode.year:
        return _YearView(selectedDate: selectedDate);
    }
  }

  String _getHeaderTitle(DateTime selectedDate, CalendarViewMode viewMode) {
    switch (viewMode) {
      case CalendarViewMode.day:
        return TimeFormatter.formatDate(selectedDate);
      case CalendarViewMode.week:
        final startOfWeek = selectedDate.subtract(
          Duration(days: selectedDate.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        if (startOfWeek.month == endOfWeek.month) {
          return '${TimeFormatter.formatDate(startOfWeek)} - ${endOfWeek.day}, ${endOfWeek.year}';
        } else {
          return '${TimeFormatter.formatDate(startOfWeek)} - ${TimeFormatter.formatDate(endOfWeek)}';
        }
      case CalendarViewMode.month:
        return TimeFormatter.formatMonthYear(selectedDate);
      case CalendarViewMode.year:
        return selectedDate.year.toString();
    }
  }

  void _navigateDate(int direction, CalendarViewMode viewMode) {
    final current = ref.read(selectedDateProvider);
    DateTime newDate;

    switch (viewMode) {
      case CalendarViewMode.day:
        newDate = current.add(Duration(days: direction));
        break;
      case CalendarViewMode.week:
        newDate = current.add(Duration(days: direction * 7));
        break;
      case CalendarViewMode.month:
        newDate = DateTime(current.year, current.month + direction, 1);
        break;
      case CalendarViewMode.year:
        newDate = DateTime(
          current.year + direction,
          current.month,
          current.day,
        );
        break;
    }

    ref.read(selectedDateProvider.notifier).state = newDate;
  }

  void _goToToday() {
    final now = DateTime.now();
    ref.read(selectedDateProvider.notifier).state = DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _CalendarFilterDialog());
  }

  Future<void> _exportToExcel(BuildContext context) async {
    try {
      // Show loading indicator
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.exportingToExcel),
          duration: const Duration(seconds: 1),
        ),
      );

      // Get filtered time entries
      final filteredEntries = await ref.read(
        filteredTimeEntriesProvider.future,
      );

      // Get projects map
      final projectsAsync = ref.read(projectsProvider);
      final projects = <String, Project>{};

      if (projectsAsync.hasValue) {
        for (final project in projectsAsync.value!) {
          projects[project.id] = project;
        }
      }

      // Get current date range for filename
      final selectedDateRange = ref.read(calendarDateRangeProvider);

      // Export to Excel
      final result = await ExcelExportService.exportTimeEntries(
        entries: filteredEntries,
        projects: projects,
        dateRange: selectedDateRange,
      );

      // Handle result
      if (context.mounted) {
        if (result == 'cancelled') {
          // User cancelled - no message needed
          return;
        }

        // Show success message
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportSuccess),
            duration: const Duration(seconds: 3),
            backgroundColor: AppTheme.getSuccessColor(context),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

// Day View Widget
class _DayView extends ConsumerWidget {
  final DateTime selectedDate;

  const _DayView({required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<TimeEntry>>(
      future: _getEntriesForDate(ref, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data ?? [];
        final workEntries = entries.where((e) => !e.isBreak).toList();
        final breakEntries = entries.where((e) => e.isBreak).toList();

        return Padding(
          padding: const EdgeInsets.all(AppTheme.space6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day summary
              _DaySummaryCard(
                workEntries: workEntries,
                breakEntries: breakEntries,
              ),
              const SizedBox(height: AppTheme.space6),

              // Timeline
              Expanded(child: _buildTimeline(context, entries)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeline(BuildContext context, List<TimeEntry> entries) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    // Sort entries by start time
    final sortedEntries = List<TimeEntry>.from(entries)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.separated(
      itemCount: sortedEntries.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppTheme.space3),
      itemBuilder: (context, index) {
        return _TimelineItem(entry: sortedEntries[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Symbols.event_busy, size: 64, color: AppTheme.gray400),
          const SizedBox(height: AppTheme.space4),
          Text(
            'No activity for this day',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppTheme.gray600),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            'Start a timer to track your work',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.gray500),
          ),
        ],
      ),
    );
  }

  Future<List<TimeEntry>> _getEntriesForDate(
    WidgetRef ref,
    DateTime date,
  ) async {
    final entriesByDate = await ref.read(calendarDataByDateProvider.future);
    final targetDate = DateTime(date.year, date.month, date.day);
    return entriesByDate[targetDate] ?? [];
  }
}

// Week View Widget
class _WeekView extends ConsumerWidget {
  final DateTime selectedDate;

  const _WeekView({required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<DateTime, List<TimeEntry>>>(
      future: _getEntriesForWeek(ref, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final entriesByDate = snapshot.data ?? {};
        final weekDays = _getWeekDays(selectedDate);

        return Padding(
          padding: const EdgeInsets.all(AppTheme.space6),
          child: Column(
            children: [
              // Week summary
              _WeekSummaryCard(entriesByDate: entriesByDate),
              const SizedBox(height: AppTheme.space6),

              // Week calendar
              Expanded(
                child: _buildWeekCalendar(
                  context,
                  ref,
                  weekDays,
                  entriesByDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekCalendar(
    BuildContext context,
    WidgetRef ref,
    List<DateTime> weekDays,
    Map<DateTime, List<TimeEntry>> entriesByDate,
  ) {
    return Row(
      children: weekDays.map((day) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        final dayEntries = entriesByDate[normalizedDay] ?? [];
        final isToday = _isToday(day);
        final isSelected = _isSameDay(day, ref.watch(selectedDateProvider));

        return Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(selectedDateProvider.notifier).state = normalizedDay;
              ref.read(calendarViewModeProvider.notifier).state =
                  CalendarViewMode.day;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue.withOpacity(0.1)
                    : isToday
                    ? AppTheme.successGreen.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: isSelected
                    ? Border.all(color: AppTheme.primaryBlue, width: 2)
                    : isToday
                    ? Border.all(color: AppTheme.successGreen, width: 1)
                    : Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: [
                  // Day header
                  Container(
                    padding: const EdgeInsets.all(AppTheme.space3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryBlue.withOpacity(0.1)
                          : isToday
                          ? AppTheme.successGreen.withOpacity(0.1)
                          : Theme.of(context).brightness == Brightness.light
                          ? AppTheme.gray50
                          : AppTheme.gray800,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusMd),
                        topRight: Radius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ][day.weekday - 1],
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : isToday
                                    ? AppTheme.successGreen
                                    : AppTheme.gray600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day.day.toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : isToday
                                    ? AppTheme.successGreen
                                    : null,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Day entries
                  Expanded(
                    child: dayEntries.isEmpty
                        ? Center(
                            child: Icon(
                              Symbols.event_busy,
                              size: 24,
                              color: AppTheme.gray400,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppTheme.space2),
                            itemCount: dayEntries.length,
                            itemBuilder: (context, index) {
                              return _WeekTimelineItem(
                                entry: dayEntries[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<DateTime> _getWeekDays(DateTime selectedDate) {
    final startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  Future<Map<DateTime, List<TimeEntry>>> _getEntriesForWeek(
    WidgetRef ref,
    DateTime selectedDate,
  ) async {
    final allEntriesByDate = await ref.read(calendarDataByDateProvider.future);
    final weekDays = _getWeekDays(selectedDate);

    final weekEntriesByDate = <DateTime, List<TimeEntry>>{};
    for (final day in weekDays) {
      final normalizedDay = DateTime(day.year, day.month, day.day);
      final dayEntries = allEntriesByDate[normalizedDay] ?? [];
      if (dayEntries.isNotEmpty) {
        weekEntriesByDate[normalizedDay] = dayEntries;
      }
    }

    return weekEntriesByDate;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// Month View Widget
class _MonthView extends ConsumerWidget {
  final DateTime selectedDate;

  const _MonthView({required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<DateTime, List<TimeEntry>>>(
      future: _getEntriesForMonth(ref, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final entriesByDate = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.all(AppTheme.space6),
          child: _buildMonthCalendar(context, ref, selectedDate, entriesByDate),
        );
      },
    );
  }

  Widget _buildMonthCalendar(
    BuildContext context,
    WidgetRef ref,
    DateTime month,
    Map<DateTime, List<TimeEntry>> entriesByDate,
  ) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    // Calculate calendar grid
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday - 1),
    );
    final endDate = lastDayOfMonth.add(
      Duration(days: 7 - lastDayOfMonth.weekday),
    );

    final calendarDays = <DateTime>[];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      calendarDays.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return Column(
      children: [
        // Weekday headers
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.space2),
          child: Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // Calendar grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemCount: calendarDays.length,
            itemBuilder: (context, index) {
              final date = calendarDays[index];
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final dayEntries = entriesByDate[normalizedDate] ?? [];
              final isCurrentMonth = date.month == month.month;
              final isToday = _isToday(date);
              final isSelected = _isSameDay(
                date,
                ref.watch(selectedDateProvider),
              );

              return GestureDetector(
                onTap: () {
                  ref.read(selectedDateProvider.notifier).state =
                      normalizedDate;
                  ref.read(calendarViewModeProvider.notifier).state =
                      CalendarViewMode.day;
                },
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryBlue.withOpacity(0.1)
                        : isToday
                        ? AppTheme.successGreen.withOpacity(0.1)
                        : null,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: isSelected
                        ? Border.all(color: AppTheme.primaryBlue, width: 2)
                        : isToday
                        ? Border.all(color: AppTheme.successGreen, width: 1)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCurrentMonth
                              ? (isSelected
                                    ? AppTheme.primaryBlue
                                    : isToday
                                    ? AppTheme.successGreen
                                    : null)
                              : AppTheme.gray400,
                        ),
                      ),
                      if (dayEntries.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (dayEntries.where((e) => !e.isBreak).isNotEmpty)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (dayEntries
                                .where((e) => e.isBreak)
                                .isNotEmpty) ...[
                              const SizedBox(width: 2),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppTheme.breakBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<Map<DateTime, List<TimeEntry>>> _getEntriesForMonth(
    WidgetRef ref,
    DateTime month,
  ) async {
    final allEntriesByDate = await ref.read(calendarDataByDateProvider.future);
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final monthEntriesByDate = <DateTime, List<TimeEntry>>{};
    for (final date in allEntriesByDate.keys) {
      if (date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfMonth.add(const Duration(days: 1)))) {
        monthEntriesByDate[date] = allEntriesByDate[date]!;
      }
    }

    return monthEntriesByDate;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// Day Summary Card
class _DaySummaryCard extends ConsumerWidget {
  final List<TimeEntry> workEntries;
  final List<TimeEntry> breakEntries;

  const _DaySummaryCard({
    required this.workEntries,
    required this.breakEntries,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalWorkTime = workEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );
    final totalBreakTime = breakEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Symbols.work,
                    label: 'Work Time',
                    value: TimeFormatter.formatDuration(totalWorkTime),
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: AppTheme.space4),
                Expanded(
                  child: _SummaryItem(
                    icon: Symbols.coffee,
                    label: 'Break Time',
                    value: TimeFormatter.formatDuration(totalBreakTime),
                    color: AppTheme.breakBlue,
                  ),
                ),
                const SizedBox(width: AppTheme.space4),
                Expanded(
                  child: _SummaryItem(
                    icon: Symbols.task_alt,
                    label: 'Tasks',
                    value: workEntries.length.toString(),
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Summary Item Widget
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: AppTheme.space2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.gray600),
          ),
        ],
      ),
    );
  }
}

// Timeline Item Widget
class _TimelineItem extends ConsumerWidget {
  final TimeEntry entry;

  const _TimelineItem({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return projectsAsync.when(
      data: (projects) {
        final project = projects.firstWhere(
          (p) => p.id == entry.projectId,
          orElse: () => projects.first, // fallback
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space4),
            child: Row(
              children: [
                // Time indicator
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: entry.isBreak ? AppTheme.breakBlue : project.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppTheme.space4),

                // Entry details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            entry.isBreak ? Symbols.coffee : Symbols.work,
                            size: 16,
                            color: entry.isBreak
                                ? AppTheme.breakBlue
                                : project.color,
                          ),
                          const SizedBox(width: AppTheme.space2),
                          Expanded(
                            child: Text(
                              entry.taskName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space1),
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: project.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space2),
                      Row(
                        children: [
                          Icon(
                            Symbols.schedule,
                            size: 14,
                            color: AppTheme.gray500,
                          ),
                          const SizedBox(width: AppTheme.space1),
                          Text(
                            '${TimeFormatter.formatTime(entry.startTime)} - ${TimeFormatter.formatTime(entry.effectiveEndTime)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.gray600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Duration
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space3,
                    vertical: AppTheme.space2,
                  ),
                  decoration: BoxDecoration(
                    color: (entry.isBreak ? AppTheme.breakBlue : project.color)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    TimeFormatter.formatDurationWords(entry.duration),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: entry.isBreak ? AppTheme.breakBlue : project.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Card(
        child: SizedBox(
          height: 80,
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => Card(
        child: SizedBox(
          height: 80,
          child: Center(
            child: Text(AppLocalizations.of(context).errorLoadingProject),
          ),
        ),
      ),
    );
  }
}

// Week Summary Card
class _WeekSummaryCard extends ConsumerWidget {
  final Map<DateTime, List<TimeEntry>> entriesByDate;

  const _WeekSummaryCard({required this.entriesByDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEntries = entriesByDate.values.expand((e) => e).toList();
    final workEntries = allEntries.where((e) => !e.isBreak).toList();
    final breakEntries = allEntries.where((e) => e.isBreak).toList();

    final totalWorkTime = workEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );
    final totalBreakTime = breakEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                icon: Symbols.work,
                label: 'Work Time',
                value: TimeFormatter.formatDuration(totalWorkTime),
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _SummaryItem(
                icon: Symbols.coffee,
                label: 'Break Time',
                value: TimeFormatter.formatDuration(totalBreakTime),
                color: AppTheme.breakBlue,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _SummaryItem(
                icon: Symbols.task_alt,
                label: 'Tasks',
                value: workEntries.length.toString(),
                color: AppTheme.successGreen,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _SummaryItem(
                icon: Symbols.calendar_view_week,
                label: 'Days Active',
                value: entriesByDate.keys.length.toString(),
                color: AppTheme.focusPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Week Timeline Item
class _WeekTimelineItem extends ConsumerWidget {
  final TimeEntry entry;

  const _WeekTimelineItem({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return projectsAsync.when(
      data: (projects) {
        final project = projects.firstWhere(
          (p) => p.id == entry.projectId,
          orElse: () => projects.first, // fallback
        );

        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.space2),
          padding: const EdgeInsets.all(AppTheme.space2),
          decoration: BoxDecoration(
            color: (entry.isBreak ? AppTheme.breakBlue : project.color)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: (entry.isBreak ? AppTheme.breakBlue : project.color)
                  .withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    entry.isBreak ? Symbols.coffee : Symbols.work,
                    size: 12,
                    color: entry.isBreak ? AppTheme.breakBlue : project.color,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      entry.taskName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                TimeFormatter.formatTime(entry.startTime),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.gray600,
                  fontSize: 9,
                ),
              ),
              Text(
                TimeFormatter.formatDurationWords(entry.duration),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: entry.isBreak ? AppTheme.breakBlue : project.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => SizedBox(
        height: 40,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => SizedBox(
        height: 40,
        child: Center(child: Text(AppLocalizations.of(context).error)),
      ),
    );
  }
}

// Year View Widget
class _YearView extends ConsumerWidget {
  final DateTime selectedDate;

  const _YearView({required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<int, Map<DateTime, List<TimeEntry>>>>(
      future: _getEntriesForYear(ref, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final entriesByMonth = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.all(AppTheme.space6),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppTheme.space4,
              mainAxisSpacing: AppTheme.space4,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final monthDate = DateTime(selectedDate.year, month, 1);
              final monthEntries = entriesByMonth[month] ?? {};
              final totalHours = _getTotalHoursForMonth(monthEntries);

              return GestureDetector(
                onTap: () {
                  ref.read(selectedDateProvider.notifier).state = monthDate;
                  ref.read(calendarViewModeProvider.notifier).state =
                      CalendarViewMode.month;
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.space4),
                    child: Column(
                      children: [
                        Text(
                          _getMonthName(month),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppTheme.space2),
                        Expanded(
                          child: monthEntries.isEmpty
                              ? Icon(
                                  Symbols.event_busy,
                                  size: 32,
                                  color: AppTheme.gray400,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${monthEntries.keys.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: AppTheme.primaryBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    Text(
                                      'active days',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppTheme.gray600),
                                    ),
                                    const SizedBox(height: AppTheme.space2),
                                    Text(
                                      '${totalHours.toStringAsFixed(1)}h',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppTheme.successGreen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<Map<int, Map<DateTime, List<TimeEntry>>>> _getEntriesForYear(
    WidgetRef ref,
    DateTime year,
  ) async {
    final allEntriesByDate = await ref.read(calendarDataByDateProvider.future);
    final startOfYear = DateTime(year.year, 1, 1);
    final endOfYear = DateTime(year.year, 12, 31);

    final entriesByMonth = <int, Map<DateTime, List<TimeEntry>>>{};
    for (final date in allEntriesByDate.keys) {
      if (date.isAfter(startOfYear.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfYear.add(const Duration(days: 1)))) {
        final month = date.month;
        if (entriesByMonth[month] == null) {
          entriesByMonth[month] = {};
        }
        entriesByMonth[month]![date] = allEntriesByDate[date]!;
      }
    }

    return entriesByMonth;
  }

  double _getTotalHoursForMonth(Map<DateTime, List<TimeEntry>> monthEntries) {
    final allEntries = monthEntries.values.expand((e) => e).toList();
    final workEntries = allEntries.where((e) => !e.isBreak);
    return workEntries.fold<double>(
      0.0,
      (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}

// Calendar Filter Dialog
class _CalendarFilterDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CalendarFilterDialog> createState() =>
      _CalendarFilterDialogState();
}

class _CalendarFilterDialogState extends ConsumerState<_CalendarFilterDialog> {
  String? _selectedProjectId;
  DateTimeRange? _selectedDateRange;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = ref.read(calendarSelectedProjectProvider);
    _selectedDateRange = ref.read(calendarDateRangeProvider);
    _selectedYear = ref.read(calendarYearProvider);
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(activeProjectsProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Symbols.filter_list, color: AppTheme.primaryBlue),
          const SizedBox(width: AppTheme.space2),
          Text(AppLocalizations.of(context).filterCalendar),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Filter
            Text(
              'Filter by Project',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.space2),
            projectsAsync.when(
              data: (projects) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: DropdownButton<String?>(
                  value: _selectedProjectId,
                  hint: Text(AppLocalizations.of(context).allProjects),
                  isExpanded: true,
                  underline: Container(),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(AppLocalizations.of(context).allProjects),
                    ),
                    ...projects.map(
                      (project) => DropdownMenuItem<String?>(
                        value: project.id,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: project.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppTheme.space3),
                            Text(project.name),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedProjectId = value),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Error loading projects'),
            ),

            const SizedBox(height: AppTheme.space6),

            // Date Range Filter
            Text(
              'Custom Date Range',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.space2),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: const Icon(Symbols.date_range),
                    label: Text(
                      _selectedDateRange != null
                          ? '${TimeFormatter.formatDate(_selectedDateRange!.start)} - ${TimeFormatter.formatDate(_selectedDateRange!.end)}'
                          : 'Select Range',
                    ),
                  ),
                ),
                if (_selectedDateRange != null) ...[
                  const SizedBox(width: AppTheme.space2),
                  IconButton(
                    onPressed: () => setState(() => _selectedDateRange = null),
                    icon: const Icon(Symbols.clear),
                    tooltip: 'Clear',
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppTheme.space6),

            // Quick Filters
            Text(
              'Quick Filters',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.space2),
            Wrap(
              spacing: AppTheme.space2,
              children: [
                _QuickFilterChip(
                  label: 'Last 7 days',
                  onTap: () => _setQuickDateRange(7),
                ),
                _QuickFilterChip(
                  label: 'Last 30 days',
                  onTap: () => _setQuickDateRange(30),
                ),
                _QuickFilterChip(
                  label: 'Last 3 months',
                  onTap: () => _setQuickDateRange(90),
                ),
                _QuickFilterChip(
                  label: 'This year',
                  onTap: () => _setCurrentYear(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        TextButton(
          onPressed: _clearFilters,
          child: Text(AppLocalizations.of(context).clearAll),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: Text(AppLocalizations.of(context).apply),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _setQuickDateRange(int days) {
    final now = DateTime.now();
    // Set end to end of today to include today's entries
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    // Set start to beginning of the day N days ago
    final startDate = now.subtract(
      Duration(days: days - 1),
    ); // -1 to include today
    final start = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      0,
      0,
      0,
    );
    setState(() => _selectedDateRange = DateTimeRange(start: start, end: end));
  }

  void _setCurrentYear() {
    final year = DateTime.now().year;
    final start = DateTime(year, 1, 1, 0, 0, 0);
    final end = DateTime(year, 12, 31, 23, 59, 59);
    setState(() => _selectedDateRange = DateTimeRange(start: start, end: end));
  }

  void _clearFilters() {
    ref.read(calendarSelectedProjectProvider.notifier).state = null;
    ref.read(calendarDateRangeProvider.notifier).state = null;
    ref.read(calendarYearProvider.notifier).state = DateTime.now().year;
    Navigator.of(context).pop();
  }

  void _applyFilters() async {
    // Update the providers for the calendar view
    ref.read(calendarSelectedProjectProvider.notifier).state =
        _selectedProjectId;
    ref.read(calendarDateRangeProvider.notifier).state = _selectedDateRange;
    ref.read(calendarYearProvider.notifier).state = _selectedYear;

    // Close the dialog
    Navigator.of(context).pop();

    // Get filtered entries for the new screen
    try {
      final filteredEntries = await ref.read(
        filteredTimeEntriesProvider.future,
      );

      // Navigate to filtered results screen
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FilteredResultsScreen(
              projectId: _selectedProjectId,
              dateRange: _selectedDateRange,
              filteredEntries: filteredEntries,
            ),
          ),
        );
      }
    } catch (e) {
      // Show error if filtering fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error applying filters: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

// Quick Filter Chip
class _QuickFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickFilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
      labelStyle: TextStyle(color: AppTheme.primaryBlue),
    );
  }
}

// Calendar Filtered List View
class CalendarFilteredListView extends ConsumerWidget {
  final ScrollController scrollController;

  const CalendarFilteredListView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProject = ref.watch(calendarSelectedProjectProvider);
    final dateRange = ref.watch(calendarDateRangeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusLg),
          topRight: Radius.circular(AppTheme.radiusLg),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppTheme.space3),
            decoration: BoxDecoration(
              color: AppTheme.gray400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.space6),
            child: Row(
              children: [
                const Icon(Symbols.list, color: AppTheme.primaryBlue),
                const SizedBox(width: AppTheme.space2),
                const Text(
                  'Completed Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (selectedProject != null || dateRange != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space3,
                      vertical: AppTheme.space1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Text(
                      'Filtered',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Content
          Expanded(
            child: FutureBuilder<List<TimeEntry>>(
              future: ref.read(filteredTimeEntriesProvider.future),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Symbols.error,
                          size: 64,
                          color: AppTheme.errorRed,
                        ),
                        const SizedBox(height: AppTheme.space4),
                        Text(
                          'Error loading data',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppTheme.errorRed),
                        ),
                      ],
                    ),
                  );
                }

                final filteredEntries = snapshot.data ?? [];

                if (filteredEntries.isEmpty) {
                  return _buildEmptyFilteredState(
                    context,
                    ref,
                    selectedProject,
                    dateRange,
                  );
                }

                // Group filtered entries by date
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

                // Sort dates in descending order (most recent first)
                final sortedDates = entriesByDate.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppTheme.space6),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final dayEntries = entriesByDate[date]!;

                    return _CalendarDayGroup(date: date, entries: dayEntries);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilteredState(
    BuildContext context,
    WidgetRef ref,
    String? selectedProject,
    DateTimeRange? dateRange,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Symbols.search_off, size: 80, color: AppTheme.gray400),
          const SizedBox(height: AppTheme.space6),
          Text(
            'No tasks found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.space3),
          Text(
            _getEmptyStateMessage(selectedProject, dateRange),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.gray500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space6),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(calendarSelectedProjectProvider.notifier).state = null;
              ref.read(calendarDateRangeProvider.notifier).state = null;
              Navigator.of(context).pop();
            },
            icon: const Icon(Symbols.filter_list_off),
            label: Text(AppLocalizations.of(context).clearFilters),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage(
    String? selectedProject,
    DateTimeRange? dateRange,
  ) {
    if (selectedProject != null && dateRange != null) {
      return 'No completed tasks found for the selected project and date range.\nTry adjusting your filters.';
    } else if (selectedProject != null) {
      return 'No completed tasks found for the selected project.\nTry selecting a different project.';
    } else if (dateRange != null) {
      return 'No completed tasks found in the selected date range.\nTry expanding your date range.';
    } else {
      return 'No completed tasks found.\nStart tracking some work!';
    }
  }
}

// Calendar Day Group Widget
class _CalendarDayGroup extends ConsumerWidget {
  final DateTime date;
  final List<TimeEntry> entries;

  const _CalendarDayGroup({required this.date, required this.entries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workEntries = entries.where((e) => !e.isBreak).toList();

    final totalWorkTime = workEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    final isToday = _isToday(date);
    final isYesterday = _isYesterday(date);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isToday
              ? AppTheme.successGreen.withOpacity(0.3)
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          // Date Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.space4),
            decoration: BoxDecoration(
              color: isToday
                  ? AppTheme.successGreen.withOpacity(0.1)
                  : Theme.of(context).brightness == Brightness.light
                  ? AppTheme.gray50
                  : AppTheme.gray800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMd),
                topRight: Radius.circular(AppTheme.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isToday ? Symbols.today : Symbols.calendar_today,
                  size: 20,
                  color: isToday ? AppTheme.successGreen : AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppTheme.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDateLabel(date, isToday, isYesterday),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isToday ? AppTheme.successGreen : null,
                            ),
                      ),
                      Text(
                        TimeFormatter.formatDate(date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Task count and time summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.space3,
                        vertical: AppTheme.space1,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Text(
                        '${entries.length} task${entries.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.space1),
                    if (totalWorkTime.inMinutes > 0)
                      Text(
                        TimeFormatter.formatDuration(totalWorkTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Tasks list
          ...entries.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            final isLast = index == entries.length - 1;

            return Container(
              decoration: BoxDecoration(
                border: !isLast
                    ? Border(
                        bottom: BorderSide(
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.5),
                        ),
                      )
                    : null,
              ),
              child: _CalendarTaskItem(entry: task),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getDateLabel(DateTime date, bool isToday, bool isYesterday) {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';

    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[date.weekday - 1];
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}

// Calendar Task Item Widget
class _CalendarTaskItem extends ConsumerWidget {
  final TimeEntry entry;

  const _CalendarTaskItem({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return projectsAsync.when(
      data: (projects) {
        final project = projects.firstWhere(
          (p) => p.id == entry.projectId,
          orElse: () => projects.first, // fallback
        );

        return Padding(
          padding: const EdgeInsets.all(AppTheme.space4),
          child: Row(
            children: [
              // Task type indicator
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: entry.isBreak ? AppTheme.breakBlue : project.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppTheme.space4),

              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          entry.isBreak ? Symbols.coffee : Symbols.work,
                          size: 16,
                          color: entry.isBreak
                              ? AppTheme.breakBlue
                              : project.color,
                        ),
                        const SizedBox(width: AppTheme.space2),
                        Expanded(
                          child: Text(
                            entry.taskName,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.space1),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: project.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppTheme.space2),
                        Text(
                          project.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: project.color,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const Spacer(),
                        Icon(
                          Symbols.schedule,
                          size: 14,
                          color: AppTheme.gray500,
                        ),
                        const SizedBox(width: AppTheme.space1),
                        Text(
                          '${TimeFormatter.formatTime(entry.startTime)} - ${TimeFormatter.formatTime(entry.effectiveEndTime)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.gray600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Duration badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: AppTheme.space2,
                ),
                decoration: BoxDecoration(
                  color: (entry.isBreak ? AppTheme.breakBlue : project.color)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  TimeFormatter.formatDurationWords(entry.duration),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: entry.isBreak ? AppTheme.breakBlue : project.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 56,
        padding: const EdgeInsets.all(AppTheme.space4),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        height: 56,
        padding: const EdgeInsets.all(AppTheme.space4),
        child: Center(
          child: Text(AppLocalizations.of(context).errorLoadingProject),
        ),
      ),
    );
  }
}
