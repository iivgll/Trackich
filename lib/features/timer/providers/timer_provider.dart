import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/time_entry.dart';

part 'timer_provider.g.dart';

/// Current timer state
@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _timer;

  @override
  TimerState build() {
    return const TimerState.idle();
  }

  /// Start a new timer
  void startTimer({
    required String projectId,
    required String taskName,
    String? notes,
  }) {
    final now = DateTime.now();
    final timeEntry = TimeEntry(
      id: _generateId(),
      projectId: projectId,
      taskName: taskName,
      startTime: now,
      notes: notes,
    );

    state = TimerState.running(
      timeEntry: timeEntry,
      elapsed: Duration.zero,
    );

    _startTicking();
  }

  /// Pause the current timer
  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    
    final currentState = state;
    if (currentState is TimerRunning) {
      state = TimerState.paused(
        timeEntry: currentState.timeEntry,
        elapsed: currentState.elapsed,
      );
    }
  }

  /// Resume a paused timer
  void resumeTimer() {
    final currentState = state;
    if (currentState is TimerPaused) {
      state = TimerState.running(
        timeEntry: currentState.timeEntry,
        elapsed: currentState.elapsed,
      );
      _startTicking();
    }
  }

  /// Stop the current timer and save the entry
  TimeEntry? stopTimer() {
    _timer?.cancel();
    _timer = null;

    final currentState = state;
    TimeEntry? completedEntry;

    if (currentState is TimerRunning || currentState is TimerPaused) {
      final timeEntry = currentState.currentEntry!;
      final elapsed = currentState.elapsed;
      
      completedEntry = timeEntry.copyWith(
        endTime: DateTime.now(),
        duration: elapsed,
      );

      // Save to time entries provider
      ref.read(timeEntriesProvider.notifier).addEntry(completedEntry);
    }

    state = const TimerState.idle();
    return completedEntry;
  }

  /// Start a break
  void startBreak({BreakType type = BreakType.short}) {
    final currentState = state;
    if (currentState is TimerRunning) {
      // Pause the current work task
      pauseTimer();
      
      // Start a break entry
      final breakEntry = TimeEntry(
        id: _generateId(),
        projectId: currentState.timeEntry.projectId,
        taskName: 'Break',
        startTime: DateTime.now(),
        isBreak: true,
        breakType: type,
      );

      state = TimerState.onBreak(
        workEntry: currentState.timeEntry.copyWith(
          duration: currentState.elapsed,
        ),
        breakEntry: breakEntry,
        elapsed: Duration.zero,
      );

      _startTicking();
    }
  }

  /// End the current break
  void endBreak() {
    final currentState = state;
    if (currentState is TimerOnBreak) {
      // Complete the break entry
      final completedBreak = currentState.breakEntry.copyWith(
        endTime: DateTime.now(),
        duration: currentState.elapsed,
      );
      
      ref.read(timeEntriesProvider.notifier).addEntry(completedBreak);

      // Return to paused work state
      state = TimerState.paused(
        timeEntry: currentState.workEntry,
        elapsed: currentState.workEntry.calculatedDuration,
      );
    }
  }

  /// Add a note to the current timer
  void addNote(String note) {
    final currentState = state;
    if (currentState is TimerRunning) {
      final updatedEntry = currentState.timeEntry.copyWith(notes: note);
      state = TimerState.running(
        timeEntry: updatedEntry,
        elapsed: currentState.elapsed,
      );
    } else if (currentState is TimerPaused) {
      final updatedEntry = currentState.timeEntry.copyWith(notes: note);
      state = TimerState.paused(
        timeEntry: updatedEntry,
        elapsed: currentState.elapsed,
      );
    }
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      
      if (currentState is TimerRunning) {
        state = TimerState.running(
          timeEntry: currentState.timeEntry,
          elapsed: currentState.elapsed + const Duration(seconds: 1),
        );
      } else if (currentState is TimerOnBreak) {
        state = TimerState.onBreak(
          workEntry: currentState.workEntry,
          breakEntry: currentState.breakEntry,
          elapsed: currentState.elapsed + const Duration(seconds: 1),
        );
      }
    });
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Dispose method will be handled by Riverpod
  void _dispose() {
    _timer?.cancel();
  }
}

