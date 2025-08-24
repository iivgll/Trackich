import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/time_entry.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../features/projects/providers/projects_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
part 'analytics_screen.g.dart';

// Analytics providers
final analyticsTimeRangeProvider = StateProvider<AnalyticsTimeRange>(
  (ref) => AnalyticsTimeRange.week,
);

enum AnalyticsTimeRange { week, month, quarter, year }

// Analytics data provider
@riverpod
Future<AnalyticsData> analyticsData(AnalyticsDataRef ref) async {
  final timeRange = ref.watch(analyticsTimeRangeProvider);
  final storage = ref.read(storageServiceProvider);
  final projects = await ref.watch(projectsProvider.future);

  final now = DateTime.now();
  final startDate = _getStartDateForRange(now, timeRange);

  final allEntries = await storage.getTimeEntries();
  final rangeEntries = allEntries.where((entry) {
    return entry.isCompleted &&
        entry.startTime.isAfter(startDate) &&
        entry.startTime.isBefore(now.add(const Duration(days: 1)));
  }).toList();

  return AnalyticsData.fromEntries(rangeEntries, projects);
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

class AnalyticsData {
  final Duration totalWorkTime;
  final Duration totalBreakTime;
  final int completedTasks;
  final Map<String, ProjectAnalytics> projectAnalytics;
  final List<DailyData> dailyData;
  final double focusScore;
  final double productivityScore;

  AnalyticsData({
    required this.totalWorkTime,
    required this.totalBreakTime,
    required this.completedTasks,
    required this.projectAnalytics,
    required this.dailyData,
    required this.focusScore,
    required this.productivityScore,
  });

  factory AnalyticsData.fromEntries(List<TimeEntry> entries, List projects) {
    final workEntries = entries.where((e) => !e.isBreak).toList();
    final breakEntries = entries.where((e) => e.isBreak).toList();

    final totalWorkTime = workEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    final totalBreakTime = breakEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    // Calculate project analytics
    final projectAnalytics = <String, ProjectAnalytics>{};
    for (final project in projects) {
      final projectEntries = workEntries
          .where((e) => e.projectId == project.id)
          .toList();
      if (projectEntries.isNotEmpty) {
        projectAnalytics[project.id] = ProjectAnalytics.fromEntries(
          project,
          projectEntries,
        );
      }
    }

    // Calculate daily data
    final dailyData = _calculateDailyData(entries);

    // Calculate focus score (1-10 based on break compliance and task completion)
    final focusScore = _calculateFocusScore(workEntries, breakEntries);

    // Calculate productivity score (1-10 based on time tracked and tasks completed)
    final productivityScore = _calculateProductivityScore(workEntries);

    return AnalyticsData(
      totalWorkTime: totalWorkTime,
      totalBreakTime: totalBreakTime,
      completedTasks: workEntries.length,
      projectAnalytics: projectAnalytics,
      dailyData: dailyData,
      focusScore: focusScore,
      productivityScore: productivityScore,
    );
  }

  static List<DailyData> _calculateDailyData(List<TimeEntry> entries) {
    final dailyMap = <String, DailyData>{};

    for (final entry in entries) {
      final dayKey =
          '${entry.startTime.year}-${entry.startTime.month}-${entry.startTime.day}';
      if (!dailyMap.containsKey(dayKey)) {
        dailyMap[dayKey] = DailyData(
          date: DateTime(
            entry.startTime.year,
            entry.startTime.month,
            entry.startTime.day,
          ),
          workTime: Duration.zero,
          breakTime: Duration.zero,
          tasks: 0,
        );
      }

      final dayData = dailyMap[dayKey]!;
      if (entry.isBreak) {
        dailyMap[dayKey] = dayData.copyWith(
          breakTime: dayData.breakTime + entry.duration,
        );
      } else {
        dailyMap[dayKey] = dayData.copyWith(
          workTime: dayData.workTime + entry.duration,
          tasks: dayData.tasks + 1,
        );
      }
    }

    return dailyMap.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  static double _calculateFocusScore(
    List<TimeEntry> workEntries,
    List<TimeEntry> breakEntries,
  ) {
    if (workEntries.isEmpty) return 0.0;

    final totalWorkMinutes = workEntries.fold<int>(
      0,
      (sum, entry) => sum + entry.duration.inMinutes,
    );
    final totalBreakMinutes = breakEntries.fold<int>(
      0,
      (sum, entry) => sum + entry.duration.inMinutes,
    );

    // Good break ratio is around 15-20% of work time
    final idealBreakRatio = 0.15;
    final actualBreakRatio = totalWorkMinutes > 0
        ? totalBreakMinutes / totalWorkMinutes
        : 0.0;

    final breakScore =
        (1.0 - (actualBreakRatio - idealBreakRatio).abs() / idealBreakRatio)
            .clamp(0.0, 1.0);

    // Also consider task completion frequency (more frequent task completion = better focus)
    final avgTaskDuration = totalWorkMinutes / workEntries.length;
    final taskScore = (120 / (avgTaskDuration + 30)).clamp(
      0.0,
      1.0,
    ); // Ideal task duration: 30-120 minutes

    return ((breakScore + taskScore) / 2 * 10).clamp(0.0, 10.0);
  }

  static double _calculateProductivityScore(List<TimeEntry> workEntries) {
    if (workEntries.isEmpty) return 0.0;

    final totalHours = workEntries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.duration.inMinutes / 60,
    );
    final tasksPerHour = workEntries.length / totalHours;

    // Good productivity: 1-3 tasks per hour
    final productivityScore = (tasksPerHour / 2).clamp(0.0, 1.0);

    return (productivityScore * 10).clamp(0.0, 10.0);
  }
}

class ProjectAnalytics {
  final String projectId;
  final String projectName;
  final Color projectColor;
  final Duration totalTime;
  final int taskCount;
  final double percentage;

  ProjectAnalytics({
    required this.projectId,
    required this.projectName,
    required this.projectColor,
    required this.totalTime,
    required this.taskCount,
    required this.percentage,
  });

  factory ProjectAnalytics.fromEntries(project, List<TimeEntry> entries) {
    final totalTime = entries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    return ProjectAnalytics(
      projectId: project.id,
      projectName: project.name,
      projectColor: project.color,
      totalTime: totalTime,
      taskCount: entries.length,
      percentage: 0.0, // Will be calculated later with total context
    );
  }
}

class DailyData {
  final DateTime date;
  final Duration workTime;
  final Duration breakTime;
  final int tasks;

  DailyData({
    required this.date,
    required this.workTime,
    required this.breakTime,
    required this.tasks,
  });

  DailyData copyWith({
    DateTime? date,
    Duration? workTime,
    Duration? breakTime,
    int? tasks,
  }) {
    return DailyData(
      date: date ?? this.date,
      workTime: workTime ?? this.workTime,
      breakTime: breakTime ?? this.breakTime,
      tasks: tasks ?? this.tasks,
    );
  }
}

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final timeRange = ref.watch(analyticsTimeRangeProvider);
    final analyticsAsync = ref.watch(analyticsDataProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppTheme.gray50
          : AppTheme.gray900,
      body: Column(
        children: [
          // Header with time range selector
          _buildHeader(context, l10n, timeRange, ref),

          // Analytics content
          Expanded(
            child: analyticsAsync.when(
              data: (data) => _buildAnalyticsContent(context, l10n, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.error,
                      size: 64,
                      color: AppTheme.getErrorColor(context),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      '${AppLocalizations.of(context).error} loading analytics: $error',
                    ),
                    const SizedBox(height: AppTheme.space4),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(analyticsDataProvider),
                      child: Text(AppLocalizations.of(context).retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    AnalyticsTimeRange timeRange,
    WidgetRef ref,
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
          Text(
            l10n.analytics,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),

          // Time range selector
          SegmentedButton<AnalyticsTimeRange>(
            segments: [
              ButtonSegment(
                value: AnalyticsTimeRange.week,
                label: Text(AppLocalizations.of(context).week),
              ),
              ButtonSegment(
                value: AnalyticsTimeRange.month,
                label: Text(AppLocalizations.of(context).month),
              ),
              ButtonSegment(
                value: AnalyticsTimeRange.quarter,
                label: Text(AppLocalizations.of(context).quarter),
              ),
              ButtonSegment(
                value: AnalyticsTimeRange.year,
                label: Text(AppLocalizations.of(context).year),
              ),
            ],
            selected: {timeRange},
            onSelectionChanged: (Set<AnalyticsTimeRange> selection) {
              if (selection.isNotEmpty) {
                ref.read(analyticsTimeRangeProvider.notifier).state =
                    selection.first;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(
    BuildContext context,
    AppLocalizations l10n,
    AnalyticsData data,
  ) {
    if (data.completedTasks == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Symbols.analytics, size: 64, color: AppTheme.gray400),
            const SizedBox(height: AppTheme.space4),
            Text(
              l10n.noDataForPeriod,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.gray600),
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              l10n.startTrackingMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.gray500),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics
          _buildKeyMetrics(context, data),
          const SizedBox(height: AppTheme.space8),

          // Project breakdown
          _buildProjectBreakdown(context, data),
          const SizedBox(height: AppTheme.space8),

          // Daily activity chart
          _buildDailyActivity(context, data),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(BuildContext context, AnalyticsData data) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.keyMetrics,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.space6),

        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Symbols.work,
                title: l10n.totalWorkTime,
                value: TimeFormatter.formatDuration(data.totalWorkTime),
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _MetricCard(
                icon: Symbols.coffee,
                title: l10n.breakTime,
                value: TimeFormatter.formatDuration(data.totalBreakTime),
                color: AppTheme.breakBlue,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _MetricCard(
                icon: Symbols.task_alt,
                title: l10n.tasksCompleted,
                value: data.completedTasks.toString(),
                color: AppTheme.getSuccessColor(context),
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            Expanded(
              child: _MetricCard(
                icon: Symbols.psychology,
                title: l10n.focusScore,
                value: '${data.focusScore.toStringAsFixed(1)}/10',
                color: AppTheme.getAccentColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectBreakdown(BuildContext context, AnalyticsData data) {
    final l10n = AppLocalizations.of(context);
    if (data.projectAnalytics.isEmpty) return Container();

    // Calculate percentages
    final totalTime = data.totalWorkTime.inMinutes;
    final projectsWithPercentage = data.projectAnalytics.values.map((project) {
      final percentage = totalTime > 0
          ? (project.totalTime.inMinutes / totalTime) * 100
          : 0.0;
      return ProjectAnalytics(
        projectId: project.projectId,
        projectName: project.projectName,
        projectColor: project.projectColor,
        totalTime: project.totalTime,
        taskCount: project.taskCount,
        percentage: percentage,
      );
    }).toList()..sort((a, b) => b.totalTime.compareTo(a.totalTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.projectBreakdown,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.space6),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space6),
            child: Column(
              children: projectsWithPercentage.take(5).map((project) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.space4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: project.projectColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.space3),
                          Expanded(
                            child: Text(
                              project.projectName,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            '${project.percentage.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: AppTheme.space3),
                          Text(
                            TimeFormatter.formatDuration(project.totalTime),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: project.projectColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space2),
                      LinearProgressIndicator(
                        value: project.percentage / 100,
                        backgroundColor: project.projectColor.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          project.projectColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyActivity(BuildContext context, AnalyticsData data) {
    final l10n = AppLocalizations.of(context);
    if (data.dailyData.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dailyActivity,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.space6),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space6),
            child: Column(
              children: [
                // Simple bar chart representation
                SizedBox(
                  height: 200,
                  child: _SimpleBarChart(data: data.dailyData),
                ),
                const SizedBox(height: AppTheme.space4),

                // Daily breakdown list
                ...data.dailyData
                    .take(7)
                    .map((day) => _DailyActivityItem(day: day)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppTheme.space3),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTheme.space1),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final List<DailyData> data;

  const _SimpleBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return Container();

    final maxHours = data
        .map((d) => d.workTime.inMinutes / 60)
        .reduce((a, b) => a > b ? a : b);
    if (maxHours == 0) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((day) {
        final hours = day.workTime.inMinutes / 60;
        final height = (hours / maxHours) * 150;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height.clamp(4.0, 150.0),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              TimeFormatter.formatDayOfWeek(day.date).substring(0, 3),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.gray600),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _DailyActivityItem extends StatelessWidget {
  final DailyData day;

  const _DailyActivityItem({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.space2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              TimeFormatter.formatDate(day.date),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(Symbols.work, size: 16, color: AppTheme.primaryBlue),
                const SizedBox(width: AppTheme.space1),
                Text(
                  TimeFormatter.formatDuration(day.workTime),
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppTheme.space4),
                Icon(Symbols.coffee, size: 16, color: AppTheme.breakBlue),
                const SizedBox(width: AppTheme.space1),
                Text(
                  TimeFormatter.formatDuration(day.breakTime),
                  style: TextStyle(
                    color: AppTheme.breakBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppTheme.space4),
                Icon(
                  Symbols.task_alt,
                  size: 16,
                  color: AppTheme.getSuccessColor(context),
                ),
                const SizedBox(width: AppTheme.space1),
                Text(
                  '${day.tasks} tasks',
                  style: TextStyle(
                    color: AppTheme.getSuccessColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
