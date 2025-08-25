import 'dart:io';
import 'dart:async' as dart;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackich/features/projects/presentation/providers/projects_provider.dart';
import 'package:trackich/features/projects/presentation/widgets/create_project_dialog.dart';
import 'package:trackich/features/timer/presentation/providers/timer_provider.dart';
import 'package:tray_manager/tray_manager.dart';

import '../../core/theme/app_theme.dart';

class SystemTrayService with TrayListener {
  static SystemTrayService? _instance;
  static SystemTrayService get instance => _instance ??= SystemTrayService._();

  SystemTrayService._();

  static WidgetRef? _ref;
  static BuildContext? _context;
  dart.Timer? _updateTimer;

  static void initialize() {
    instance._init();
  }

  static void setContext(BuildContext context, WidgetRef ref) {
    _context = context;
    _ref = ref;
  }

  void _init() async {
    try {
      // Add listener first
      trayManager.addListener(this);

      // Set system tray icon with proper path for macOS
      String iconPath;
      if (Platform.isMacOS) {
        iconPath = 'assets/images/tray_icon_macos.png';
      } else if (Platform.isWindows) {
        iconPath = 'assets/images/tray_icon.png';
      } else {
        iconPath = 'assets/images/tray_icon.png';
      }

      await trayManager.setIcon(iconPath);

      // Set initial tooltip
      await _updateTrayTooltip();

      // Create initial menu
      await _updateTrayMenu();

      // Start periodic updates for timer display
      _startPeriodicUpdates();

      debugPrint('System tray initialized successfully');
    } catch (e) {
      // Handle tray initialization errors gracefully
      debugPrint('System tray initialization failed: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _updateTrayMenu() async {
    final isTimerRunning = _isTimerRunning();
    final isTimerActive = _isTimerActive();
    final timerDisplay = _getTimerDisplay();

    final menu = Menu(
      items: [
        MenuItem(key: 'show_app', label: 'Show Trackich'),
        MenuItem.separator(),
        // Timer display section
        MenuItem(
          key: 'timer_display',
          label: timerDisplay.isNotEmpty ? timerDisplay : 'No active timer',
          disabled: true,
        ),
        MenuItem.separator(),
        // Quick action buttons
        MenuItem(
          key: 'start_stop_toggle',
          label: isTimerRunning
              ? 'Stop Timer'
              : (isTimerActive ? 'Resume Timer' : 'Start Timer'),
          disabled: _ref == null || (!isTimerActive && !_canStartNewTimer()),
        ),
        MenuItem(
          key: 'new_task',
          label: 'New Task',
          disabled: _context == null,
        ),
        MenuItem.separator(),
        // Additional timer controls
        MenuItem(
          key: 'pause_timer',
          label: 'Pause Timer',
          disabled: _ref == null || !isTimerRunning,
        ),
        MenuItem(
          key: 'stop_timer',
          label: 'Stop Timer',
          disabled: _ref == null || !isTimerActive,
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'create_project',
          label: 'Create New Project',
          disabled: _context == null,
        ),
        MenuItem(
          key: 'quick_start',
          label: 'Quick Start Project',
          submenu: Menu(items: _getQuickStartItems()),
        ),
        MenuItem.separator(),
        MenuItem(key: 'break', label: 'Take a Break', disabled: _ref == null),
        MenuItem.separator(),
        MenuItem(key: 'quit', label: 'Quit Trackich'),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  List<MenuItem> _getQuickStartItems() {
    if (_ref == null) {
      return [
        MenuItem(
          key: 'no_projects',
          label: 'No projects available',
          disabled: true,
        ),
      ];
    }

    // Get recent projects asynchronously
    try {
      final recentProjectsAsync = _ref!.read(recentProjectsProvider);
      return recentProjectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return [
              MenuItem(
                key: 'no_projects',
                label: 'No recent projects',
                disabled: true,
              ),
            ];
          }

          return projects
              .take(5)
              .map(
                (project) =>
                    MenuItem(key: 'project_${project.id}', label: project.name),
              )
              .toList();
        },
        loading: () => [
          MenuItem(key: 'loading', label: 'Loading...', disabled: true),
        ],
        error: (_, __) => [
          MenuItem(
            key: 'error',
            label: 'Error loading projects',
            disabled: true,
          ),
        ],
      );
    } catch (e) {
      return [
        MenuItem(key: 'error', label: 'Error loading projects', disabled: true),
      ];
    }
  }

  String _getTimerDisplay() {
    if (_ref == null) return '';

    try {
      final timer = _ref!.read(timerProvider);
      if (!timer.isActive) {
        return '';
      }

      final elapsed = timer.elapsed;
      final hours = elapsed.inHours;
      final minutes = elapsed.inMinutes.remainder(60);
      final seconds = elapsed.inSeconds.remainder(60);

      String timeString;
      if (hours > 0) {
        timeString =
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      } else {
        timeString =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }

      final status = timer.state == TimerState.running ? 'Running' : 'Paused';
      final taskName = timer.taskName.isNotEmpty
          ? timer.taskName
          : 'Untitled Task';

      return '$timeString - $taskName ($status)';
    } catch (e) {
      return 'Timer: Error';
    }
  }

  bool _isTimerRunning() {
    if (_ref == null) return false;
    try {
      final timer = _ref!.read(timerProvider);
      return timer.isActive && timer.state == TimerState.running;
    } catch (e) {
      return false;
    }
  }

  bool _isTimerActive() {
    if (_ref == null) return false;
    try {
      final timer = _ref!.read(timerProvider);
      return timer.isActive;
    } catch (e) {
      return false;
    }
  }

  bool _canStartNewTimer() {
    if (_ref == null) return false;
    try {
      // Check if there are any projects available
      final recentProjectsAsync = _ref!.read(recentProjectsProvider);
      return recentProjectsAsync.when(
        data: (projects) => projects.isNotEmpty,
        loading: () => false,
        error: (_, __) => false,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  void onTrayIconMouseDown() {
    // On left click, show the context menu
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    // On right click, also show context menu
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {
    // Handle right mouse up if needed
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_app':
        _showApp();
        break;
      case 'start_stop_toggle':
        _handleStartStopToggle();
        break;
      case 'new_task':
        _showNewTaskDialog();
        break;
      case 'start_timer':
        _startTimer();
        break;
      case 'pause_timer':
        _pauseTimer();
        break;
      case 'stop_timer':
        _stopTimer();
        break;
      case 'create_project':
        _showCreateProjectDialog();
        break;
      case 'break':
        _startBreak();
        break;
      case 'quit':
        _quitApp();
        break;
      default:
        if (menuItem.key?.startsWith('project_') == true) {
          final projectId = menuItem.key!.substring(
            8,
          ); // Remove 'project_' prefix
          _quickStartProject(projectId);
        }
        break;
    }
  }

  void _showApp() {
    // This would show the main window - implementation depends on window management setup
    // For now, we'll just update the menu
    _updateTrayMenu();
  }

  void _handleStartStopToggle() {
    if (_ref == null) return;

    try {
      final timer = _ref!.read(timerProvider);

      if (timer.isActive) {
        if (timer.state == TimerState.running) {
          // Timer is running, stop it
          _ref!.read(timerProvider.notifier).stop();
        } else if (timer.state == TimerState.paused) {
          // Timer is paused, resume it
          _ref!.read(timerProvider.notifier).resume();
        }
      } else {
        // No active timer, start a new one
        _showQuickStartDialog();
      }

      _updateTrayMenu();
    } catch (e) {
      debugPrint('Error in start/stop toggle: $e');
    }
  }

  void _showNewTaskDialog() {
    if (_context == null) return;

    showDialog(
      context: _context!,
      builder: (context) => _QuickStartDialog(isNewTask: true),
    ).then((_) {
      _updateTrayMenu();
    });
  }

  void _startTimer() {
    if (_ref == null) return;

    // Try to start timer with the last used project/task
    try {
      final timer = _ref!.read(timerProvider);
      if (timer.canStart) {
        // If there's no current project, we need to show a dialog or use the last project
        _showQuickStartDialog();
      }
    } catch (e) {
      // Handle error
    }
  }

  void _pauseTimer() {
    if (_ref == null) return;

    try {
      _ref!.read(timerProvider.notifier).pause();
      _updateTrayMenu();
    } catch (e) {
      // Handle error
    }
  }

  void _stopTimer() {
    if (_ref == null) return;

    try {
      _ref!.read(timerProvider.notifier).stop();
      _updateTrayMenu();
    } catch (e) {
      // Handle error
    }
  }

  void _startBreak() {
    if (_ref == null) return;

    try {
      _ref!.read(timerProvider.notifier).startBreak();
      _updateTrayMenu();
    } catch (e) {
      // Handle error
    }
  }

  void _showCreateProjectDialog() {
    if (_context == null) return;

    showDialog(
      context: _context!,
      builder: (context) => const CreateProjectDialog(),
    ).then((_) {
      _updateTrayMenu();
    });
  }

  void _showQuickStartDialog() {
    if (_context == null) return;

    showDialog(
      context: _context!,
      builder: (context) => _QuickStartDialog(),
    ).then((_) {
      _updateTrayMenu();
    });
  }

  /// Start periodic updates for timer display in tray
  void _startPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = dart.Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTrayDisplay();
    });
  }

  /// Stop periodic updates
  void _stopPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  /// Update tray tooltip with current timer info
  Future<void> _updateTrayTooltip() async {
    try {
      final timerDisplay = _getTimerDisplay();
      final tooltip = timerDisplay.isNotEmpty
          ? 'Trackich - $timerDisplay'
          : 'Trackich - Time Tracker';

      await trayManager.setToolTip(tooltip);
    } catch (e) {
      debugPrint('Error updating tray tooltip: $e');
    }
  }

  /// Update both tooltip and menu when timer changes
  Future<void> _updateTrayDisplay() async {
    await _updateTrayTooltip();
    // Only update menu if timer state might have changed
    if (_ref != null) {
      try {
        final timer = _ref!.read(timerProvider);
        if (timer.isActive) {
          await _updateTrayMenu();
        }
      } catch (e) {
        // Ignore errors in periodic updates
      }
    }
  }

  void _quickStartProject(String projectId) {
    if (_ref == null) return;

    try {
      // Start a timer with the selected project
      // We'll need to prompt for a task name or use a default
      _ref!
          .read(timerProvider.notifier)
          .start(projectId: projectId, taskName: 'Quick start task');
      _updateTrayMenu();
    } catch (e) {
      // Handle error
    }
  }

  void _quitApp() {
    // Close the application
    exit(0);
  }

  // Call this method when timer state changes to update the tray menu
  void updateTimerStatus() {
    _updateTrayMenu();
    _updateTrayTooltip();
  }

  /// Dispose resources
  void dispose() {
    _stopPeriodicUpdates();
    trayManager.removeListener(this);
  }
}

// Quick Start Dialog for system tray
class _QuickStartDialog extends ConsumerStatefulWidget {
  final bool isNewTask;

  const _QuickStartDialog({this.isNewTask = false});

  @override
  ConsumerState<_QuickStartDialog> createState() => _QuickStartDialogState();
}

class _QuickStartDialogState extends ConsumerState<_QuickStartDialog> {
  final _taskController = TextEditingController();
  String? _selectedProjectId;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentProjectsAsync = ref.watch(recentProjectsProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.timer, color: AppTheme.primaryBlue),
          const SizedBox(width: 8),
          Text(widget.isNewTask ? 'New Task' : 'Quick Start Timer'),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project selection
            const Text('Project:'),
            const SizedBox(height: 8),
            recentProjectsAsync.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return const Text('No projects available. Create one first.');
                }

                return DropdownButtonFormField<String>(
                  value: _selectedProjectId,
                  hint: const Text('Select a project'),
                  items: projects
                      .map(
                        (project) => DropdownMenuItem(
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
                              const SizedBox(width: 8),
                              Text(project.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedProjectId = value),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading projects'),
            ),

            const SizedBox(height: 16),

            // Task name
            const Text('Task:'),
            const SizedBox(height: 8),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _startTimer(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canStartTimer() ? _startTimer : null,
          child: const Text('Start Timer'),
        ),
      ],
    );
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

    Navigator.of(context).pop();
  }
}
