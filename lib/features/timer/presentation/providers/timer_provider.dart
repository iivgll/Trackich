import 'dart:async' as dart;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/time_entry.dart';
import '../../../../core/services/storage_service.dart';
import '../../../notifications/notification_service.dart';
import '../../../projects/presentation/providers/projects_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../system_tray/system_tray_service.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import 'package:uuid/uuid.dart';

part 'timer_provider.g.dart';

/// Timer state
enum TimerState { idle, running, paused, breakTime }

/// Current timer information
class CurrentTimer {
  final String? projectId;
  final String taskName;
  final DateTime? startTime;
  final Duration elapsed;
  final Duration totalAccumulatedTime;
  final TimerState state;
  final bool isBreak;
  final BreakType? breakType;

  const CurrentTimer({
    this.projectId,
    this.taskName = '',
    this.startTime,
    this.elapsed = Duration.zero,
    this.totalAccumulatedTime = Duration.zero,
    this.state = TimerState.idle,
    this.isBreak = false,
    this.breakType,
  });

  CurrentTimer copyWith({
    String? projectId,
    String? taskName,
    DateTime? startTime,
    Duration? elapsed,
    Duration? totalAccumulatedTime,
    TimerState? state,
    bool? isBreak,
    BreakType? breakType,
  }) {
    return CurrentTimer(
      projectId: projectId ?? this.projectId,
      taskName: taskName ?? this.taskName,
      startTime: startTime ?? this.startTime,
      elapsed: elapsed ?? this.elapsed,
      totalAccumulatedTime: totalAccumulatedTime ?? this.totalAccumulatedTime,
      state: state ?? this.state,
      isBreak: isBreak ?? this.isBreak,
      breakType: breakType ?? this.breakType,
    );
  }

  bool get canStart =>
      state == TimerState.idle && projectId != null && taskName.isNotEmpty;
  bool get canPause => state == TimerState.running;
  bool get canResume => state == TimerState.paused;
  bool get canStop => state == TimerState.running || state == TimerState.paused;
  bool get isActive =>
      state == TimerState.running || state == TimerState.paused;

  /// Get the total display time (accumulated + current session)
  Duration get displayDuration => totalAccumulatedTime + elapsed;
}

/// Provider for the current timer
@Riverpod(keepAlive: true)
class Timer extends _$Timer {
  dart.Timer? _ticker;
  int _lastBreakNotificationMinutes =
      -1; // Track last notification to prevent duplicates

  @override
  CurrentTimer build() {
    ref.onDispose(() {
      _ticker?.cancel();
    });

    // Load any existing timer state
    _loadSavedTimer();

    return const CurrentTimer();
  }

  /// Load saved timer state from storage
  Future<void> _loadSavedTimer() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final savedTimer = await storage.getCurrentTimer();

