import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/models/time_entry.dart';

/// Widget showing recent completed tasks with ability to restart them
class RecentTasksWidget extends ConsumerWidget {
  const RecentTasksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final timeEntries = ref.watch(timeEntriesProvider);
    
    // Get recent completed tasks (last 10)
    final recentTasks = timeEntries
        .where((entry) => !entry.isBreak && entry.endTime != null)
        .toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
    
    final displayTasks = recentTasks.take(10).toList();

    if (displayTasks.isEmpty) {
      return _buildEmptyState(context, l10n, theme);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // List of recent tasks
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: displayTasks.length,
            itemBuilder: (context, index) {
              final task = displayTasks[index];
              return _buildTaskItem(context, ref, l10n, theme, task);
            },
          ),
        ),
        
        // View all tasks button
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // TODO: Navigate to full tasks list
          },
          child: Text(l10n.viewAllTasks),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noRecentTasks,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start working on tasks to see them here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
    TimeEntry task,
  ) {
    final project = ref.watch(projectByIdProvider(task.projectId));
    final duration = task.calculatedDuration;
    final relativeTime = TimeFormatter.getRelativeTime(task.startTime);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        
        // Project color indicator
        leading: Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(
            color: project?.color ?? Colors.grey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        // Task info
        title: Text(
          task.taskName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              project?.name ?? 'Unknown Project',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  TimeFormatter.formatDuration(duration),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  relativeTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (task.notes != null && task.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.note,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      task.notes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        
        // Actions
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick restart button
            IconButton(
              onPressed: () {
                _restartTask(ref, task);
              },
              icon: const Icon(Icons.replay),
              tooltip: 'Restart this task',
              iconSize: 20,
            ),
            
            // More options
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editTask(context, ref, task);
                    break;
                  case 'duplicate':
                    _duplicateTask(ref, task);
                    break;
                  case 'delete':
                    _deleteTask(context, ref, task);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.content_copy, size: 16),
                      SizedBox(width: 8),
                      Text('Duplicate'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: Icon(
                Icons.more_vert,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _restartTask(WidgetRef ref, TimeEntry task) {
    final timerState = ref.read(timerNotifierProvider);
    
    // Don't start if timer is already active
    if (timerState.isActive) {
      return;
    }
    
    ref.read(timerNotifierProvider.notifier).startTimer(
      projectId: task.projectId,
      taskName: task.taskName,
      notes: task.notes,
    );
  }

  void _editTask(BuildContext context, WidgetRef ref, TimeEntry task) {
    // TODO: Implement edit task dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit task functionality coming soon')),
    );
  }

  void _duplicateTask(WidgetRef ref, TimeEntry task) {
    final timerState = ref.read(timerNotifierProvider);
    
    // Don't start if timer is already active
    if (timerState.isActive) {
      return;
    }
    
    ref.read(timerNotifierProvider.notifier).startTimer(
      projectId: task.projectId,
      taskName: '${task.taskName} (Copy)',
      notes: task.notes,
    );
  }

  void _deleteTask(BuildContext context, WidgetRef ref, TimeEntry task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.taskName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timeEntriesProvider.notifier).deleteEntry(task.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}