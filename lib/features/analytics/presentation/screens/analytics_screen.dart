import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/analytics_data.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analyticsAsync = ref.watch(analyticsDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analytics),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [_TimeRangeDropdown()],
      ),
      body: analyticsAsync.when(
        data: (data) => _AnalyticsContent(data: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                l10n.error,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(analyticsDataProvider);
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeRangeDropdown extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final timeRange = ref.watch(analyticsTimeRangeProvider);

    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.space3),
      child: DropdownButton<AnalyticsTimeRange>(
        value: timeRange,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (AnalyticsTimeRange? newValue) {
          if (newValue != null) {
            ref.read(analyticsTimeRangeProvider.notifier).state = newValue;
          }
        },
        items: [
          DropdownMenuItem(
            value: AnalyticsTimeRange.week,
            child: Text(l10n.week),
          ),
          DropdownMenuItem(
            value: AnalyticsTimeRange.month,
            child: Text(l10n.month),
          ),
          DropdownMenuItem(
            value: AnalyticsTimeRange.quarter,
            child: Text(l10n.quarter),
          ),
          DropdownMenuItem(
            value: AnalyticsTimeRange.year,
            child: Text(l10n.year),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  final AnalyticsData data;

  const _AnalyticsContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (data.completedTasks == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.analytics,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noDataForPeriod,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.startTrackingMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KeyMetricsSection(data: data),
          const SizedBox(height: AppTheme.space6),
          _ProjectBreakdownSection(data: data),
          const SizedBox(height: AppTheme.space6),
          _DailyActivitySection(data: data),
        ],
      ),
    );
  }
}

class _KeyMetricsSection extends StatelessWidget {
  final AnalyticsData data;

  const _KeyMetricsSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.keyMetrics,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.space4),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Symbols.schedule,
                title: l10n.totalWorkTime,
                value: TimeFormatter.formatDuration(data.totalWorkTime),
                color: AppTheme.primaryBlue,
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
                color: AppTheme.getWarningColor(context),
              ),
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.space3),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppTheme.space2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.space1),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectBreakdownSection extends StatelessWidget {
  final AnalyticsData data;

  const _ProjectBreakdownSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projects = data.projectAnalytics.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    if (projects.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.projectBreakdown,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.space4),
        ...projects.map((project) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppTheme.space3),
            padding: const EdgeInsets.all(AppTheme.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppTheme.space3),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project.projectName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${project.percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space2),
                LinearProgressIndicator(
                  value: project.percentage / 100,
                  backgroundColor: project.projectColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    project.projectColor,
                  ),
                ),
                const SizedBox(height: AppTheme.space2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TimeFormatter.formatDuration(project.totalTime),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${project.taskCount} ${project.taskCount == 1 ? 'task' : 'tasks'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _DailyActivitySection extends StatelessWidget {
  final AnalyticsData data;

  const _DailyActivitySection({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (data.dailyData.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dailyActivity,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.space4),
        Container(
          padding: const EdgeInsets.all(AppTheme.space4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppTheme.space3),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Column(
            children: data.dailyData.map((day) {
              final maxHours = data.dailyData
                  .map((d) => d.workTime.inMinutes / 60)
                  .fold(0.0, (max, hours) => hours > max ? hours : max);
              final hours = day.workTime.inMinutes / 60;
              final percentage = maxHours > 0 ? hours / maxHours : 0.0;

              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.space3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${day.date.day}/${day.date.month}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space3),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.space3),
                    SizedBox(
                      width: 60,
                      child: Text(
                        TimeFormatter.formatDuration(day.workTime),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
