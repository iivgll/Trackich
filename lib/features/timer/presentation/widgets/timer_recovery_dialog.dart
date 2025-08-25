import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../projects/domain/models/project.dart';

class TimerRecoveryDialog extends ConsumerWidget {
  final String taskName;
  final Project project;
  final Duration recoveredDuration;
  final VoidCallback onAddTime;
  final VoidCallback onDiscardTime;

  const TimerRecoveryDialog({
    super.key,
    required this.taskName,
    required this.project,
    required this.recoveredDuration,
    required this.onAddTime,
    required this.onDiscardTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Symbols.restore,
            color: AppTheme.getWarningColor(context),
            size: 24,
          ),
          const SizedBox(width: AppTheme.space3),
          Text(l10n.timerRecoveryTitle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.timerRecoveryMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.space4),

          // Task info card
          Container(
            padding: const EdgeInsets.all(AppTheme.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: project.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: project.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space2),
                    Expanded(
                      child: Text(
                        l10n.timerRecoveryProject(project.name),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space2),

                // Task
                Text(
                  l10n.timerRecoveryTask(taskName),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.space2),

                // Duration
                Row(
                  children: [
                    Icon(
                      Symbols.schedule,
                      size: 16,
                      color: AppTheme.getWarningColor(context),
                    ),
                    const SizedBox(width: AppTheme.space2),
                    Text(
                      l10n.timerRecoveryDuration(
                        TimeFormatter.formatDuration(recoveredDuration),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getWarningColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDiscardTime();
          },
          child: Text(
            l10n.discardTime,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAddTime();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.addTimeToTask),
        ),
      ],
    );
  }
}
