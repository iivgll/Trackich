import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../features/settings/providers/settings_provider.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/models/time_entry.dart';

/// Widget showing today's work summary with statistics and progress
class TodaySummaryWidget extends ConsumerWidget {
  const TodaySummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final timeEntries = ref.watch(timeEntriesProvider);
    final settings = ref.watch(settingsProvider);
    
    final today = DateTime.now();
    final todayEntries = timeEntries
        .where((entry) => _isSameDay(entry.startTime, today))
        .toList();
    
    final workEntries = todayEntries.where((entry) => !entry.isBreak).toList();
    final breakEntries = todayEntries.where((entry) => entry.isBreak).toList();
    
    final totalWorkTime = workEntries.fold<Duration>(
      Duration.zero,
      (total, entry) => total + entry.calculatedDuration,
    );
    
    final totalBreakTime = breakEntries.fold<Duration>(
      Duration.zero,
      (total, entry) => total + entry.calculatedDuration,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.today_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.todaySummary,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    TimeFormatter.formatDate(today),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Main statistics
              _buildMainStats(context, l10n, theme, totalWorkTime, workEntries.length),
              
              const SizedBox(height: 24),
              
              // Progress bar
              settings.when(
                data: (appSettings) => _buildProgressBar(
                  context, 
                  l10n, 
                  theme, 
                  totalWorkTime, 
                  Duration(hours: appSettings.dailyGoalHours.toInt(), 
                          minutes: ((appSettings.dailyGoalHours % 1) * 60).toInt()),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              
              const SizedBox(height: 24),
              
              // Secondary statistics
              _buildSecondaryStats(context, l10n, theme, totalBreakTime, breakEntries.length),
              
              const SizedBox(height: 24),
              
              // Project breakdown
              _buildProjectBreakdown(context, ref, l10n, theme, workEntries),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainStats(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    Duration totalTime,
    int tasksCount,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            Icons.access_time,
            TimeFormatter.formatDuration(totalTime),
            l10n.timeWorked,
            theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            Icons.task_alt,
            tasksCount.toString(),
            l10n.tasksCompleted(tasksCount),
            theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    Duration workedTime,
    Duration goalTime,
  ) {
    final progress = goalTime.inMilliseconds > 0 
        ? (workedTime.inMilliseconds / goalTime.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.dailyGoalProgress,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${TimeFormatter.formatDuration(workedTime)} / ${TimeFormatter.formatDuration(goalTime)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceContainer,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}% ${l10n.complete}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryStats(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    Duration breakTime,
    int breakCount,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniStat(
            theme,
            Icons.coffee,
            TimeFormatter.formatDuration(breakTime),
            l10n.breakTime,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMiniStat(
            theme,
            Icons.pause,
            breakCount.toString(),
            l10n.breaks,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMiniStat(
            theme,
            Icons.schedule,
            TimeFormatter.formatTime(DateTime.now()),
            l10n.currentTime,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectBreakdown(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
    List<TimeEntry> workEntries,
  ) {
    if (workEntries.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: theme.dividerColor),
          const SizedBox(height: 16),
          Text(
            l10n.noTasksToday,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    // Group entries by project
    final projectTime = <String, Duration>{};
    for (final entry in workEntries) {
      projectTime[entry.projectId] = 
          (projectTime[entry.projectId] ?? Duration.zero) + entry.calculatedDuration;
    }

    // Sort by time spent
    final sortedProjects = projectTime.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: theme.dividerColor),
        const SizedBox(height: 16),
        Text(
          l10n.projectBreakdown,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...sortedProjects.take(5).map((entry) => 
          _buildProjectTimeItem(ref, theme, entry.key, entry.value)),
      ],
    );
  }

  Widget _buildProjectTimeItem(
    WidgetRef ref,
    ThemeData theme,
    String projectId,
    Duration duration,
  ) {
    final project = ref.watch(projectByIdProvider(projectId));
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: project?.color ?? Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              project?.name ?? 'Unknown Project',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            TimeFormatter.formatDuration(duration),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}