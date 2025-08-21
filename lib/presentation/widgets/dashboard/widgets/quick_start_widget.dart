import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../core/models/project.dart';

/// Widget for quickly starting a timer with recent tasks or projects
class QuickStartWidget extends ConsumerStatefulWidget {
  const QuickStartWidget({super.key});

  @override
  ConsumerState<QuickStartWidget> createState() => _QuickStartWidgetState();
}

class _QuickStartWidgetState extends ConsumerState<QuickStartWidget> {
  final _taskController = TextEditingController();
  String? _selectedProjectId;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timerState = ref.watch(timerNotifierProvider);
    final projects = ref.watch(activeProjectsProvider);
    final theme = Theme.of(context);

    // Don't show if timer is already active
    if (timerState.isActive) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.play_circle_outlined,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.quickStart,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Quick start form
            Row(
              children: [
                // Project selector
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: l10n.project,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    value: _selectedProjectId,
                    items: projects.map((project) {
                      return DropdownMenuItem(
                        value: project.id,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: project.color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                project.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProjectId = value;
                      });
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Task name input
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: l10n.taskName,
                      hintText: l10n.enterTaskName,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _startTimer(),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Start button
                ElevatedButton.icon(
                  onPressed: _canStartTimer() ? _startTimer : null,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.startTimer),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Recent tasks quick actions
            _buildRecentTasks(context, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTasks(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final timeEntries = ref.watch(timeEntriesProvider);
    
    // Get unique recent tasks (last 5)
    final recentTasks = timeEntries
        .where((entry) => !entry.isBreak)
        .toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
    
    final uniqueTasks = <String, MapEntry<String, String>>{};
    for (final entry in recentTasks) {
      final key = '${entry.projectId}_${entry.taskName}';
      if (!uniqueTasks.containsKey(key)) {
        uniqueTasks[key] = MapEntry(entry.projectId, entry.taskName);
      }
      if (uniqueTasks.length >= 5) break;
    }

    if (uniqueTasks.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: theme.dividerColor),
          const SizedBox(height: 12),
          Text(
            l10n.noRecentTasks,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: theme.dividerColor),
        const SizedBox(height: 12),
        Text(
          l10n.recentTasks,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: uniqueTasks.values.map((task) {
            return _buildQuickTaskChip(task.key, task.value, l10n);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickTaskChip(String projectId, String taskName, AppLocalizations l10n) {
    final projects = ref.watch(activeProjectsProvider);
    
    final project = projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => Project(
        id: projectId,
        name: 'Unknown Project',
        description: '',
        color: Colors.grey,
        createdAt: DateTime.now(),
      ),
    );
    
    return ActionChip(
      avatar: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: project.color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      label: Text(taskName),
      onPressed: () {
        setState(() {
          _selectedProjectId = projectId;
          _taskController.text = taskName;
        });
        _startTimer();
      },
      tooltip: '${project.name}: $taskName',
    );
  }

  bool _canStartTimer() {
    return _selectedProjectId != null && 
           _selectedProjectId!.isNotEmpty && 
           _taskController.text.trim().isNotEmpty;
  }

  void _startTimer() {
    if (!_canStartTimer()) return;
    
    ref.read(timerNotifierProvider.notifier).startTimer(
      projectId: _selectedProjectId!,
      taskName: _taskController.text.trim(),
    );
    
    // Clear the form
    setState(() {
      _taskController.clear();
      _selectedProjectId = null;
    });
  }
}