      if (savedTimer != null && savedTimer.isRunning) {
        // Calculate total elapsed time from start time to now
        final now = DateTime.now();
        final totalElapsed = now.difference(savedTimer.startTime);

        // If the timer has been running for more than 5 minutes without the app,
        // we should show recovery dialog instead of auto-continuing
        if (totalElapsed.inMinutes >= 5) {
          // Store recovery data and clear the saved timer
          await _storeRecoveryData(savedTimer, totalElapsed);
          await storage.clearCurrentTimer();
          state = const CurrentTimer();
          return;
        }

        // Auto-continue if less than 5 minutes
        state = CurrentTimer(
          projectId: savedTimer.projectId,
          taskName: savedTimer.taskName,
          startTime: savedTimer.startTime,
          elapsed: totalElapsed,
          totalAccumulatedTime: savedTimer.totalAccumulatedTime,
          state: TimerState.running,
          isBreak: savedTimer.isBreak,
          breakType: savedTimer.breakType,
        );

        _startTicker();
      }
    } catch (e) {
      // If loading fails, start with idle state
      state = const CurrentTimer();
    }
  }

  /// Store recovery data for later dialog display
  Future<void> _storeRecoveryData(
    TimeEntry savedTimer,
    Duration totalElapsed,
  ) async {
    final storage = ref.read(storageServiceProvider);
    final recoveryData = {
      'projectId': savedTimer.projectId,
      'taskName': savedTimer.taskName,
      'startTime': savedTimer.startTime.toIso8601String(),
      'duration': totalElapsed.inMilliseconds,
      'totalAccumulatedTime': savedTimer.totalAccumulatedTime.inMilliseconds,
      'isBreak': savedTimer.isBreak,
    };

    await storage.saveRecoveryData(recoveryData);
  }

  /// Start the timer with task continuation logic
  Future<void> start({
    required String projectId,
    required String taskName,
    bool isBreak = false,
    BreakType? breakType,
  }) async {
    if (state.isActive) return;

    final now = DateTime.now();
    Duration totalAccumulatedTime = Duration.zero;

    // For regular tasks (not breaks), check for existing tasks to continue
    if (!isBreak) {
      final storage = ref.read(storageServiceProvider);
      final existingTask = await storage.findExistingTask(projectId, taskName);

      if (existingTask != null) {
        // Task exists - calculate total accumulated time from all sessions
        totalAccumulatedTime = await storage.getTotalAccumulatedTimeForTask(
          projectId,
          taskName,
        );
      }

      // Update project last active time
      ref.read(projectsProvider.notifier).updateLastActive(projectId);

      // Add to recent tasks
      await storage.addRecentTask(taskName);
    }

    state = CurrentTimer(
      projectId: projectId,
      taskName: taskName,
      startTime: now,
      elapsed: Duration.zero,
      totalAccumulatedTime: totalAccumulatedTime,
      state: TimerState.running,
      isBreak: isBreak,
      breakType: breakType,
    );

    // Reset notification tracking when starting a new timer
    _lastBreakNotificationMinutes = -1;

    _startTicker();
    await saveCurrentTimer();

    // Update system tray
    SystemTrayService.instance.updateTimerStatus();
  }

  /// Pause the timer
  Future<void> pause() async {
    if (!state.canPause) return;

    _ticker?.cancel();

    // Stop notification timers when pausing
    final notificationService = ref.read(notificationServiceProvider);
    notificationService.stopAllTimers();

    state = state.copyWith(state: TimerState.paused);
    await saveCurrentTimer();

    // Update system tray
    SystemTrayService.instance.updateTimerStatus();
  }

  /// Resume the timer
  Future<void> resume() async {
    if (!state.canResume) return;

    // Keep the original start time but update state to running
    state = state.copyWith(state: TimerState.running);
    _startTicker();
    await saveCurrentTimer();

    // Update system tray
    SystemTrayService.instance.updateTimerStatus();
  }

  /// Stop the timer and save the time entry
  Future<TimeEntry?> stop() async {
    if (!state.canStop) return null;

    _ticker?.cancel();

    // Stop notification timers and cancel pending notifications
    final notificationService = ref.read(notificationServiceProvider);
    notificationService.stopAllTimers();

    final timeEntry = await _createTimeEntry();

    // Reset timer state and notification tracking
    state = const CurrentTimer();
    _lastBreakNotificationMinutes = -1;

    // Clear saved timer
    final storage = ref.read(storageServiceProvider);
    await storage.clearCurrentTimer();

    // Update system tray
    SystemTrayService.instance.updateTimerStatus();

    return timeEntry;
  }

  /// Start a break timer
  Future<void> startBreak({BreakType? breakType}) async {
    await start(
      projectId: 'break',
      taskName: 'Break',
      isBreak: true,
      breakType: breakType ?? const BreakType.short(),
    );
  }

  /// Create a time entry from the current timer
  Future<TimeEntry> _createTimeEntry() async {
    const uuid = Uuid();
    final storage = ref.read(storageServiceProvider);

    // Calculate the new total accumulated time
    final newTotalAccumulatedTime = state.totalAccumulatedTime + state.elapsed;

    final entry = TimeEntry(
      id: uuid.v4(),
      projectId: state.projectId!,
      taskName: state.taskName,
      startTime: state.startTime!,
      endTime: DateTime.now(),
      duration: state.elapsed,
      totalAccumulatedTime: newTotalAccumulatedTime,
      isBreak: state.isBreak,
      breakType: state.breakType,
      isCompleted: true,
    );

    await storage.saveTimeEntry(entry);

    // Refresh projects to update total time
    ref.invalidate(projectsProvider);

    // Refresh calendar data to show completed task immediately
    ref.invalidate(calendarDataByDateProvider);
    ref.invalidate(unfilteredTimeEntriesProvider);
    ref.invalidate(filteredTimeEntriesProvider);

    return entry;
  }

  /// Start the timer ticker
  void _startTicker() {
    _ticker?.cancel();
    _ticker = dart.Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.startTime == null) return;

      final now = DateTime.now();
      final totalElapsed = now.difference(state.startTime!);

      state = state.copyWith(elapsed: totalElapsed);

      // Auto-save every 30 seconds
      if (totalElapsed.inSeconds % 30 == 0) {
        saveCurrentTimer();
      }

      // Check for break reminders
      _checkBreakReminder();
    });
  }

  /// Save current timer to storage
  Future<void> saveCurrentTimer() async {
    if (!state.isActive) return;

    try {
      final storage = ref.read(storageServiceProvider);
      final entry = TimeEntry(
        id: 'current',
        projectId: state.projectId!,
        taskName: state.taskName,
        startTime: state.startTime!,
        duration: state.elapsed,
        totalAccumulatedTime: state.totalAccumulatedTime,
        isBreak: state.isBreak,
        breakType: state.breakType,
      );

      await storage.saveCurrentTimer(entry);
    } catch (e) {
      // Ignore save errors to prevent disrupting the timer
    }
  }

  /// Check if a break reminder should be shown
  void _checkBreakReminder() {
    if (state.isBreak) return;

    ref.read(settingsProvider).whenData((settings) async {
      if (!settings.enableBreakReminders || !settings.enableNotifications) {
        return;
      }

      // Check for break reminder based on user-defined interval
      // Use only the current session time for break reminders, not accumulated time
      final workMinutes = state.elapsed.inMinutes;
      final workSeconds = state.elapsed.inSeconds;
      final breakIntervalMinutes = settings.breakInterval.inMinutes;

      // Only trigger at exact intervals and prevent duplicates
      if (workMinutes > 0 &&
          workMinutes % breakIntervalMinutes == 0 &&
          workSeconds % 60 ==
              0 && // Only trigger at exact minute boundaries (0 seconds)
          workMinutes != _lastBreakNotificationMinutes) {
        // Prevent duplicate notifications

        // Mark this minute as having sent a notification
        _lastBreakNotificationMinutes = workMinutes;

        final notificationService = ref.read(notificationServiceProvider);

        // Get project name for notification
        String? projectName;
        if (state.projectId != null) {
          try {
            final projects = await ref.read(projectsProvider.future);
            final project = projects.firstWhere((p) => p.id == state.projectId);
            projectName = project.name;
          } catch (e) {
            debugPrint('Failed to get project name for notification: $e');
          }
        }

        await notificationService.showBreakReminder(
          workDuration: state.elapsed,
          projectName: projectName,
        );

        debugPrint(
          'Break reminder notification scheduled for ${workMinutes}m (interval: ${breakIntervalMinutes}m)',
        );
      }
    });
  }

  /// Update timer project
  void updateProject(String projectId) {
    if (state.isActive) return;
    state = state.copyWith(projectId: projectId);
  }

  /// Clear timer project
  void clearProject() {
    if (state.isActive) return;
    state = state.copyWith(projectId: null);
  }

  /// Update timer task name
  void updateTaskName(String taskName) {
    if (state.isActive) return;
    state = state.copyWith(taskName: taskName);
  }

  /// Find existing task and return its accumulated time
  Future<Duration> getTaskAccumulatedTime(
    String projectId,
    String taskName,
  ) async {
    final storage = ref.read(storageServiceProvider);
    return await storage.getTotalAccumulatedTimeForTask(projectId, taskName);
  }

  /// Check if a task already exists
  Future<bool> taskExists(String projectId, String taskName) async {
    final storage = ref.read(storageServiceProvider);
    final existingTask = await storage.findExistingTask(projectId, taskName);
    return existingTask != null;
  }

  /// Add recovered time to task
  Future<void> addRecoveredTime(Map<String, dynamic> recoveryData) async {
    const uuid = Uuid();
    final storage = ref.read(storageServiceProvider);

    final startTime = DateTime.parse(recoveryData['startTime']);
    final duration = Duration(milliseconds: recoveryData['duration']);
    final totalAccumulatedTime = Duration(
      milliseconds: recoveryData['totalAccumulatedTime'],
    );

    final entry = TimeEntry(
      id: uuid.v4(),
      projectId: recoveryData['projectId'],
      taskName: recoveryData['taskName'],
      startTime: startTime,
      endTime: startTime.add(duration),
      duration: duration,
      totalAccumulatedTime: totalAccumulatedTime + duration,
      isBreak: recoveryData['isBreak'] ?? false,
      isCompleted: true,
    );

    await storage.saveTimeEntry(entry);
    await storage.clearRecoveryData();

    // Refresh projects to update total time
    ref.invalidate(projectsProvider);
  }

  /// Discard recovered time
  Future<void> discardRecoveredTime() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearRecoveryData();
  }
}