/// Timer state sealed class
sealed class TimerState {
  const TimerState();

  const factory TimerState.idle() = TimerIdle;
  
  const factory TimerState.running({
    required TimeEntry timeEntry,
    required Duration elapsed,
  }) = TimerRunning;
  
  const factory TimerState.paused({
    required TimeEntry timeEntry,
    required Duration elapsed,
  }) = TimerPaused;
  
  const factory TimerState.onBreak({
    required TimeEntry workEntry,
    required TimeEntry breakEntry,
    required Duration elapsed,
  }) = TimerOnBreak;

  /// Get the current time entry if any
  TimeEntry? get currentEntry => switch (this) {
    TimerRunning(:final timeEntry) => timeEntry,
    TimerPaused(:final timeEntry) => timeEntry,
    TimerOnBreak(:final workEntry) => workEntry,
    TimerIdle() => null,
  };

  /// Get the elapsed time
  Duration get elapsed => switch (this) {
    TimerRunning(:final elapsed) => elapsed,
    TimerPaused(:final elapsed) => elapsed,
    TimerOnBreak(:final elapsed) => elapsed,
    TimerIdle() => Duration.zero,
  };

  /// Check if timer is active (running or on break)
  bool get isActive => switch (this) {
    TimerRunning() => true,
    TimerOnBreak() => true,
    TimerPaused() => false,
    TimerIdle() => false,
  };

  /// Check if timer is running (not idle, not paused)
  bool get isRunning => switch (this) {
    TimerRunning() => true,
    TimerOnBreak() => true,
    TimerPaused() => false,
    TimerIdle() => false,
  };
}

final class TimerIdle extends TimerState {
  const TimerIdle();
}

final class TimerRunning extends TimerState {
  const TimerRunning({
    required this.timeEntry,
    required this.elapsed,
  });

  final TimeEntry timeEntry;
  @override
  final Duration elapsed;
}

final class TimerPaused extends TimerState {
  const TimerPaused({
    required this.timeEntry,
    required this.elapsed,
  });

  final TimeEntry timeEntry;
  @override
  final Duration elapsed;
}

final class TimerOnBreak extends TimerState {
  const TimerOnBreak({
    required this.workEntry,
    required this.breakEntry,
    required this.elapsed,
  });

  final TimeEntry workEntry;
  final TimeEntry breakEntry;
  @override
  final Duration elapsed;
}

/// Provider for managing time entries
@riverpod
class TimeEntries extends _$TimeEntries {
  @override
  List<TimeEntry> build() {
    return [];
  }

  void addEntry(TimeEntry entry) {
    state = [...state, entry];
  }

  void updateEntry(TimeEntry entry) {
    state = state.map((e) => e.id == entry.id ? entry : e).toList();
  }

  void deleteEntry(String entryId) {
    state = state.where((e) => e.id != entryId).toList();
  }

  /// Get entries for a specific date
  List<TimeEntry> getEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return state
        .where((entry) =>
            entry.startTime.isAfter(startOfDay) &&
            entry.startTime.isBefore(endOfDay))
        .toList();
  }

  /// Get total time worked for a date
  Duration getTotalTimeForDate(DateTime date) {
    final entries = getEntriesForDate(date);
    return entries
        .where((entry) => !entry.isBreak)
        .fold(Duration.zero, (total, entry) => total + entry.calculatedDuration);
  }

  /// Get entries for a project
  List<TimeEntry> getEntriesForProject(String projectId) {
    return state.where((entry) => entry.projectId == projectId).toList();
  }
}