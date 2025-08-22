import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/time_entry.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../features/projects/providers/projects_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

// Providers for filtered results page
final filteredResultsProvider = FutureProvider.family<Map<DateTime, List<TimeEntry>>, FilterParams>((ref, params) async {
  final storage = ref.read(storageServiceProvider);
  final allEntries = await storage.getTimeEntries();
  
  // Filter by completion status
  var filteredEntries = allEntries.where((entry) => entry.isCompleted).toList();
  
  // Filter by project if selected
  if (params.projectId != null) {
    filteredEntries = filteredEntries.where((entry) => entry.projectId == params.projectId).toList();
  }
  
  // Filter by date range if selected
  if (params.dateRange != null) {
    filteredEntries = filteredEntries.where((entry) {
      final entryDate = DateTime(entry.startTime.year, entry.startTime.month, entry.startTime.day);
      final startDate = DateTime(params.dateRange!.start.year, params.dateRange!.start.month, params.dateRange!.start.day);
      final endDate = DateTime(params.dateRange!.end.year, params.dateRange!.end.month, params.dateRange!.end.day);
      return entryDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
             entryDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
  
  // Group by date
  final entriesByDate = <DateTime, List<TimeEntry>>{};
  for (final entry in filteredEntries) {
    final entryDate = DateTime(entry.startTime.year, entry.startTime.month, entry.startTime.day);
    if (entriesByDate[entryDate] == null) {
      entriesByDate[entryDate] = [];
    }
    entriesByDate[entryDate]!.add(entry);
  }
  
  return entriesByDate;
});

// Filter parameters class
class FilterParams {
  final String? projectId;
  final DateTimeRange? dateRange;

  const FilterParams({
    this.projectId,
    this.dateRange,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterParams &&
        other.projectId == projectId &&
        other.dateRange == dateRange;
  }

  @override
  int get hashCode => Object.hash(projectId, dateRange);
}

class FilteredResultsScreen extends ConsumerWidget {
  final String? projectId;
  final DateTimeRange? dateRange;

  const FilteredResultsScreen({
    super.key,
    this.projectId,
    this.dateRange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filterParams = FilterParams(projectId: projectId, dateRange: dateRange);
    final filteredResultsAsync = ref.watch(filteredResultsProvider(filterParams));

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.gray50 
          : AppTheme.gray900,
      body: Column(
        children: [
          // Header
          _buildHeader(context, l10n),
          
          // Content
          Expanded(
            child: filteredResultsAsync.when(
              data: (entriesByDate) => _buildContent(context, ref, entriesByDate),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(context, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Symbols.arrow_back),
            tooltip: 'Back to Calendar',
          ),
          const SizedBox(width: AppTheme.space4),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtered Results',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.space1),
                Consumer(
                  builder: (context, ref, child) {
                    final projectsAsync = ref.watch(projectsProvider);
                    return projectsAsync.when(
                      data: (projects) {
                        return Text(
                          _getFilterDescription(projects),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.gray600,
                          ),
                        );
                      },
                      loading: () => Text(
                        _getFilterDescriptionWithoutProject(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                      error: (_, __) => Text(
                        _getFilterDescriptionWithoutProject(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Filter indicators
          if (projectId != null || dateRange != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Symbols.filter_list,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: AppTheme.space1),
                  const Text(
                    'Filtered',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Map<DateTime, List<TimeEntry>> entriesByDate) {
    if (entriesByDate.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    // Generate date range for empty state placeholders
    final dateRange = _getDateRangeForPlaceholders(entriesByDate);
    final allDates = <DateTime>[];
    
    if (dateRange != null) {
      DateTime current = dateRange.start;
      while (current.isBefore(dateRange.end.add(const Duration(days: 1)))) {
        allDates.add(current);
        current = current.add(const Duration(days: 1));
      }
    } else {
      // If no date range filter, only show dates with entries
      allDates.addAll(entriesByDate.keys);
    }

    // Sort dates in descending order (most recent first)
    allDates.sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.space6),
      itemCount: allDates.length,
      itemBuilder: (context, index) {
        final date = allDates[index];
        final dayEntries = entriesByDate[date] ?? [];
        
        return FilteredResultsDayGroup(
          date: date,
          entries: dayEntries,
          showEmptyState: dayEntries.isEmpty,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Symbols.search_off,
            size: 80,
            color: AppTheme.gray400,
          ),
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
            _getEmptyStateMessage(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space6),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Symbols.arrow_back),
            label: const Text('Back to Calendar'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space6),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Symbols.arrow_back),
            label: const Text('Back to Calendar'),
          ),
        ],
      ),
    );
  }

  DateTimeRange? _getDateRangeForPlaceholders(Map<DateTime, List<TimeEntry>> entriesByDate) {
    // Only show placeholders if we have a date range filter
    return dateRange;
  }

  String _getFilterDescription(List<dynamic> projects) {
    final parts = <String>[];
    
    if (projectId != null && projects.isNotEmpty) {
      try {
        final project = projects.firstWhere(
          (p) => p.id == projectId,
          orElse: () => null,
        );
        if (project != null) {
          parts.add('project "${project.name}"');
        } else {
          parts.add('selected project');
        }
      } catch (e) {
        parts.add('selected project');
      }
    }
    
    if (dateRange != null) {
      parts.add('${TimeFormatter.formatDate(dateRange!.start)} - ${TimeFormatter.formatDate(dateRange!.end)}');
    }
    
    if (parts.isEmpty) {
      return 'Showing all completed tasks';
    }
    
    return 'Filtered by ${parts.join(' and ')}';
  }

  String _getFilterDescriptionWithoutProject() {
    final parts = <String>[];
    
    if (projectId != null) {
      parts.add('selected project');
    }
    
    if (dateRange != null) {
      parts.add('${TimeFormatter.formatDate(dateRange!.start)} - ${TimeFormatter.formatDate(dateRange!.end)}');
    }
    
    if (parts.isEmpty) {
      return 'Showing all completed tasks';
    }
    
    return 'Filtered by ${parts.join(' and ')}';
  }

  String _getEmptyStateMessage() {
    if (projectId != null && dateRange != null) {
      return 'No completed tasks found for the selected project and date range.\nTry adjusting your filters.';
    } else if (projectId != null) {
      return 'No completed tasks found for the selected project.\nTry selecting a different project.';
    } else if (dateRange != null) {
      return 'No completed tasks found in the selected date range.\nTry expanding your date range.';
    } else {
      return 'No completed tasks found.\nStart tracking some work!';
    }
  }
}

// Day Group Widget for Filtered Results
class FilteredResultsDayGroup extends ConsumerWidget {
  final DateTime date;
  final List<TimeEntry> entries;
  final bool showEmptyState;

  const FilteredResultsDayGroup({
    super.key,
    required this.date,
    required this.entries,
    required this.showEmptyState,
  });

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
              : showEmptyState
                  ? AppTheme.gray300.withOpacity(0.5)
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
              color: showEmptyState
                  ? AppTheme.gray100.withOpacity(0.3)
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
            child: Row(
              children: [
                Icon(
                  showEmptyState 
                      ? Symbols.event_busy
                      : isToday 
                          ? Symbols.today 
                          : Symbols.calendar_today,
                  size: 20,
                  color: showEmptyState
                      ? AppTheme.gray400
                      : isToday 
                          ? AppTheme.successGreen 
                          : AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppTheme.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDateLabel(date, isToday, isYesterday),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: showEmptyState
                              ? AppTheme.gray500
                              : isToday 
                                  ? AppTheme.successGreen 
                                  : null,
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
                if (showEmptyState) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space3,
                      vertical: AppTheme.space1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.gray300.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Text(
                      'No tasks',
                      style: TextStyle(
                        color: AppTheme.gray500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else ...[
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
              ],
            ),
          ),
          
          // Tasks list or empty state
          if (showEmptyState) ...[
            Padding(
              padding: const EdgeInsets.all(AppTheme.space6),
              child: Row(
                children: [
                  Icon(
                    Symbols.event_busy,
                    size: 32,
                    color: AppTheme.gray400,
                  ),
                  const SizedBox(width: AppTheme.space3),
                  Expanded(
                    child: Text(
                      'No tasks completed on this day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.gray500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...entries.asMap().entries.map((entry) {
              final index = entry.key;
              final task = entry.value;
              final isLast = index == entries.length - 1;
              
              return Container(
                decoration: BoxDecoration(
                  border: !isLast ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
                    ),
                  ) : null,
                ),
                child: FilteredResultsTaskItem(entry: task),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
  
  String _getDateLabel(DateTime date, bool isToday, bool isYesterday) {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  }
  
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
  
  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
}

// Task Item Widget for Filtered Results
class FilteredResultsTaskItem extends ConsumerWidget {
  final TimeEntry entry;

  const FilteredResultsTaskItem({super.key, required this.entry});

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
                          color: entry.isBreak ? AppTheme.breakBlue : project.color,
                        ),
                        const SizedBox(width: AppTheme.space2),
                        Expanded(
                          child: Text(
                            entry.taskName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.gray600,
                          ),
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
                  color: (entry.isBreak ? AppTheme.breakBlue : project.color).withOpacity(0.1),
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
        child: const Center(child: Text('Error loading project')),
      ),
    );
  }
}