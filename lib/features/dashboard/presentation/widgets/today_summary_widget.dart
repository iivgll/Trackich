import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:trackich/features/timer/presentation/providers/timer_provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../l10n/generated/app_localizations.dart';

class TodaySummaryWidget extends ConsumerWidget {
  const TodaySummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaySummaryAsync = ref.watch(todayTimeSummaryProvider);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shadowColor: AppTheme.shadowMd.color,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Symbols.today,
                  size: 20,
                  color: AppTheme.getPrimaryColor(context),
                ),
                const SizedBox(width: AppTheme.space2),
                Text(
                  l10n.todayActivity,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space6),

            todaySummaryAsync.when(
              data: (summary) => _buildSummaryContent(context, summary),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading today\'s activity', // TODO: Add l10n.errorLoadingTodaysActivity
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(
    BuildContext context,
    Map<String, dynamic> summary,
  ) {
    AppLocalizations.of(context);
    final workHours = summary['workHours'] as double;
    final completedTasks = summary['completedTasks'] as int;
    final hoursByProject =
        summary['hoursByProject'] as Map<String, Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Time Display
        Center(
          child: Column(
            children: [
              Text(
                TimeFormatter.formatHours(workHours),
                style: AppTheme.timerMedium(
                  context,
                ).copyWith(color: AppTheme.getPrimaryColor(context)),
              ),
              const SizedBox(height: AppTheme.space1),
              Text(
                'Work Time Today', // TODO: Add l10n.workTimeToday
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray600),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.space6),

        // Project Breakdown
        if (hoursByProject.isNotEmpty) ...[
          Text(
            'Project Breakdown', // TODO: Add l10n.projectBreakdown
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.space4),

          for (final entry in hoursByProject.entries) ...[
            Builder(
              builder: (context) {
                final projectData = entry.value;
                final projectName = projectData['name'] as String;
                final projectColor = projectData['color'] as Color;
                final projectHours = projectData['hours'] as double;
                final percentage = projectData['percentage'] as double;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.space3),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: projectColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.space2),
                          Expanded(
                            child: Text(
                              projectName,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            TimeFormatter.formatHours(projectHours),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space2),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: projectColor.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(projectColor),
                        minHeight: 4,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: AppTheme.space4),
        ],

        // Statistics Row
        Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Symbols.task_alt,
                label: 'Tasks', // TODO: Add l10n.tasks
                value: completedTasks.toString(),
                color: AppTheme.successGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: AppTheme.space2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
