import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/models/time_entry.dart';

/// Widget showing the currently active task
class CurrentTaskWidget extends ConsumerWidget {
  const CurrentTaskWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final timerState = ref.watch(timerNotifierProvider);
    final theme = Theme.of(context);
    
    if (!timerState.isActive) {
      return const SizedBox.shrink();
    }
    
    final currentEntry = timerState.currentEntry!;
    final project = ref.watch(projectByIdProvider(currentEntry.projectId));
    final elapsed = timerState.elapsed;
    
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: project?.color ?? theme.colorScheme.primary,
              width: 4,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and task info
            Row(
              children: [
                // Status indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: timerState.isRunning
                        ? theme.timerActive
                        : theme.timerPaused,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Task name
                Expanded(
                  child: Text(
                    l10n.workingOn(currentEntry.taskName),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Project name
            if (project != null)
              Text(
                '${l10n.project}: ${project.name}',
                style: theme.textTheme.bodyMedium,
              ),
            
            const SizedBox(height: 16),
            
            // Timer and controls row
            Row(
              children: [
                // Started time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Started: ${TimeFormatter.formatTime(currentEntry.startTime)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: ${TimeFormatter.formatDuration(elapsed)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Timer display (large)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    TimeFormatter.formatDuration(elapsed),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Control buttons
            Row(
              children: [
                // Pause/Resume button
                ElevatedButton.icon(
                  onPressed: () {
                    if (timerState.isRunning) {
                      ref.read(timerNotifierProvider.notifier).pauseTimer();
                    } else {
                      ref.read(timerNotifierProvider.notifier).resumeTimer();
                    }
                  },
                  icon: Icon(
                    timerState.isRunning ? Icons.pause : Icons.play_arrow,
                  ),
                  label: Text(
                    timerState.isRunning ? l10n.pauseTask : l10n.resumeTask,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Stop button
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(timerNotifierProvider.notifier).stopTimer();
                  },
                  icon: const Icon(Icons.stop),
                  label: Text(l10n.stopTask),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Add note button
                TextButton.icon(
                  onPressed: () {
                    _showAddNoteDialog(context, ref, currentEntry.notes ?? '');
                  },
                  icon: const Icon(Icons.note_add),
                  label: Text(l10n.addNote),
                ),
                
                const Spacer(),
                
                // Break button
                ElevatedButton.icon(
                  onPressed: () {
                    _showBreakDialog(context, ref);
                  },
                  icon: const Icon(Icons.coffee),
                  label: Text(l10n.takeBreak),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.warning,
                    foregroundColor: theme.onWarning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref, String currentNote) {
    final controller = TextEditingController(text: currentNote);
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addNote),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Add a note to this task...',
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(timerNotifierProvider.notifier).addNote(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBreakDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.takeBreak),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.coffee),
              title: Text(l10n.shortBreak('5m')),
              onTap: () {
                ref.read(timerNotifierProvider.notifier).startBreak();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(l10n.longBreak('15m')),
              onTap: () {
                ref.read(timerNotifierProvider.notifier).startBreak(type: BreakType.long);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.pause),
              title: Text(l10n.justPause),
              onTap: () {
                ref.read(timerNotifierProvider.notifier).pauseTimer();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to access custom colors - simplified approach
extension AppColorsExtension on ThemeData {
  Color get timerActive => colorScheme.primary;
  Color get timerPaused => colorScheme.secondary;
  Color get warning => colorScheme.error;
  Color get onWarning => colorScheme.onError;
}