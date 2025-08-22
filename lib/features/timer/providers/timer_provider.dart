import 'dart:async' as dart;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/time_entry.dart';
import '../../../core/services/storage_service.dart';
import '../../settings/providers/settings_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../notifications/notification_service.dart';
import '../../system_tray/system_tray_service.dart';

part 'timer_provider.g.dart';

/// Timer state
enum TimerState {
  idle,
  running,
  paused,
  breakTime,
}

/// Current timer information
class CurrentTimer {
  final String? projectId;
  final String taskName;
  final DateTime? startTime;
  final Duration elapsed;
  final TimerState state;
  final bool isBreak;
  final BreakType? breakType;

  const CurrentTimer({
    this.projectId,
    this.taskName = '',
    this.startTime,
    this.elapsed = Duration.zero,
    this.state = TimerState.idle,
    this.isBreak = false,
    this.breakType,
  });

  CurrentTimer copyWith({
    String? projectId,
    String? taskName,
    DateTime? startTime,
    Duration? elapsed,
    TimerState? state,
    bool? isBreak,
    BreakType? breakType,
  }) {
    return CurrentTimer(
      projectId: projectId ?? this.projectId,
      taskName: taskName ?? this.taskName,
      startTime: startTime ?? this.startTime,
      elapsed: elapsed ?? this.elapsed,
      state: state ?? this.state,
      isBreak: isBreak ?? this.isBreak,
      breakType: breakType ?? this.breakType,
    );
  }

  bool get canStart => state == TimerState.idle && projectId != null && taskName.isNotEmpty;
  bool get canPause => state == TimerState.running;
  bool get canResume => state == TimerState.paused;
  bool get canStop => state == TimerState.running || state == TimerState.paused;
  bool get isActive => state == TimerState.running || state == TimerState.paused;
}

/// Provider for the current timer
@riverpod
class Timer extends _$Timer {
  dart.Timer? _ticker;

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
        
        state = CurrentTimer(
          projectId: savedTimer.projectId,
          taskName: savedTimer.taskName,
          startTime: savedTimer.startTime,
          elapsed: totalElapsed,
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

  /// Start the timer
  Future<void> start({
    required String projectId,
    required String taskName,
    bool isBreak = false,
    BreakType? breakType,
  }) async {
    if (state.isActive) return;

    final now = DateTime.now();
    state = CurrentTimer(
      projectId: projectId,
      taskName: taskName,
      startTime: now,
      elapsed: Duration.zero,
      state: TimerState.running,
      isBreak: isBreak,
      breakType: breakType,
    );

    // Update project last active time
    if (!isBreak) {
      ref.read(projectsProvider.notifier).updateLastActive(projectId);
      
      // Add to recent tasks
      final storage = ref.read(storageServiceProvider);
      await storage.addRecentTask(taskName);
    }

    _startTicker();
    await _saveCurrentTimer();
    
    // Update system tray
    SystemTrayService.instance.updateTimerStatus();
  }

  /// Pause the timer
  Future<void> pause() async {
    if (!state.canPause) return;

    _ticker?.cancel();
    state = state.copyWith(state: TimerState.paused);
    await _saveCurrentTimer();
    
    // Update system tray
    SystemTrayService.instance.updateTimerStatus();
  }

  /// Resume the timer
  Future<void> resume() async {
    if (!state.canResume) return;

    // Keep the original start time but update state to running
    state = state.copyWith(state: TimerState.running);
    _startTicker();
    await _saveCurrentTimer();
    
    // Update system tray
    SystemTrayService.instance.updateTimerStatus();
  }

  /// Stop the timer and save the time entry
  Future<TimeEntry?> stop() async {
    if (!state.canStop) return null;

    _ticker?.cancel();
    
    final timeEntry = await _createTimeEntry();
    
    // Reset timer state
    state = const CurrentTimer();
    
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
    
    final entry = TimeEntry(
      id: uuid.v4(),
      projectId: state.projectId!,
      taskName: state.taskName,
      startTime: state.startTime!,
      endTime: DateTime.now(),
      duration: state.elapsed,
      isBreak: state.isBreak,
      breakType: state.breakType,
      isCompleted: true,
    );

    await storage.saveTimeEntry(entry);
    
    // Refresh projects to update total time
    ref.invalidate(projectsProvider);
    
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
        _saveCurrentTimer();
      }
      
      // Check for break reminders
      _checkBreakReminder();
    });
  }

  /// Save current timer to storage
  Future<void> _saveCurrentTimer() async {
    if (!state.isActive) return;
    
    try {
      final storage = ref.read(storageServiceProvider);
      final entry = TimeEntry(
        id: 'current',
        projectId: state.projectId!,
        taskName: state.taskName,
        startTime: state.startTime!,
        duration: state.elapsed,
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
      if (!settings.enableBreakReminders) return;
      
      // Check for break reminder every 25 minutes (Pomodoro technique)
      final workMinutes = state.elapsed.inMinutes;
      // Only trigger on exact minute boundaries and avoid duplicate notifications
      final workSeconds = state.elapsed.inSeconds;
      if (workMinutes > 0 && workMinutes % 25 == 0 && workSeconds % 60 < 5) {
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
      }
    });
  }

  /// Update timer project
  void updateProject(String projectId) {
    if (state.isActive) return;
    state = state.copyWith(projectId: projectId);
  }

  /// Update timer task name
  void updateTaskName(String taskName) {
    if (state.isActive) return;
    state = state.copyWith(taskName: taskName);
  }
}

/// Provider for today's time summary
@riverpod
Future<Map<String, dynamic>> todayTimeSummary(TodayTimeSummaryRef ref) async {
  final storage = ref.read(storageServiceProvider);
  final entries = await storage.getTodaysTimeEntries();
  
  final totalHours = entries.fold<double>(0.0, (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)));
  final workEntries = entries.where((e) => !e.isBreak);
  final breakEntries = entries.where((e) => e.isBreak);
  
  final workHours = workEntries.fold<double>(0.0, (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)));
  final breakHours = breakEntries.fold<double>(0.0, (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)));
  
  final completedTasks = workEntries.where((e) => e.isCompleted).length;
  
  // Hours by project
  final projects = await ref.read(projectsProvider.future);
  final hoursByProject = <String, Map<String, dynamic>>{};
  
  for (final project in projects) {
    final projectEntries = workEntries.where((e) => e.projectId == project.id);
    final projectHours = projectEntries.fold<double>(0.0, (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)));
    
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
Future<List<String>> recentTaskNames(RecentTaskNamesRef ref) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getRecentTaskNames();
}

