import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/models/time_entry.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../features/projects/providers/projects_provider.dart';

part 'enhanced_recent_tasks_widget.g.dart';

// Provider for filtered time entries with enhanced grouping
@riverpod
Future<Map<String, List<TimeEntryWithProject>>> filteredTimeEntries(
    Ref ref, TaskFilterPeriod period) async {
  final storage = ref.read(storageServiceProvider);
  final projects = await ref.watch(projectsProvider.future);
  final entries = await storage.getTimeEntries();
  
  final now = DateTime.now();
  final filteredEntries = entries.where((entry) {
    if (!entry.isCompleted || entry.isBreak) return false;
    
    switch (period) {
      case TaskFilterPeriod.today:
        return entry.effectiveEndTime.day == now.day &&
               entry.effectiveEndTime.month == now.month &&
               entry.effectiveEndTime.year == now.year;
      case TaskFilterPeriod.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        return entry.effectiveEndTime.isAfter(weekAgo);
      case TaskFilterPeriod.month:
        final monthAgo = now.subtract(const Duration(days: 30));
        return entry.effectiveEndTime.isAfter(monthAgo);
      case TaskFilterPeriod.all:
        return true;
    }
  }).toList();
  
  // Sort by end time (newest first)
  filteredEntries.sort((a, b) => b.effectiveEndTime.compareTo(a.effectiveEndTime));
  
  // Group by date
  final grouped = <String, List<TimeEntryWithProject>>{};
  
  for (final entry in filteredEntries) {
    try {
      final project = projects.firstWhere((p) => p.id == entry.projectId);
      final entryWithProject = TimeEntryWithProject(entry, project);
      
      final dateKey = _formatDateKey(entry.effectiveEndTime);
      grouped.putIfAbsent(dateKey, () => []).add(entryWithProject);
    } catch (e) {
      // Skip entries with deleted projects
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
            ? AppTheme.youtubeLightBg 
            : AppTheme.youtubeDarkSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Theme.of(context).brightness == Brightness.light 
            ? Border.all(color: AppTheme.youtubeLightBorder, width: 1)
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
                  color: AppTheme.youtubeRed,
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
                ? AppTheme.youtubeLightBorder 
                : AppTheme.youtubeDarkBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Symbols.history,
            size: 24,
            color: AppTheme.youtubeRed,
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
                  ? AppTheme.youtubeLightSurfaceVariant 
                  : AppTheme.youtubeDarkSurfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light 
                    ? AppTheme.youtubeLightBorder 
                    : AppTheme.youtubeDarkBorder,
              ),
            ),
            child: DropdownButton<TaskFilterPeriod>(
              value: period,
              underline: const SizedBox(),
              icon: const Icon(Symbols.arrow_drop_down, size: 20),
              items: const [
                DropdownMenuItem(
                  value: TaskFilterPeriod.today,
                  child: Text('Today'),
                ),
                DropdownMenuItem(
                  value: TaskFilterPeriod.week,
                  child: Text('This Week'),
                ),
                DropdownMenuItem(
                  value: TaskFilterPeriod.month,
                  child: Text('This Month'),
                ),
                DropdownMenuItem(
                  value: TaskFilterPeriod.all,
                  child: Text('All Time'),
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

  Widget _buildGroupedTasksList(BuildContext context, Map<String, List<TimeEntryWithProject>> groupedTasks) {
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
                    ? AppTheme.youtubeLightSurfaceVariant 
                    : AppTheme.youtubeDarkSurfaceVariant,
              ),
              child: Row(
                children: [
                  Text(
                    dateKey,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light 
                          ? AppTheme.youtubeLightTextSecondary 
                          : AppTheme.youtubeDarkTextSecondary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.youtubeRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.youtubeRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tasks for this date
            ...tasks.map((entryWithProject) => _TaskItem(
              entryWithProject: entryWithProject,
              onTap: () => _onTaskTap(context, entryWithProject),
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
                ? AppTheme.youtubeLightTextTertiary 
                : AppTheme.youtubeDarkTextTertiary,
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppTheme.youtubeLightTextSecondary 
                  : AppTheme.youtubeDarkTextSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppTheme.youtubeLightTextTertiary 
                  : AppTheme.youtubeDarkTextTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onTaskTap(BuildContext context, TimeEntryWithProject entryWithProject) {
    showDialog(
      context: context,
      builder: (context) => _TaskDetailsDialog(entryWithProject: entryWithProject),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TimeEntryWithProject entryWithProject;
  final VoidCallback onTap;

  const _TaskItem({
    required this.entryWithProject,
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
                  ? AppTheme.youtubeLightBorder 
                  : AppTheme.youtubeDarkBorder,
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
                color: entryWithProject.project.color,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            
            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entryWithProject.timeEntry.taskName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
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
                          color: Theme.of(context).brightness == Brightness.light 
                              ? AppTheme.youtubeLightTextTertiary 
                              : AppTheme.youtubeDarkTextTertiary,
                        ),
                      ),
                      Text(
                        TimeFormatter.formatTime(entryWithProject.timeEntry.effectiveEndTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light 
                              ? AppTheme.youtubeLightTextSecondary 
                              : AppTheme.youtubeDarkTextSecondary,
                        ),
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
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light 
                    ? AppTheme.youtubeLightSurfaceVariant 
                    : AppTheme.youtubeDarkSurfaceVariant,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Text(
                TimeFormatter.formatDurationWords(entryWithProject.timeEntry.duration),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light 
                      ? AppTheme.youtubeLightTextSecondary 
                      : AppTheme.youtubeDarkTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskDetailsDialog extends StatelessWidget {
  final TimeEntryWithProject entryWithProject;

  const _TaskDetailsDialog({required this.entryWithProject});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.youtubeLightBg 
          : AppTheme.youtubeDarkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      title: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: entryWithProject.project.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Text(
              entryWithProject.timeEntry.taskName,
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
            value: entryWithProject.project.name,
            icon: Symbols.folder,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Duration',
            value: TimeFormatter.formatDurationWords(entryWithProject.timeEntry.duration),
            icon: Symbols.timer,
          ),
          const SizedBox(height: AppTheme.space3),
          _DetailRow(
            label: 'Completed',
            value: TimeFormatter.formatDateTime(entryWithProject.timeEntry.effectiveEndTime),
            icon: Symbols.schedule,
          ),
          if (entryWithProject.timeEntry.description.isNotEmpty) ...[
            const SizedBox(height: AppTheme.space3),
            _DetailRow(
              label: 'Description',
              value: entryWithProject.timeEntry.description,
              icon: Symbols.description,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.youtubeRed,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            // TODO: Start timer with this task
          },
          child: const Text('Start Similar Task'),
        ),
      ],
    );
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
              ? AppTheme.youtubeLightTextSecondary 
              : AppTheme.youtubeDarkTextSecondary,
        ),
        const SizedBox(width: AppTheme.space2),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.light 
                ? AppTheme.youtubeLightTextSecondary 
                : AppTheme.youtubeDarkTextSecondary,
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