/// Provider for today's time summary
@riverpod
Future<Map<String, dynamic>> todayTimeSummary(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  final entries = await storage.getTodaysTimeEntries();

  // For today's summary, we need to use the actual duration from today's entries, not accumulated time
  // because we want to show what was done today specifically
  final totalHours = entries.fold<double>(
    0.0,
    (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
  );
  final workEntries = entries.where((e) => !e.isBreak);
  final breakEntries = entries.where((e) => e.isBreak);

  final workHours = workEntries.fold<double>(
    0.0,
    (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
  );
  final breakHours = breakEntries.fold<double>(
    0.0,
    (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
  );

  final completedTasks = workEntries.where((e) => e.isCompleted).length;

  // Hours by project for today (only active projects)
  final allProjects = await ref.read(projectsProvider.future);
  final activeProjects = allProjects
      .where((project) => project.isActive)
      .toList();
  final hoursByProject = <String, Map<String, dynamic>>{};

  for (final project in activeProjects) {
    final projectEntries = workEntries.where((e) => e.projectId == project.id);
    final projectHours = projectEntries.fold<double>(
      0.0,
      (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
    );

    if (projectHours > 0) {
      hoursByProject[project.id] = {
        'name': project.name,
        'color': project.color,
        'hours': projectHours,
        'percentage': totalHours > 0 ? (projectHours / workHours) * 100 : 0.0,
      };
    }
  }

  return {
    'totalHours': totalHours,
    'workHours': workHours,
    'breakHours': breakHours,
    'completedTasks': completedTasks,
    'hoursByProject': hoursByProject,
  };
}

/// Provider for recent task names
@riverpod
Future<List<String>> recentTaskNames(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getRecentTaskNames();
}
