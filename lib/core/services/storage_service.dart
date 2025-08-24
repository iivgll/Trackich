import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../models/project.dart';
import '../models/time_entry.dart';
import '../models/settings.dart';

/// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Service for managing local data persistence using SharedPreferences
class StorageService {
  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Settings Management

  Future<AppSettings> getSettings() async {
    await init();
    final settingsJson = prefs.getString(AppConstants.settingsKey);
    if (settingsJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        return AppSettings.fromJson(json);
      } catch (e) {
        // If parsing fails, return default settings
        return const AppSettings();
      }
    }
    return const AppSettings();
  }

  Future<bool> saveSettings(AppSettings settings) async {
    await init();
    final settingsJson = jsonEncode(settings.toJson());
    return prefs.setString(AppConstants.settingsKey, settingsJson);
  }

  // Projects Management

  Future<List<Project>> getProjects() async {
    await init();
    final projectsJson = prefs.getStringList(AppConstants.projectsKey) ?? [];
    return projectsJson
        .map((json) {
          try {
            final Map<String, dynamic> projectMap = jsonDecode(json);
            return Project.fromJson(projectMap);
          } catch (e) {
            // Skip invalid projects
            return null;
          }
        })
        .whereType<Project>()
        .toList();
  }

  Future<bool> saveProjects(List<Project> projects) async {
    await init();
    final projectsJson = projects.map((project) {
      return jsonEncode(project.toJson());
    }).toList();
    return prefs.setStringList(AppConstants.projectsKey, projectsJson);
  }

  Future<bool> saveProject(Project project) async {
    final projects = await getProjects();
    final existingIndex = projects.indexWhere((p) => p.id == project.id);

    if (existingIndex >= 0) {
      projects[existingIndex] = project;
    } else {
      projects.add(project);
    }

    return saveProjects(projects);
  }

  Future<bool> deleteProject(String projectId) async {
    final projects = await getProjects();
    projects.removeWhere((project) => project.id == projectId);

    // Also delete associated time entries
    await deleteTimeEntriesByProject(projectId);

    return saveProjects(projects);
  }

  Future<Project?> getProject(String projectId) async {
    final projects = await getProjects();
    try {
      return projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  // Time Entries Management

  Future<List<TimeEntry>> getTimeEntries() async {
    await init();
    final entriesJson = prefs.getStringList(AppConstants.timeEntriesKey) ?? [];
    return entriesJson
        .map((json) {
          try {
            final Map<String, dynamic> entryMap = jsonDecode(json);
            return TimeEntry.fromJson(entryMap);
          } catch (e) {
            // Skip invalid entries
            return null;
          }
        })
        .whereType<TimeEntry>()
        .toList();
  }

  Future<bool> saveTimeEntries(List<TimeEntry> entries) async {
    await init();
    final entriesJson = entries.map((entry) {
      return jsonEncode(entry.toJson());
    }).toList();
    return prefs.setStringList(AppConstants.timeEntriesKey, entriesJson);
  }

  Future<bool> saveTimeEntry(TimeEntry entry) async {
    final entries = await getTimeEntries();
    final existingIndex = entries.indexWhere((e) => e.id == entry.id);

    if (existingIndex >= 0) {
      entries[existingIndex] = entry;
    } else {
      entries.add(entry);
    }

    return saveTimeEntries(entries);
  }

  Future<bool> deleteTimeEntry(String entryId) async {
    final entries = await getTimeEntries();
    entries.removeWhere((entry) => entry.id == entryId);
    return saveTimeEntries(entries);
  }

  Future<bool> deleteTimeEntriesByProject(String projectId) async {
    final entries = await getTimeEntries();
    entries.removeWhere((entry) => entry.projectId == projectId);
    return saveTimeEntries(entries);
  }

  Future<List<TimeEntry>> getTimeEntriesByProject(String projectId) async {
    final entries = await getTimeEntries();
    return entries.where((entry) => entry.projectId == projectId).toList();
  }

  Future<List<TimeEntry>> getTimeEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = await getTimeEntries();
    return entries.where((entry) {
      return entry.startTime.isAfter(startDate) &&
          entry.startTime.isBefore(endDate);
    }).toList();
  }

  Future<List<TimeEntry>> getTodaysTimeEntries() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getTimeEntriesByDateRange(startOfDay, endOfDay);
  }

  // Current Timer State Management

  Future<TimeEntry?> getCurrentTimer() async {
    await init();
    final timerJson = prefs.getString(AppConstants.currentTimerKey);
    if (timerJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(timerJson);
        return TimeEntry.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> saveCurrentTimer(TimeEntry? timer) async {
    await init();
    if (timer == null) {
      return prefs.remove(AppConstants.currentTimerKey);
    } else {
      final timerJson = jsonEncode(timer.toJson());
      return prefs.setString(AppConstants.currentTimerKey, timerJson);
    }
  }

  Future<bool> clearCurrentTimer() async {
    await init();
    return prefs.remove(AppConstants.currentTimerKey);
  }

  // Data Export and Import

  Future<Map<String, dynamic>> exportAllData() async {
    final settings = await getSettings();
    final projects = await getProjects();
    final timeEntries = await getTimeEntries();

    return {
      'settings': settings.toJson(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'timeEntries': timeEntries.map((e) => e.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': AppConstants.appVersion,
    };
  }

  Future<bool> importData(Map<String, dynamic> data) async {
    try {
      // Import settings
      if (data['settings'] != null) {
        final settings = AppSettings.fromJson(data['settings']);
        await saveSettings(settings);
      }

      // Import projects
      if (data['projects'] != null) {
        final projects = (data['projects'] as List)
            .map((json) => Project.fromJson(json))
            .toList();
        await saveProjects(projects);
      }

      // Import time entries
      if (data['timeEntries'] != null) {
        final timeEntries = (data['timeEntries'] as List)
            .map((json) => TimeEntry.fromJson(json))
            .toList();
        await saveTimeEntries(timeEntries);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Clear All Data

  Future<bool> clearAllData() async {
    await init();
    final keys = [
      AppConstants.settingsKey,
      AppConstants.projectsKey,
      AppConstants.timeEntriesKey,
      AppConstants.currentTimerKey,
    ];

    bool success = true;
    for (final key in keys) {
      success = success && await prefs.remove(key);
    }
    return success;
  }

  // Statistics and Analytics Helpers

  Future<double> getTotalHoursForProject(String projectId) async {
    final taskGroups = await getTaskGroupSummaries();
    final projectGroups = taskGroups.values.where(
      (group) => group.projectId == projectId,
    );

    return projectGroups.fold<double>(
      0.0,
      (total, group) => total + group.totalHours,
    );
  }

  Future<double> getTotalHoursForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = await getTimeEntriesByDateRange(startDate, endDate);
    return entries.fold<double>(
      0.0,
      (total, entry) =>
          total + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
    );
  }

  Future<Map<String, double>> getHoursByProjectForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = await getTimeEntriesByDateRange(startDate, endDate);
    final projects = await getProjects();
    final hoursByProject = <String, double>{};

    // Initialize with project names
    for (final project in projects) {
      hoursByProject[project.name] = 0.0;
    }

    // Sum hours by project
    for (final entry in entries) {
      final project = projects.cast<Project?>().firstWhere(
        (p) => p?.id == entry.projectId,
        orElse: () => null,
      );
      if (project != null) {
        hoursByProject[project.name] =
            (hoursByProject[project.name] ?? 0.0) +
            (entry.duration.inMilliseconds / (1000 * 60 * 60));
      }
    }

    return hoursByProject;
  }

  // Recent Items Management

  Future<List<String>> getRecentProjectIds() async {
    await init();
    return prefs.getStringList('recent_projects') ?? [];
  }

  Future<bool> addRecentProject(String projectId) async {
    await init();
    var recentProjects = await getRecentProjectIds();

    // Remove if already exists
    recentProjects.remove(projectId);

    // Add to front
    recentProjects.insert(0, projectId);

    // Keep only the most recent ones
    if (recentProjects.length > AppConstants.maxRecentProjects) {
      recentProjects = recentProjects
          .take(AppConstants.maxRecentProjects)
          .toList();
    }

    return prefs.setStringList('recent_projects', recentProjects);
  }

  Future<List<String>> getRecentTaskNames() async {
    await init();
    return prefs.getStringList('recent_tasks') ?? [];
  }

  Future<bool> addRecentTask(String taskName) async {
    await init();
    var recentTasks = await getRecentTaskNames();

    // Remove if already exists
    recentTasks.remove(taskName);

    // Add to front
    recentTasks.insert(0, taskName);

    // Keep only the most recent ones
    if (recentTasks.length > AppConstants.maxRecentTasks) {
      recentTasks = recentTasks.take(AppConstants.maxRecentTasks).toList();
    }

    return prefs.setStringList('recent_tasks', recentTasks);
  }

  // Task Continuation Management

  /// Find an existing task with the same project and task name
  Future<TimeEntry?> findExistingTask(String projectId, String taskName) async {
    final entries = await getTimeEntries();
    final normalizedTaskName = taskName.trim().toLowerCase();

    // Look for existing task with same project and task name
    try {
      return entries.firstWhere(
        (entry) =>
            entry.projectId == projectId &&
            entry.taskName.trim().toLowerCase() == normalizedTaskName &&
            !entry.isBreak,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all entries for a specific task group (same project + task name)
  Future<List<TimeEntry>> getTaskGroupEntries(
    String projectId,
    String taskName,
  ) async {
    final entries = await getTimeEntries();
    final normalizedTaskName = taskName.trim().toLowerCase();

    return entries
        .where(
          (entry) =>
              entry.projectId == projectId &&
              entry.taskName.trim().toLowerCase() == normalizedTaskName &&
              !entry.isBreak,
        )
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Calculate total accumulated time for a task group
  Future<Duration> getTotalAccumulatedTimeForTask(
    String projectId,
    String taskName,
  ) async {
    final taskEntries = await getTaskGroupEntries(projectId, taskName);

    return taskEntries.fold<Duration>(
      Duration.zero,
      (total, entry) => total + entry.duration,
    );
  }

  /// Get grouped tasks with accumulated times
  Future<Map<String, TaskGroupSummary>> getTaskGroupSummaries() async {
    final entries = await getTimeEntries();
    final projects = await getProjects();
    final groups = <String, TaskGroupSummary>{};

    for (final entry in entries) {
      if (entry.isBreak) continue;

      final key = entry.taskGroupKey;
      if (!groups.containsKey(key)) {
        final project = projects.cast<Project?>().firstWhere(
          (p) => p?.id == entry.projectId,
          orElse: () => null,
        );

        if (project != null) {
          groups[key] = TaskGroupSummary(
            projectId: entry.projectId,
            projectName: project.name,
            taskName: entry.taskName,
            totalTime: Duration.zero,
            sessionCount: 0,
            lastActivity: entry.startTime,
            projectColor: project.color.value,
          );
        }
      }

      if (groups.containsKey(key)) {
        final summary = groups[key]!;
        groups[key] = summary.copyWith(
          totalTime: summary.totalTime + entry.duration,
          sessionCount: summary.sessionCount + 1,
          lastActivity: entry.startTime.isAfter(summary.lastActivity)
              ? entry.startTime
              : summary.lastActivity,
        );
      }
    }

    return groups;
  }
}

/// Summary of a task group (same project + task name)
class TaskGroupSummary {
  final String projectId;
  final String projectName;
  final String taskName;
  final Duration totalTime;
  final int sessionCount;
  final DateTime lastActivity;
  final int projectColor;

  const TaskGroupSummary({
    required this.projectId,
    required this.projectName,
    required this.taskName,
    required this.totalTime,
    required this.sessionCount,
    required this.lastActivity,
    required this.projectColor,
  });

  TaskGroupSummary copyWith({
    String? projectId,
    String? projectName,
    String? taskName,
    Duration? totalTime,
    int? sessionCount,
    DateTime? lastActivity,
    int? projectColor,
  }) {
    return TaskGroupSummary(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      taskName: taskName ?? this.taskName,
      totalTime: totalTime ?? this.totalTime,
      sessionCount: sessionCount ?? this.sessionCount,
      lastActivity: lastActivity ?? this.lastActivity,
      projectColor: projectColor ?? this.projectColor,
    );
  }

  double get totalHours => totalTime.inMilliseconds / (1000 * 60 * 60);

  String get taskGroupKey => '${projectId}_${taskName.trim().toLowerCase()}';
}
