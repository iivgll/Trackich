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

part 'enhanced_recent_tasks_widget.g.dart';

// Provider for filtered time entries with task grouping and accumulated time
@riverpod
Future<Map<String, List<TaskGroupWithProject>>> filteredTimeEntries(
    Ref ref, TaskFilterPeriod period) async {
  final storage = ref.read(storageServiceProvider);
  final projects = await ref.watch(projectsProvider.future);
  final taskGroupSummaries = await storage.getTaskGroupSummaries();
  
  final now = DateTime.now();
  
  // Filter task groups based on last activity date
  final filteredGroups = taskGroupSummaries.values.where((group) {
    switch (period) {
      case TaskFilterPeriod.today:
        return group.lastActivity.day == now.day &&
               group.lastActivity.month == now.month &&
               group.lastActivity.year == now.year;
      case TaskFilterPeriod.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        return group.lastActivity.isAfter(weekAgo);
      case TaskFilterPeriod.month:
        final monthAgo = now.subtract(const Duration(days: 30));
        return group.lastActivity.isAfter(monthAgo);
      case TaskFilterPeriod.all:
        return true;
    }
  }).toList();
  
  // Sort by last activity (newest first)
  filteredGroups.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
  
  // Group by date for display
  final grouped = <String, List<TaskGroupWithProject>>{};
  
  for (final group in filteredGroups) {
    try {
      final project = projects.firstWhere((p) => p.id == group.projectId);
      final groupWithProject = TaskGroupWithProject(group, project);
      
      final dateKey = _formatDateKey(group.lastActivity);
      grouped.putIfAbsent(dateKey, () => []).add(groupWithProject);
    } catch (e) {
      // Skip groups with deleted projects
    }
  }
  
  return grouped;
}

String _formatDateKey(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final entryDate = DateTime(date.year, date.month, date.day);
  
  if (entryDate == today) {
    return 'Today';
  } else if (entryDate == yesterday) {
    return 'Yesterday';
  } else if (now.difference(entryDate).inDays < 7) {
    return TimeFormatter.formatDayOfWeek(date);
  } else {
    return TimeFormatter.formatDate(date);
  }
}

enum TaskFilterPeriod { today, week, month, all }

class TaskGroupWithProject {
  final TaskGroupSummary taskGroup;
  final dynamic project;
  
  TaskGroupWithProject(this.taskGroup, this.project);
}

class TimeEntryWithProject {
  final TimeEntry timeEntry;
  final dynamic project;
  
  TimeEntryWithProject(this.timeEntry, this.project);
}

// Filter state provider
final taskFilterPeriodProvider = StateProvider<TaskFilterPeriod>((ref) => TaskFilterPeriod.week);

class EnhancedRecentTasksWidget extends ConsumerWidget {
  const EnhancedRecentTasksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(taskFilterPeriodProvider);
    final filteredTasksAsync = ref.watch(filteredTimeEntriesProvider(period));

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with YouTube-style design
          _buildHeader(context, ref, period),
          
