import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/models/time_entry.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';

part 'recent_tasks_widget.g.dart';

// Provider for recent time entries with project information
@riverpod
Future<List<TimeEntryWithProject>> recentTimeEntries(
  RecentTimeEntriesRef ref,
) async {
  final storage = ref.read(storageServiceProvider);
  final projects = await ref.watch(projectsProvider.future);
  final entries = await storage.getTimeEntries();

  // Get last 10 entries, excluding breaks
  final workEntries =
      entries.where((entry) => !entry.isBreak && entry.isCompleted).toList()
        ..sort((a, b) => b.effectiveEndTime.compareTo(a.effectiveEndTime));

  final recentEntries = workEntries.take(10).toList();

  // Combine with project data
  final result = <TimeEntryWithProject>[];
  for (final entry in recentEntries) {
    try {
      final project = projects.firstWhere((p) => p.id == entry.projectId);
      result.add(TimeEntryWithProject(entry, project));
    } catch (e) {
      // Skip entries with deleted projects
    }
  }

  return result;
}

class TimeEntryWithProject {
  final TimeEntry timeEntry;
  final project;

  TimeEntryWithProject(this.timeEntry, this.project);
}

class RecentTasksWidget extends ConsumerWidget {
  const RecentTasksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTasksAsync = ref.watch(recentTimeEntriesProvider);
    AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppTheme.calmWhite
            : AppTheme.falloutSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Theme.of(context).brightness == Brightness.light
            ? Border.all(color: AppTheme.calmLightBorder, width: 1)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Symbols.history, size: 20, color: AppTheme.calmBlue),
                const SizedBox(width: AppTheme.space2),
                Text(
                  AppLocalizations.of(context).recentActivity,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: 'today',
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'today',
                      child: Text(AppLocalizations.of(context).today),
                    ),
                    DropdownMenuItem(
                      value: 'week',
                      child: Text(AppLocalizations.of(context).thisWeek),
                    ),
                    DropdownMenuItem(
                      value: 'all',
                      child: Text(AppLocalizations.of(context).allTime),
                    ),
                  ],
                  onChanged: (value) {
                    // TODO: Filter tasks based on selected period
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space4),

            // Tasks List
            SizedBox(
              height: 200, // Fixed height to prevent overflow issues
              child: recentTasksAsync.when(
                data: (recentTasks) => recentTasks.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                        itemCount: recentTasks.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final entryWithProject = recentTasks[index];
                          return _TaskItem(
                            entryWithProject: entryWithProject,
                            onTap: () => _onTaskTap(context, entryWithProject),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Error loading recent tasks', // TODO: Add l10n.errorLoadingRecentTasks
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.task, size: 48, color: AppTheme.gray400),
          const SizedBox(height: AppTheme.space3),
          Text(
            'No recent tasks', // TODO: Add l10n.noRecentTasks
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.gray500),
          ),
          const SizedBox(height: AppTheme.space1),
          Text(
            'Start a timer to see your tasks here', // TODO: Add l10n.startTimerToSeeTasks
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray400),
          ),
        ],
      ),
    );
  }

  void _onTaskTap(BuildContext context, TimeEntryWithProject entryWithProject) {
    // TODO: Show task details or edit dialog
    showDialog(
      context: context,
      builder: (context) =>
          _TaskDetailsDialog(entryWithProject: entryWithProject),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TimeEntryWithProject entryWithProject;
  final VoidCallback onTap;

  const _TaskItem({required this.entryWithProject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.space3,
          horizontal: AppTheme.space2,
        ),
        child: Row(
          children: [
            // Project color indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: entryWithProject.project.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppTheme.space3),

            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entryWithProject.timeEntry.taskName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.space1),
                  Row(
                    children: [
                      Text(
                        entryWithProject.project.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: entryWithProject.project.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray400,
                        ),
                      ),
                      Text(
                        TimeFormatter.formatTimeAgo(
                          entryWithProject.timeEntry.effectiveEndTime,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  TimeFormatter.formatDurationWords(
                    entryWithProject.timeEntry.duration,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray700,
                  ),
                ),
                Icon(Symbols.edit, size: 16, color: AppTheme.gray400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskDetailsDialog extends ConsumerWidget {
  final TimeEntryWithProject entryWithProject;

  const _TaskDetailsDialog({required this.entryWithProject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: entryWithProject.project.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.space2),
          Expanded(
            child: Text(
              entryWithProject.timeEntry.taskName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            label: AppLocalizations.of(context).projects,
            value: entryWithProject.project.name,
            icon: Symbols.folder,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Duration', // TODO: Add l10n.duration
            value: TimeFormatter.formatDurationWords(
              entryWithProject.timeEntry.duration,
            ),
            icon: Symbols.timer,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Completed', // TODO: Add l10n.completed
            value: TimeFormatter.formatDateTime(
              entryWithProject.timeEntry.effectiveEndTime,
            ),
            icon: Symbols.schedule,
          ),
          if (entryWithProject.timeEntry.description.isNotEmpty) ...[
            const SizedBox(height: AppTheme.space3),
            _DetailRow(
              label: 'Description', // TODO: Add l10n.description
              value: entryWithProject.timeEntry.description,
              icon: Symbols.description,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).close),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _startSimilarTask(ref, entryWithProject);
          },
          child: Text(AppLocalizations.of(context).startSimilarTask),
        ),
      ],
    );
  }

  /// Start a similar task with timer conflict handling
  Future<void> _startSimilarTask(
    WidgetRef ref,
    TimeEntryWithProject entryWithProject,
  ) async {
    final timer = ref.read(timerProvider.notifier);
    final currentTimer = ref.read(timerProvider);

    try {
      // Check if there's already a timer running
      if (currentTimer.isActive) {
        // Stop the current timer first
        await timer.stop();
      }

      // Start the new timer with the same project and task name
      await timer.start(
        projectId: entryWithProject.timeEntry.projectId,
        taskName: entryWithProject.timeEntry.taskName,
      );
    } catch (e) {
      // Handle any errors that might occur
      debugPrint('Error starting similar task: $e');
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.gray600),
        const SizedBox(width: AppTheme.space2),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.gray600,
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
