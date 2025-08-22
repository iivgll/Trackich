import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/models/project.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../projects/create_project_dialog.dart';

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final timer = ref.watch(timerProvider);
    final recentProjects = ref.watch(recentProjectsProvider);

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
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppTheme.space2),
                Text(
                  'Focus Timer',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                          ? AppTheme.successGreen.withOpacity(0.1)
                          : AppTheme.warningAmber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(
                        color: timer.state == TimerState.running
                            ? AppTheme.successGreen
                            : AppTheme.warningAmber,
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
                              : AppTheme.warningAmber,
                        ),
                        const SizedBox(width: AppTheme.space1),
                        Text(
                          timer.state == TimerState.running ? 'Running' : 'Paused',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: timer.state == TimerState.running
                                ? AppTheme.successGreen
                                : AppTheme.warningAmber,
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
                      ? AppTheme.gray50
                      : AppTheme.gray800,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                  border: Border.all(
                    color: timer.isActive && timer.state == TimerState.running
                        ? AppTheme.focusPurple.withOpacity(0.3)
                        : Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: AppTheme.animationMedium,
                  style: AppTheme.timerLarge(context).copyWith(
                    color: timer.isActive && timer.state == TimerState.running
                        ? AppTheme.focusPurple
                        : Theme.of(context).textTheme.displayLarge?.color,
                  ),
                  child: Text(
                    TimeFormatter.formatDuration(timer.elapsed),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.space6),
            
            // Project Selector
            _buildProjectSelector(l10n, recentProjects),
            
            const SizedBox(height: AppTheme.space4),
            
            // Task Input
            _buildTaskInput(l10n),
            
            const SizedBox(height: AppTheme.space6),
            
            // Control Buttons
            _buildControlButtons(l10n, timer),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelector(AppLocalizations l10n, AsyncValue<List<Project>> recentProjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppTheme.space2),
        recentProjects.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyProjectsState(l10n);
            }
            
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: DropdownButton<String>(
                value: _selectedProjectId,
                hint: Text(
                  l10n.selectProject,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                isExpanded: true,
                underline: Container(),
                items: [
                  ...projects.map((project) => DropdownMenuItem<String>(
                    value: project.id,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: project.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppTheme.space3),
                        Expanded(
                          child: Text(
                            project.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const DropdownMenuItem(
                    value: 'create_new',
                    child: Row(
                      children: [
                        Icon(
                          Symbols.add,
                          size: 16,
                          color: AppTheme.primaryBlue,
                        ),
                        SizedBox(width: AppTheme.space3),
                        Text(
                          'Create New Project',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'create_new') {
                    _showCreateProjectDialog();
                  } else {
                    setState(() {
                      _selectedProjectId = value;
                    });
                    // Update timer project
                    if (value != null) {
                      ref.read(timerProvider.notifier).updateProject(value);
                    }
                  }
                },
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => Text(
            'Error loading projects',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task',
          style: Theme.of(context).textTheme.labelLarge,
        ),
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
                foregroundColor: AppTheme.errorRed,
                side: const BorderSide(color: AppTheme.errorRed),
                padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
              ),
            ),
          ),
        ],
        
        const SizedBox(width: AppTheme.space3),
        
        // Break Button
        IconButton(
          onPressed: () => _startBreak(),
          icon: const Icon(Symbols.coffee),
          tooltip: 'Take a break',
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.breakBlue.withOpacity(0.1),
            foregroundColor: AppTheme.breakBlue,
          ),
        ),
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
      return 'Resume Timer';
    }
    return l10n.startTimer;
  }

  Color _getMainButtonColor(CurrentTimer timer) {
    if (timer.canStart) {
      return AppTheme.successGreen;
    } else if (timer.canPause) {
      return AppTheme.warningAmber;
    } else if (timer.canResume) {
      return AppTheme.successGreen;
    }
    return AppTheme.primaryBlue;
  }

  bool _canStartTimer() {
    return _selectedProjectId != null && _taskController.text.trim().isNotEmpty;
  }

  void _startTimer() {
    if (!_canStartTimer()) return;
    
    ref.read(timerProvider.notifier).start(
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

  void _startBreak() {
    ref.read(timerProvider.notifier).startBreak();
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
          const Icon(
            Symbols.folder_off,
            size: 48,
            color: AppTheme.gray400,
          ),
          const SizedBox(height: AppTheme.space3),
          Text(
            'No Projects Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            'Create your first project to start tracking time',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space4),
          ElevatedButton.icon(
            onPressed: _showCreateProjectDialog,
            icon: const Icon(Symbols.add),
            label: Text(l10n.createProject),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
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
}