          // Tasks List with date grouping
          SizedBox(
            height: 400, // Increased height for better content display
            child: filteredTasksAsync.when(
              data: (groupedTasks) => groupedTasks.isEmpty 
                  ? _buildEmptyState(context, period)
                  : _buildGroupedTasksList(context, groupedTasks),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.calmBlue,
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.error_outline,
                      size: 48,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(height: AppTheme.space3),
                    Text(
                      'Error loading tasks',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.errorRed,
                      ),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref, TaskFilterPeriod period) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light 
                ? AppTheme.calmLightBorder 
                : AppTheme.falloutBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Symbols.history,
            size: 24,
            color: AppTheme.calmBlue,
          ),
          const SizedBox(width: AppTheme.space3),
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          
          // Enhanced Filter Dropdown (YouTube style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space3),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppTheme.calmLightSurfaceVariant 
                  : AppTheme.falloutSurfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light 
                    ? AppTheme.calmLightBorder 
                    : AppTheme.falloutBorder,
              ),
            ),
            child: DropdownButton<TaskFilterPeriod>(
              value: period,
              underline: const SizedBox(),
              icon: const Icon(Symbols.arrow_drop_down, size: 20),
              items:  [
                DropdownMenuItem(
                  value: TaskFilterPeriod.today,
                  child: Text(AppLocalizations.of(context).today),
                ),
                DropdownMenuItem(
                  value: TaskFilterPeriod.week,
                  child: Text(AppLocalizations.of(context).thisWeek),
                ),
                DropdownMenuItem(
                  value: TaskFilterPeriod.month,
                  child: Text(AppLocalizations.of(context).thisMonth),
                ),
                DropdownMenuItem(
                  value: TaskFilterPeriod.all,
                  child: Text(AppLocalizations.of(context).allTime),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(taskFilterPeriodProvider.notifier).state = value;
                }
              },
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedTasksList(BuildContext context, Map<String, List<TaskGroupWithProject>> groupedTasks) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groupedTasks.length,
      itemBuilder: (context, index) {
        final entry = groupedTasks.entries.toList()[index];
        final dateKey = entry.key;
        final tasks = entry.value;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header (YouTube style)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space6,
                vertical: AppTheme.space3,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light 
                    ? AppTheme.calmLightSurfaceVariant 
                    : AppTheme.falloutSurfaceVariant,
              ),
              child: Row(
                children: [
                  Text(
                    dateKey,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light 
                          ? AppTheme.calmLightTextSecondary 
                          : AppTheme.falloutTextSecondary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.calmBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.calmBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tasks for this date
            ...tasks.map((taskGroupWithProject) => _TaskGroupItem(
              taskGroupWithProject: taskGroupWithProject,
              onTap: () => _onTaskGroupTap(context, taskGroupWithProject),
            )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, TaskFilterPeriod period) {
    String message;
    String subtitle;
    
    switch (period) {
      case TaskFilterPeriod.today:
        message = 'No tasks today';
        subtitle = 'Start a timer to track your work';
        break;
      case TaskFilterPeriod.week:
        message = 'No tasks this week';
        subtitle = 'Your recent activity will appear here';
        break;
      case TaskFilterPeriod.month:
        message = 'No tasks this month';
        subtitle = 'Your monthly activity will appear here';
        break;
      case TaskFilterPeriod.all:
        message = 'No tasks found';
        subtitle = 'Start tracking time to see your activity';
        break;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.task_alt,
            size: 64,
            color: Theme.of(context).brightness == Brightness.light 
                ? AppTheme.calmLightTextTertiary 
                : AppTheme.falloutTextTertiary,
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppTheme.calmLightTextSecondary 
                  : AppTheme.falloutTextSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppTheme.calmLightTextTertiary 
                  : AppTheme.falloutTextTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onTaskGroupTap(BuildContext context, TaskGroupWithProject taskGroupWithProject) {
    showDialog(
      context: context,
      builder: (context) => _TaskGroupDetailsDialog(taskGroupWithProject: taskGroupWithProject),
    );
  }
}

class _TaskGroupItem extends StatelessWidget {
  final TaskGroupWithProject taskGroupWithProject;
  final VoidCallback onTap;

  const _TaskGroupItem({
    required this.taskGroupWithProject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.space4,
          horizontal: AppTheme.space6,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppTheme.calmLightBorder 
                  : AppTheme.falloutBorder,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Project color indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: taskGroupWithProject.project.color,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
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
                      Expanded(
                        child: Text(
                          taskGroupWithProject.taskGroup.taskName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (taskGroupWithProject.taskGroup.sessionCount > 1) ...[
                        Container(
                          margin: const EdgeInsets.only(left: AppTheme.space2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.focusPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            '${taskGroupWithProject.taskGroup.sessionCount}x',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.focusPurple,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppTheme.space1),
                  Row(
                    children: [
                      Text(
                        taskGroupWithProject.project.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: taskGroupWithProject.project.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light 
                              ? AppTheme.calmLightTextTertiary 
                              : AppTheme.falloutTextTertiary,
                        ),
                      ),
                      Text(
                        'Last: ${TimeFormatter.formatTime(taskGroupWithProject.taskGroup.lastActivity)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light 
                              ? AppTheme.calmLightTextSecondary 
                              : AppTheme.falloutTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Total accumulated duration
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light 
                    ? AppTheme.calmLightSurfaceVariant 
                    : AppTheme.falloutSurfaceVariant,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Text(
                TimeFormatter.formatDurationWords(taskGroupWithProject.taskGroup.totalTime),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light 
                      ? AppTheme.calmLightTextSecondary 
                      : AppTheme.falloutTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskGroupDetailsDialog extends ConsumerWidget {
  final TaskGroupWithProject taskGroupWithProject;

  const _TaskGroupDetailsDialog({required this.taskGroupWithProject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.calmWhite 
          : AppTheme.falloutSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      title: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: taskGroupWithProject.project.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Text(
              taskGroupWithProject.taskGroup.taskName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            label: 'Project',
            value: taskGroupWithProject.project.name,
            icon: Symbols.folder,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Total Time',
            value: TimeFormatter.formatDurationWords(taskGroupWithProject.taskGroup.totalTime),
            icon: Symbols.timer,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Sessions',
            value: '${taskGroupWithProject.taskGroup.sessionCount} work sessions',
            icon: Symbols.repeat,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Last Activity',
            value: TimeFormatter.formatDateTime(taskGroupWithProject.taskGroup.lastActivity),
            icon: Symbols.schedule,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Average per Session',
            value: TimeFormatter.formatDurationWords(
              Duration(
                milliseconds: taskGroupWithProject.taskGroup.totalTime.inMilliseconds ~/
                    taskGroupWithProject.taskGroup.sessionCount,
              ),
            ),
            icon: Symbols.analytics,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).close),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.calmBlue,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await _continueTask(ref, taskGroupWithProject);
          },
          child: Text(AppLocalizations.of(context).continueTask),
        ),
      ],
    );
  }

  /// Continue the task with accumulated time
  Future<void> _continueTask(WidgetRef ref, TaskGroupWithProject taskGroupWithProject) async {
    final timer = ref.read(timerProvider.notifier);
    final currentTimer = ref.read(timerProvider);
    
    try {
      // Check if there's already a timer running
      if (currentTimer.isActive) {
        // Stop the current timer first
        await timer.stop();
      }
      
      // Start the timer - it will automatically continue with accumulated time
      await timer.start(
        projectId: taskGroupWithProject.taskGroup.projectId,
        taskName: taskGroupWithProject.taskGroup.taskName,
      );
      
    } catch (e) {
      // Handle any errors that might occur
      debugPrint('Error continuing task: $e');
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).brightness == Brightness.light 
              ? AppTheme.calmLightTextSecondary 
              : AppTheme.falloutTextSecondary,
        ),
        const SizedBox(width: AppTheme.space2),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.light 
                ? AppTheme.calmLightTextSecondary 
                : AppTheme.falloutTextSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}