import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/project.dart';
import '../../../timer/presentation/providers/timer_provider.dart';

part 'projects_provider.g.dart';

/// Provider for managing projects
@riverpod
class Projects extends _$Projects {
  @override
  Future<List<Project>> build() async {
    final storage = ref.read(storageServiceProvider);
    final projects = await storage.getProjects();

    // Update total time tracked for each project
    final updatedProjects = <Project>[];
    for (final project in projects) {
      final totalTime = await storage.getTotalHoursForProject(project.id);
      updatedProjects.add(project.copyWith(totalTimeTracked: totalTime));
    }

    return updatedProjects;
  }

  /// Create a new project
  Future<void> createProject({
    required String name,
    required String description,
    required Color color,
    List<String> tags = const [],
    double targetHoursPerWeek = 0.0,
  }) async {
    state = const AsyncValue.loading();
    try {
      final storage = ref.read(storageServiceProvider);
      const uuid = Uuid();

      final project = Project(
        id: uuid.v4(),
        name: name,
        description: description,
        color: color,
        createdAt: DateTime.now(),
        isActive: true,
        tags: tags,
        targetHoursPerWeek: targetHoursPerWeek,
        totalTimeTracked: 0.0,
        lastActiveAt: DateTime.now(),
      );

      await storage.saveProject(project);
      await storage.addRecentProject(project.id);

      // Refresh the projects list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update an existing project
  Future<void> updateProject(Project updatedProject) async {
    state = const AsyncValue.loading();
    try {
      final storage = ref.read(storageServiceProvider);
      await storage.saveProject(updatedProject);

      // Refresh the projects list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    state = const AsyncValue.loading();
    try {
      final storage = ref.read(storageServiceProvider);
      await storage.deleteProject(projectId);

      // Refresh the projects list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Archive/unarchive a project
  Future<void> toggleProjectActive(String projectId) async {
    final projects = await future;
    final project = projects.firstWhere((p) => p.id == projectId);

    // If archiving project, stop any active timer for this project
    if (project.isActive) {
      await _stopActiveTimerForProject(projectId);
    }

    await updateProject(project.copyWith(isActive: !project.isActive));
  }

  /// Stop active timer if it belongs to the specified project
  Future<void> _stopActiveTimerForProject(String projectId) async {
    try {
      final timerNotifier = ref.read(timerProvider.notifier);
      final currentTimer = ref.read(timerProvider);

      // If there's an active timer for this project, stop it
      if (currentTimer.isActive && currentTimer.projectId == projectId) {
        await timerNotifier.stop();
      }

      // Also clear the project selection if the timer is using this project
      // (even if not active, to prevent UI issues)
      if (currentTimer.projectId == projectId) {
        timerNotifier.clearProject();
      }
    } catch (e) {
      // Timer provider might not be available, continue with archiving
      debugPrint('Could not stop timer for archived project: $e');
    }
  }

  /// Update project last active time
  Future<void> updateLastActive(String projectId) async {
    final storage = ref.read(storageServiceProvider);
    final project = await storage.getProject(projectId);
    if (project != null) {
      await storage.saveProject(project.copyWith(lastActiveAt: DateTime.now()));
      await storage.addRecentProject(projectId);

      // Refresh only if we have an active state
      if (state.hasValue) {
        ref.invalidateSelf();
      }
    }
  }

  /// Get next available project color
  Color getNextAvailableColor() {
    if (!state.hasValue) return AppTheme.projectColors.first;

    final projects = state.value!;
    final usedColors = projects.map((p) => p.color.toARGB32()).toSet();

    for (final color in AppTheme.projectColors) {
      if (!usedColors.contains(color.toARGB32())) {
        return color;
      }
    }

    // If all colors are used, return the first one
    return AppTheme.projectColors.first;
  }
}

/// Provider for active projects only
@riverpod
Future<List<Project>> activeProjects(Ref ref) async {
  final projects = await ref.watch(projectsProvider.future);
  return projects.where((project) => project.isActive).toList();
}

/// Provider for archived projects only
@riverpod
Future<List<Project>> archivedProjects(Ref ref) async {
  final projects = await ref.watch(projectsProvider.future);
  return projects.where((project) => !project.isActive).toList();
}

/// Provider for recent project IDs
@riverpod
Future<List<String>> recentProjectIds(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  return storage.getRecentProjectIds();
}

/// Provider for favorite project IDs
@riverpod
Future<List<String>> favoriteProjectIds(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  return storage.getFavoriteProjectIds();
}

/// Provider for recent projects
@riverpod
Future<List<Project>> recentProjects(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  final recentProjectIds = await storage.getRecentProjectIds();
  final allProjects = await ref.watch(projectsProvider.future);

  return recentProjectIds
      .map((id) {
        try {
          return allProjects.firstWhere((p) => p.id == id);
        } catch (e) {
          return null;
        }
      })
      .whereType<Project>()
      .where((project) => project.isActive)
      .take(6) // Limit to 6 most recent
      .toList();
}

/// Provider for projects sorted by most used
@riverpod
Future<List<Project>> projectsByUsage(Ref ref) async {
  final projects = await ref.watch(activeProjectsProvider.future);

  // Sort by total time tracked (descending) and then by last active time
  projects.sort((a, b) {
    final timeComparison = b.totalTimeTracked.compareTo(a.totalTimeTracked);
    if (timeComparison != 0) return timeComparison;

    final aLastActive = a.lastActiveAt ?? a.createdAt;
    final bLastActive = b.lastActiveAt ?? b.createdAt;
    return bLastActive.compareTo(aLastActive);
  });

  return projects;
}

/// Provider for a specific project by ID
@riverpod
Future<Project?> project(Ref ref, String projectId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getProject(projectId);
}

/// Provider for project statistics
@riverpod
class ProjectStats extends _$ProjectStats {
  @override
  Future<Map<String, dynamic>> build(String projectId) async {
    final storage = ref.read(storageServiceProvider);
    final now = DateTime.now();

    // Get time entries for this project
    final entries = await storage.getTimeEntriesByProject(projectId);

    // Calculate statistics
    final totalHours = entries.fold<double>(
      0.0,
      (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
    );

    // This week's hours
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 1,
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    final thisWeekEntries = entries.where(
      (entry) =>
          entry.startTime.isAfter(startOfWeek) &&
          entry.startTime.isBefore(endOfWeek),
    );
    final thisWeekHours = thisWeekEntries.fold<double>(
      0.0,
      (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
    );

    // This month's hours
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    final thisMonthEntries = entries.where(
      (entry) =>
          entry.startTime.isAfter(startOfMonth) &&
          entry.startTime.isBefore(endOfMonth),
    );
    final thisMonthHours = thisMonthEntries.fold<double>(
      0.0,
      (sum, entry) => sum + (entry.duration.inMilliseconds / (1000 * 60 * 60)),
    );

    // Average session length
    final avgSessionHours = entries.isEmpty ? 0.0 : totalHours / entries.length;

    // Longest session
    final longestSession = entries.isEmpty
        ? 0.0
        : entries
              .map((e) => e.duration.inMilliseconds / (1000 * 60 * 60))
              .reduce((a, b) => a > b ? a : b);

    // Total sessions
    final totalSessions = entries.length;

    // Days worked
    final uniqueDays = entries.map((entry) {
      final date = entry.startTime;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
    final daysWorked = uniqueDays.length;

    return {
      'totalHours': totalHours,
      'thisWeekHours': thisWeekHours,
      'thisMonthHours': thisMonthHours,
      'averageSessionHours': avgSessionHours,
      'longestSessionHours': longestSession,
      'totalSessions': totalSessions,
      'daysWorked': daysWorked,
    };
  }
}

/// Provider for searching projects
@riverpod
Future<List<Project>> searchProjects(Ref ref, String query) async {
  if (query.isEmpty) {
    return ref.watch(activeProjectsProvider.future);
  }

  final projects = await ref.watch(activeProjectsProvider.future);
  final lowerQuery = query.toLowerCase();

  return projects.where((project) {
    return project.name.toLowerCase().contains(lowerQuery) ||
        project.description.toLowerCase().contains(lowerQuery) ||
        project.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }).toList();
}
