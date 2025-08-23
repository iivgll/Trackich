import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/time_entry.dart';
import '../../../core/models/project.dart';
import '../../../core/services/excel_export_service.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../features/projects/providers/projects_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class FilteredResultsScreen extends ConsumerStatefulWidget {
  final String? projectId;
  final DateTimeRange? dateRange;
  final List<TimeEntry> filteredEntries;

  const FilteredResultsScreen({
    super.key,
    this.projectId,
    this.dateRange,
    required this.filteredEntries,
  });

  @override
  ConsumerState<FilteredResultsScreen> createState() => _FilteredResultsScreenState();
}

class _FilteredResultsScreenState extends ConsumerState<FilteredResultsScreen> {
  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    
    // Group entries by date
    final entriesByDate = <DateTime, List<TimeEntry>>{};
    for (final entry in widget.filteredEntries) {
      final date = DateTime(entry.startTime.year, entry.startTime.month, entry.startTime.day);
      entriesByDate.putIfAbsent(date, () => []).add(entry);
    }
    
    final sortedDates = entriesByDate.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.gray50 
          : AppTheme.gray900,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).filteredResults),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _exportToExcel(context),
            icon: const Icon(Symbols.file_download),
            tooltip: 'Export to Excel',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary header
          _buildSummaryHeader(),
          
          // Results list
          Expanded(
            child: widget.filteredEntries.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.space6),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final date = sortedDates[index];
                      final entries = entriesByDate[date]!;
                      return _buildDateGroup(date, entries, projectsAsync);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    final totalEntries = widget.filteredEntries.length;
    final totalDuration = widget.filteredEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + (entry.endTime?.difference(entry.startTime) ?? Duration.zero),
    );

    String filterInfo = '';
    if (widget.projectId != null || widget.dateRange != null) {
      final parts = <String>[];
      if (widget.projectId != null) {
        final projectsAsync = ref.read(projectsProvider);
        if (projectsAsync.hasValue) {
          final project = projectsAsync.value!.firstWhere(
            (p) => p.id == widget.projectId,
            orElse: () => Project(
              id: widget.projectId!, 
              name: 'Unknown', 
              color: const Color(0xFF007AFF),
              description: '',
              createdAt: DateTime.now(),
            ),
          );
          parts.add('Project: ${project.name}');
        }
      }
      if (widget.dateRange != null) {
        final start = widget.dateRange!.start;
        final end = widget.dateRange!.end;
        parts.add('${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}');
      }
      filterInfo = parts.join(' • ');
    }

    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filterInfo.isNotEmpty) ...[
            Text(
              'Filters: $filterInfo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.getPrimaryColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.space2),
          ],
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Symbols.task_alt,
                  label: 'Total Tasks',
                  value: totalEntries.toString(),
                ),
              ),
              const SizedBox(width: AppTheme.space4),
              Expanded(
                child: _SummaryCard(
                  icon: Symbols.schedule,
                  label: 'Total Time',
                  value: TimeFormatter.formatDuration(totalDuration),
                ),
              ),
              const SizedBox(width: AppTheme.space4),
              Expanded(
                child: _SummaryCard(
                  icon: Symbols.speed,
                  label: 'Avg per Task',
                  value: totalEntries > 0 
                      ? TimeFormatter.formatDuration(Duration(milliseconds: totalDuration.inMilliseconds ~/ totalEntries))
                      : '0m',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.search_off,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            'Try adjusting your filters or date range',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateGroup(DateTime date, List<TimeEntry> entries, AsyncValue<List<Project>> projectsAsync) {
    // Group entries by project + task combination
    final groupedEntries = <String, List<TimeEntry>>{};
    for (final entry in entries) {
      final taskName = entry.taskName.trim().isNotEmpty ? entry.taskName.trim() : 'Untitled Task';
      final key = '${entry.projectId}_$taskName';
      groupedEntries.putIfAbsent(key, () => []).add(entry);
    }
    
    final dayDuration = entries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + (entry.endTime?.difference(entry.startTime) ?? Duration.zero),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.space4),
            decoration: BoxDecoration(
              color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusLg),
                topRight: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.calendar_today,
                  size: 18,
                  color: AppTheme.getPrimaryColor(context),
                ),
                const SizedBox(width: AppTheme.space2),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.getPrimaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space3,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(
                    '${groupedEntries.length} unique tasks • ${TimeFormatter.formatDuration(dayDuration)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getSuccessColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Grouped entries list
          ...groupedEntries.entries.map((group) => _buildGroupedEntryTile(group.value, projectsAsync)),
        ],
      ),
    );
  }

  Widget _buildGroupedEntryTile(List<TimeEntry> entries, AsyncValue<List<Project>> projectsAsync) {
    final firstEntry = entries.first;
    Project? project;
    if (projectsAsync.hasValue) {
      try {
        project = projectsAsync.value!.firstWhere((p) => p.id == firstEntry.projectId);
      } catch (e) {
        // Project not found
      }
    }

    // Calculate total duration for this task
    final totalDuration = entries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + (entry.endTime?.difference(entry.startTime) ?? Duration.zero),
    );
    
    final isLongTask = totalDuration.inMinutes > 60;
    final sessionCount = entries.length;
    
    // Get time range for this task
    final allTimes = entries.where((e) => e.endTime != null).toList();
    String timeInfo = '';
    if (allTimes.isNotEmpty) {
      final startTimes = allTimes.map((e) => e.startTime).toList()..sort();
      final endTimes = allTimes.map((e) => e.endTime!).toList()..sort();
      timeInfo = '${TimeFormatter.formatTime(startTimes.first)} - ${TimeFormatter.formatTime(endTimes.last)}';
      if (sessionCount > 1) {
        timeInfo += ' ($sessionCount sessions)';
      }
    } else {
      timeInfo = 'In Progress';
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Project color indicator
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: project?.color ?? AppTheme.getPrimaryColor(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppTheme.space3),
          
          // Entry details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project name
                Text(
                  project?.name ?? 'Unknown Project',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.space1),
                // Task name
                Text(
                  firstEntry.taskName.trim().isNotEmpty 
                      ? firstEntry.taskName.trim()
                      : 'Untitled Task',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Show description if available
                if (firstEntry.description.trim().isNotEmpty) ...[
                  const SizedBox(height: AppTheme.space1),
                  Text(
                    firstEntry.description.trim(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: AppTheme.space1),
                // Time info
                Text(
                  timeInfo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
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
              color: isLongTask 
                  ? AppTheme.getSuccessColor(context).withValues(alpha: 0.15)
                  : AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Column(
              children: [
                Text(
                  TimeFormatter.formatDuration(totalDuration),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isLongTask 
                        ? AppTheme.getSuccessColor(context)
                        : AppTheme.getPrimaryColor(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (sessionCount > 1)
                  Text(
                    '$sessionCount×',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLongTask 
                          ? AppTheme.getSuccessColor(context)
                          : AppTheme.getPrimaryColor(context),
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

  Future<void> _exportToExcel(BuildContext context) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).exportingToExcel),
          duration: Duration(seconds: 1),
        ),
      );
      
      // Get projects map
      final projectsAsync = ref.read(projectsProvider);
      final projects = <String, Project>{};
      
      if (projectsAsync.hasValue) {
        for (final project in projectsAsync.value!) {
          projects[project.id] = project;
        }
      }
      
      // Export to Excel
      final result = await ExcelExportService.exportTimeEntries(
        entries: widget.filteredEntries,
        projects: projects,
        dateRange: widget.dateRange,
      );
      
      // Handle result
      if (context.mounted) {
        if (result == 'cancelled') {
          // User cancelled - no message needed
          return;
        }
        
        // Show success message with file path
        final successMessage = result.isNotEmpty && result != 'File saved successfully'
            ? 'Excel report exported to:\n$result'
            : 'Excel report exported successfully!';
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            duration: const Duration(seconds: 5),
            backgroundColor: AppTheme.getSuccessColor(context),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).exportFailed(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space3),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.getPrimaryColor(context),
          ),
          const SizedBox(height: AppTheme.space1),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}