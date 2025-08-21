import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import '../../../core/models/project.dart';
import '../../../core/theme/app_theme.dart';

part 'projects_provider.g.dart';

/// Provider for managing projects
@riverpod
class Projects extends _$Projects {
  @override
  List<Project> build() {
    // Initialize with default projects
    return _createDefaultProjects();
  }

  /// Add a new project
  void addProject(Project project) {
    state = [...state, project];
  }

  /// Update an existing project
  void updateProject(Project project) {
    state = state.map((p) => p.id == project.id ? project : p).toList();
  }

  /// Archive a project
  void archiveProject(String projectId) {
    final project = getProjectById(projectId);
    if (project != null) {
      final archivedProject = project.copyWith(
        isArchived: true,
        archivedAt: DateTime.now(),
      );
      updateProject(archivedProject);
    }
  }

  /// Unarchive a project
  void unarchiveProject(String projectId) {
    final project = getProjectById(projectId);
    if (project != null) {
      final unarchivedProject = project.copyWith(
        isArchived: false,
        archivedAt: null,
      );
      updateProject(unarchivedProject);
    }
  }

  /// Delete a project (permanently)
  void deleteProject(String projectId) {
    state = state.where((p) => p.id != projectId).toList();
  }

  /// Get a project by ID
  Project? getProjectById(String projectId) {
    try {
      return state.firstWhere((p) => p.id == projectId);
    } catch (e) {
      return null;
    }
  }

  /// Get active projects only
  List<Project> getActiveProjects() {
    return state.where((p) => !p.isArchived).toList();
  }

  /// Get archived projects only
  List<Project> getArchivedProjects() {
    return state.where((p) => p.isArchived).toList();
  }

  /// Create a new project with auto-assigned color
  Project createProject({
    required String name,
    required String description,
    Color? color,
  }) {
    final projectColor = color ?? _getNextProjectColor();
    
    return Project(
      id: _generateId(),
      name: name,
      description: description,
      color: projectColor,
      createdAt: DateTime.now(),
    );
  }

  Color _getNextProjectColor() {
    final usedColors = state.map((p) => p.color).toSet();
    
    // Find the first unused color from the theme
    for (final color in AppTheme.projectColors) {
      if (!usedColors.contains(color)) {
        return color;
      }
    }
    
    // If all colors are used, cycle through them
    return AppTheme.projectColors[state.length % AppTheme.projectColors.length];
  }

  String _generateId() {
    return 'project_${DateTime.now().millisecondsSinceEpoch}';
  }

  List<Project> _createDefaultProjects() {
    return [
      Project(
        id: 'project_1',
        name: 'Web Application',
        description: 'Frontend development project',
        color: AppTheme.projectColors[0],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Project(
        id: 'project_2',
        name: 'Mobile App',
        description: 'iOS and Android development',
        color: AppTheme.projectColors[1],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Project(
        id: 'project_3',
        name: 'Research',
        description: 'Market research and analysis',
        color: AppTheme.projectColors[2],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}

/// Provider that filters active projects
@riverpod
List<Project> activeProjects(Ref ref) {
  final projects = ref.watch(projectsProvider);
  return projects.where((p) => !p.isArchived).toList();
}

/// Provider that filters archived projects
@riverpod
List<Project> archivedProjects(Ref ref) {
  final projects = ref.watch(projectsProvider);
  return projects.where((p) => p.isArchived).toList();
}

/// Provider for getting a specific project by ID
@riverpod
Project? projectById(Ref ref, String projectId) {
  final projects = ref.watch(projectsProvider);
  try {
    return projects.firstWhere((p) => p.id == projectId);
  } catch (e) {
    return null;
  }
}

/// Provider for project statistics
@riverpod
ProjectStatistics projectStatistics(Ref ref, String projectId) {
  // This would typically compute statistics from time entries
  // For now, return mock data
  return const ProjectStatistics(
    totalTime: Duration(hours: 156, minutes: 45),
    thisWeekTime: Duration(hours: 24, minutes: 30),
    thisMonthTime: Duration(hours: 47, minutes: 20),
    taskCount: 8,
    lastActivity: 'Mock: 2 hours ago',
  );
}

/// Model for project statistics
class ProjectStatistics {
  const ProjectStatistics({
    required this.totalTime,
    required this.thisWeekTime,
    required this.thisMonthTime,
    required this.taskCount,
    required this.lastActivity,
  });

  final Duration totalTime;
  final Duration thisWeekTime;
  final Duration thisMonthTime;
  final int taskCount;
  final String lastActivity;
}