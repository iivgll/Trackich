import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/storage_service.dart' show TaskGroupSummary;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../timer/presentation/providers/timer_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../projects/domain/models/project.dart';
import '../../../projects/presentation/providers/projects_provider.dart';
import '../../../projects/presentation/widgets/create_project_dialog.dart';
import 'smart_project_selector.dart';

class TimerWidget extends ConsumerStatefulWidget {
  const TimerWidget({super.key});

  @override
  ConsumerState<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends ConsumerState<TimerWidget> {
  final _taskController = TextEditingController();
  String? _selectedProjectId;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize UI fields with current timer state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncUIWithTimerState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final timer = ref.watch(timerProvider);
    final allActiveProjects = ref.watch(activeProjectsProvider);

    // Listen for timer state changes and sync UI fields
    ref.listen<CurrentTimer>(timerProvider, (previous, next) {
      if (previous != next) {
        _syncUIWithTimerState();
      }
    });

    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Symbols.timer,
                  size: 24,
                  color: AppTheme.getPrimaryColor(context),
                ),
                const SizedBox(width: AppTheme.space2),
                Text(
                  l10n.focusTimer,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (timer.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space3,
                      vertical: AppTheme.space1,
                    ),
                    decoration: BoxDecoration(
                      color: timer.state == TimerState.running
                          ? AppTheme.successGreen.withValues(alpha: 0.1)
                          : AppTheme.getWarningColor(
                              context,
                            ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(
                        color: timer.state == TimerState.running
                            ? AppTheme.successGreen
                            : AppTheme.getWarningColor(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          timer.state == TimerState.running
                              ? Symbols.play_circle
                              : Symbols.pause_circle,
                          size: 16,
                          color: timer.state == TimerState.running
                              ? AppTheme.successGreen
                              : AppTheme.getWarningColor(context),
                        ),
                        const SizedBox(width: AppTheme.space1),
                        Text(
                          timer.state == TimerState.running
                              ? l10n.running
                              : l10n.paused,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: timer.state == TimerState.running
                                    ? AppTheme.successGreen
                                    : AppTheme.getWarningColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppTheme.space6),

            // Timer Display
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppTheme.space6),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.lightSurfaceSecondary
                      : AppTheme.darkSurfaceSecondary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                  border: timer.isActive && timer.state == TimerState.running
                      ? Border.all(
                          color: AppTheme.getPrimaryColor(
                            context,
                          ).withValues(alpha: 0.3),
                          width: 1.0,
                        )
                      : Border.all(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? AppTheme.lightSeparator
                              : AppTheme.darkSeparator,
                          width: 0.33,
                        ),
                ),
                child: Column(
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: AppTheme.animationMedium,
                      style: AppTheme.timerLarge(context).copyWith(
                        color:
                            timer.isActive && timer.state == TimerState.running
                            ? AppTheme.getAccentColor(context)
                            : Theme.of(context).textTheme.displayLarge?.color,
                      ),
                      child: Text(
                        TimeFormatter.formatDuration(timer.displayDuration),
                      ),
                    ),
                    if (timer.totalAccumulatedTime > Duration.zero) ...[
                      const SizedBox(height: AppTheme.space2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.space3,
                          vertical: AppTheme.space1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getAccentColor(
                            context,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusFull,
                          ),
                          border: Border.all(
                            color: AppTheme.getAccentColor(
                              context,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          l10n.previousSession(
                            TimeFormatter.formatDuration(
                              timer.totalAccumulatedTime,
                            ),
                            TimeFormatter.formatDuration(timer.elapsed),
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.getAccentColor(context),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.space6),

            // Project Selector
            Center(child: _buildProjectSelector(l10n, allActiveProjects)),

            const SizedBox(height: AppTheme.space4),

            // Task Input
            _buildTaskInput(l10n),

            // Task continuation indicator
            _buildTaskContinuationIndicator(),

            const SizedBox(height: AppTheme.space6),

            // Control Buttons
            _buildControlButtons(l10n, timer),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelector(
    AppLocalizations l10n,
    AsyncValue<List<Project>> recentProjects,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppTheme.space4),
        recentProjects.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyProjectsState(l10n);
            }

            // Check if selected project still exists in active projects
            // If not, clear the selection immediately
            String? validSelectedProjectId = _selectedProjectId;
            if (_selectedProjectId != null &&
                _selectedProjectId != 'break' &&
                _selectedProjectId != 'create_new' &&
                !projects.any((p) => p.id == _selectedProjectId)) {
              validSelectedProjectId = null;
              // Schedule update for next frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedProjectId = null;
                  });
                  // Also clear timer project
                  ref.read(timerProvider.notifier).clearProject();
                }
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick select recent projects
                _buildQuickSelectProjects(projects, validSelectedProjectId),

                const SizedBox(height: AppTheme.space3),

                // Main project selector
                SmartProjectSelector(
                  selectedProjectId: validSelectedProjectId == 'break'
                      ? null
                      : validSelectedProjectId,
                  projects: projects,
                  onProjectSelected: (value) {
                    setState(() {
                      _selectedProjectId = value;
                    });
                    // Update timer project
                    if (value != null) {
                      ref.read(timerProvider.notifier).updateProject(value);
                    }
                  },
                  onCreateNew: _showCreateProjectDialog,
                ),

                // Top frequent tasks for selected project
                if (validSelectedProjectId != null &&
                    validSelectedProjectId != 'break')
                  _buildTopTasksSuggestions(validSelectedProjectId),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => Text(
            l10n.errorLoadingProjects,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSelectProjects(List<Project> allProjects, String? currentSelectedId) {
    // Get recent project IDs
    final recentProjectIdsAsync = ref.watch(recentProjectIdsProvider);

    return recentProjectIdsAsync.when(
      data: (recentIds) {
        // Get up to 3 most recent projects that exist in allProjects
        final recentProjects = recentIds
            .take(3)
            .map((id) {
              try {
                return allProjects.firstWhere((p) => p.id == id);
              } catch (e) {
                return null;
              }
            })
            .whereType<Project>()
            .toList();

        // Don't show if no recent projects
        if (recentProjects.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.space2),
              child: Text(
                'Quick Select',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.gray600,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentProjects.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppTheme.space2),
                itemBuilder: (context, index) {
                  final project = recentProjects[index];
                  final isSelected = currentSelectedId == project.id;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedProjectId = project.id;
                        });
                        ref.read(timerProvider.notifier).updateProject(project.id);
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.space4,
                          vertical: AppTheme.space2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? project.color.withValues(alpha: 0.15)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(
                            color: isSelected
                                ? project.color
                                : Theme.of(context).dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: project.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppTheme.space2),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 120),
                              child: Text(
                                project.name,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      color: isSelected ? project.color : null,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTopTasksSuggestions(String projectId) {
    final topTasksAsync = ref.watch(topTasksByProjectProvider(projectId));

    return topTasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: AppTheme.space3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.space2),
                child: Row(
                  children: [
                    Icon(
                      Symbols.trending_up,
                      size: 14,
                      color: AppTheme.gray500,
                    ),
                    const SizedBox(width: AppTheme.space1),
                    Text(
                      'Top Tasks',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.gray600,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: AppTheme.space2,
                runSpacing: AppTheme.space2,
                children: tasks.map((task) => _buildTaskChip(task)).toList(),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTaskChip(TaskGroupSummary task) {
    final isCurrentTask = _taskController.text.trim().toLowerCase() ==
        task.taskName.trim().toLowerCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _taskController.text = task.taskName;
          });
          ref.read(timerProvider.notifier).updateTaskName(task.taskName);
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space2,
          ),
          decoration: BoxDecoration(
            color: isCurrentTask
                ? AppTheme.primaryBlue.withValues(alpha: 0.15)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            border: Border.all(
              color: isCurrentTask
                  ? AppTheme.primaryBlue
                  : Theme.of(context).dividerColor,
              width: isCurrentTask ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  task.taskName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight:
                            isCurrentTask ? FontWeight.w700 : FontWeight.w500,
                        color: isCurrentTask ? AppTheme.primaryBlue : null,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: AppTheme.space1),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.gray200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${task.sessionCount}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.task, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppTheme.space2),
        TextFormField(
          controller: _taskController,
          decoration: InputDecoration(
            hintText: l10n.taskDescription,
            prefixIcon: const Icon(Symbols.task_alt),
          ),
          maxLines: 2,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            ref.read(timerProvider.notifier).updateTaskName(value);
          },
          onFieldSubmitted: (value) {
            if (_canStartTimer()) {
              _startTimer();
            }
          },
        ),
      ],
    );
  }

  Widget _buildControlButtons(AppLocalizations l10n, CurrentTimer timer) {
    return Row(
      children: [
        // Start/Pause/Resume Button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _getMainButtonAction(timer),
            icon: Icon(_getMainButtonIcon(timer)),
            label: Text(_getMainButtonText(l10n, timer)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getMainButtonColor(timer),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
            ),
          ),
        ),

        if (timer.canStop) ...[
          const SizedBox(width: AppTheme.space3),
          // Stop Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _stopTimer(),
              icon: const Icon(Symbols.stop),
              label: Text(l10n.stopTimer),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.getErrorColor(context),
                side: BorderSide(color: AppTheme.getErrorColor(context)),
                padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
              ),
            ),
          ),
        ],
      ],
    );
  }

  VoidCallback? _getMainButtonAction(CurrentTimer timer) {
    if (timer.canStart && _canStartTimer()) {
      return _startTimer;
    } else if (timer.canPause) {
      return _pauseTimer;
    } else if (timer.canResume) {
      return _resumeTimer;
    }
    return null;
  }

  IconData _getMainButtonIcon(CurrentTimer timer) {
    if (timer.canStart) {
      return Symbols.play_arrow;
    } else if (timer.canPause) {
      return Symbols.pause;
    } else if (timer.canResume) {
      return Symbols.play_arrow;
    }
    return Symbols.play_arrow;
  }

  String _getMainButtonText(AppLocalizations l10n, CurrentTimer timer) {
    if (timer.canStart) {
      return l10n.startTimer;
    } else if (timer.canPause) {
      return l10n.pauseTimer;
    } else if (timer.canResume) {
      return l10n.resumeTimer;
    }
    return l10n.startTimer;
  }

  Color _getMainButtonColor(CurrentTimer timer) {
    if (timer.canStart) {
      return AppTheme.successGreen;
    } else if (timer.canPause) {
      return AppTheme.getWarningColor(context);
    } else if (timer.canResume) {
      return AppTheme.successGreen;
    }
    return AppTheme.getPrimaryColor(context);
  }

  bool _canStartTimer() {
    return _selectedProjectId != null && _taskController.text.trim().isNotEmpty;
  }

  void _startTimer() {
    if (!_canStartTimer()) return;

    ref
        .read(timerProvider.notifier)
        .start(
          projectId: _selectedProjectId!,
          taskName: _taskController.text.trim(),
        );
  }

  void _pauseTimer() {
    ref.read(timerProvider.notifier).pause();
  }

  void _resumeTimer() {
    ref.read(timerProvider.notifier).resume();
  }

  void _stopTimer() {
    ref.read(timerProvider.notifier).stop();
  }

  Widget _buildTaskContinuationIndicator() {
    if (_selectedProjectId == null || _taskController.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: ref
          .read(timerProvider.notifier)
          .taskExists(_selectedProjectId!, _taskController.text.trim()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final taskExists = snapshot.data!;

        if (!taskExists) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(top: AppTheme.space3),
          padding: const EdgeInsets.all(AppTheme.space3),
          decoration: BoxDecoration(
            color: AppTheme.getAccentColor(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.getAccentColor(context).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Symbols.history,
                size: 16,
                color: AppTheme.getAccentColor(context),
              ),
              const SizedBox(width: AppTheme.space2),
              Expanded(
                child: FutureBuilder<Duration>(
                  future: ref
                      .read(timerProvider.notifier)
                      .getTaskAccumulatedTime(
                        _selectedProjectId!,
                        _taskController.text.trim(),
                      ),
                  builder: (context, timeSnapshot) {
                    final l10n = AppLocalizations.of(context);
                    if (!timeSnapshot.hasData) {
                      return Text(
                        l10n.taskWillBeContinued,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getAccentColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }

                    return Text(
                      l10n.continueTaskPreviousTime(
                        TimeFormatter.formatDurationWords(timeSnapshot.data!),
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getAccentColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyProjectsState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: Theme.of(context).brightness == Brightness.light
            ? AppTheme.gray50
            : AppTheme.gray800,
      ),
      child: Column(
        children: [
          const Icon(Symbols.folder_off, size: 48, color: AppTheme.gray400),
          const SizedBox(height: AppTheme.space3),
          Text(
            l10n.noProjectsYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            l10n.createFirstProject,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.gray500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space4),
          ElevatedButton.icon(
            onPressed: _showCreateProjectDialog,
            icon: const Icon(Symbols.add),
            label: Text(l10n.createProject),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getPrimaryColor(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space4,
                vertical: AppTheme.space3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateProjectDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );

    if (result == true) {
      // Refresh projects and auto-select the newly created project
      final projects = await ref.refresh(recentProjectsProvider.future);
      if (projects.isNotEmpty) {
        setState(() {
          _selectedProjectId = projects.first.id;
        });
        ref.read(timerProvider.notifier).updateProject(projects.first.id);
      }
    }
  }

  /// Synchronize UI fields with current timer state
  void _syncUIWithTimerState() {
    final timer = ref.read(timerProvider);

    // Update UI fields to match timer state
    if (mounted) {
      setState(() {
        // Update selected project if it changed
        if (_selectedProjectId != timer.projectId) {
          _selectedProjectId = timer.projectId;
        }

        // Update task name if it changed and field is not currently focused
        // Only update if the field is not focused to avoid interrupting user typing
        final focusNode = FocusScope.of(context);
        final taskFieldHasFocus = focusNode.focusedChild != null;

        if (_taskController.text != timer.taskName && !taskFieldHasFocus) {
          _taskController.text = timer.taskName;
          // Move cursor to end of text
          _taskController.selection = TextSelection.fromPosition(
            TextPosition(offset: _taskController.text.length),
          );
        }
      });
    }
  }
}
