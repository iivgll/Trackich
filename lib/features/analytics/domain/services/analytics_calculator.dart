import '../models/analytics_data.dart';
import '../../../../core/models/time_entry.dart';
import '../../../projects/domain/models/project.dart';

/// Service for calculating analytics using Attention Residue algorithm
/// Optimized for remote workers
class AnalyticsCalculator {
  /// Calculate analytics data from time entries and projects
  static AnalyticsData calculateAnalytics(
    List<TimeEntry> entries,
    List<Project> projects,
  ) {
    final workEntries = entries.where((e) => !e.isBreak).toList();
    final breakEntries = entries.where((e) => e.isBreak).toList();

    final totalWorkTime = workEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    final totalBreakTime = breakEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    // Calculate project analytics
    final projectAnalytics = <String, ProjectAnalytics>{};
    for (final project in projects) {
      final projectEntries = workEntries
          .where((e) => e.projectId == project.id)
          .toList();
      if (projectEntries.isNotEmpty) {
        projectAnalytics[project.id] = _calculateProjectAnalytics(
          project,
          projectEntries,
        );
      }
    }

    // Calculate daily data
    final dailyData = _calculateDailyData(entries);

    // Calculate focus score using Attention Residue algorithm
    final focusScore = _calculateFocusScore(workEntries, breakEntries);

    // Calculate productivity score
    final productivityScore = _calculateProductivityScore(workEntries);

    return AnalyticsData(
      totalWorkTime: totalWorkTime,
      totalBreakTime: totalBreakTime,
      completedTasks: workEntries.length,
      projectAnalytics: projectAnalytics,
      dailyData: dailyData,
      focusScore: focusScore,
      productivityScore: productivityScore,
    );
  }

  static ProjectAnalytics _calculateProjectAnalytics(
    Project project,
    List<TimeEntry> entries,
  ) {
    final totalTime = entries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    return ProjectAnalytics(
      projectId: project.id,
      projectName: project.name,
      projectColor: project.color,
      totalTime: totalTime,
      taskCount: entries.length,
      percentage: 0.0, // Will be calculated later with total context
    );
  }

  static List<DailyData> _calculateDailyData(List<TimeEntry> entries) {
    final dailyMap = <String, DailyData>{};

    for (final entry in entries) {
      final dateKey =
          '${entry.startTime.year}-${entry.startTime.month}-${entry.startTime.day}';
      final date = DateTime(
        entry.startTime.year,
        entry.startTime.month,
        entry.startTime.day,
      );

      if (dailyMap.containsKey(dateKey)) {
        final existing = dailyMap[dateKey]!;
        dailyMap[dateKey] = DailyData(
          date: date,
          workTime:
              existing.workTime +
              (entry.isBreak ? Duration.zero : entry.duration),
          breakTime:
              existing.breakTime +
              (entry.isBreak ? entry.duration : Duration.zero),
          taskCount: existing.taskCount + (entry.isBreak ? 0 : 1),
        );
      } else {
        dailyMap[dateKey] = DailyData(
          date: date,
          workTime: entry.isBreak ? Duration.zero : entry.duration,
          breakTime: entry.isBreak ? entry.duration : Duration.zero,
          taskCount: entry.isBreak ? 0 : 1,
        );
      }
    }

    return dailyMap.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Calculate focus score using Attention Residue algorithm
  /// Optimized for remote workers
  static double _calculateFocusScore(
    List<TimeEntry> workEntries,
    List<TimeEntry> breakEntries,
  ) {
    if (workEntries.isEmpty) return 0.0;

    // Алгоритм Attention Residue - оптимален для удаленных сотрудников

    // 1. Context Switch Score (50%) - время между переключениями проектов
    final contextSwitchScore = _calculateContextSwitchScore(workEntries);

    // 2. Project Focus Score (30%) - количество разных проектов в день
    final projectFocusScore = _calculateProjectFocusScore(workEntries);

    // 3. Deep Work Blocks Score (20%) - наличие длинных блоков концентрации
    final deepWorkScore = _calculateDeepWorkBlocksScore(workEntries);

    final focusScore =
        (contextSwitchScore * 0.5 +
            projectFocusScore * 0.3 +
            deepWorkScore * 0.2) *
        10;

    return focusScore.clamp(0.0, 10.0);
  }

  /// Calculate context switch penalty score
  static double _calculateContextSwitchScore(List<TimeEntry> workEntries) {
    if (workEntries.length < 2) return 1.0;

    // Сортируем по времени начала
    final sortedEntries = List<TimeEntry>.from(workEntries)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    double totalSwitchScore = 0.0;
    int switchCount = 0;

    for (int i = 0; i < sortedEntries.length - 1; i++) {
      final current = sortedEntries[i];
      final next = sortedEntries[i + 1];

      // Если сменился проект - это переключение контекста
      if (current.projectId != next.projectId) {
        switchCount++;

        final endTime = current.startTime.add(current.duration);
        final gapMinutes = next.startTime.difference(endTime).inMinutes;

        // Оценка времени между переключениями (больше = лучше)
        if (gapMinutes >= 60) {
          totalSwitchScore += 1.0; // Отлично: час+ между проектами
        } else if (gapMinutes >= 30) {
          totalSwitchScore += 0.8; // Хорошо: полчаса между проектами
        } else if (gapMinutes >= 15) {
          totalSwitchScore += 0.6; // Приемлемо: 15+ минут
        } else if (gapMinutes >= 5) {
          totalSwitchScore += 0.4; // Слабо: 5+ минут
        } else {
          totalSwitchScore += 0.2; // Плохо: мгновенные переключения
        }
      }
    }

    return switchCount > 0 ? totalSwitchScore / switchCount : 1.0;
  }

  /// Calculate project focus score based on daily project count
  static double _calculateProjectFocusScore(List<TimeEntry> workEntries) {
    if (workEntries.isEmpty) return 0.0;

    // Группируем по дням
    final dailyProjectCounts = <String, Set<String?>>{};

    for (final entry in workEntries) {
      final dateKey =
          '${entry.startTime.year}-${entry.startTime.month}-${entry.startTime.day}';
      dailyProjectCounts.putIfAbsent(dateKey, () => <String?>{});
      dailyProjectCounts[dateKey]!.add(entry.projectId);
    }

    if (dailyProjectCounts.isEmpty) return 0.0;

    double totalDayScores = 0.0;

    for (final projectsPerDay in dailyProjectCounts.values) {
      final projectCount = projectsPerDay.length;

      // Оптимальное количество проектов в день: 2-3
      if (projectCount == 1) {
        totalDayScores += 0.9; // Очень хорошо: один проект
      } else if (projectCount == 2) {
        totalDayScores += 1.0; // Идеально: два проекта
      } else if (projectCount == 3) {
        totalDayScores += 0.9; // Хорошо: три проекта
      } else if (projectCount == 4) {
        totalDayScores += 0.6; // Приемлемо: четыре проекта
      } else if (projectCount <= 6) {
        totalDayScores += 0.4; // Слабо: 5-6 проектов
      } else {
        totalDayScores += 0.2; // Плохо: >6 проектов в день
      }
    }

    return totalDayScores / dailyProjectCounts.length;
  }

  /// Calculate deep work blocks score
  static double _calculateDeepWorkBlocksScore(List<TimeEntry> workEntries) {
    if (workEntries.isEmpty) return 0.0;

    // Находим непрерывные блоки работы ≥60 минут
    int deepWorkBlocks = 0;
    double totalDeepWorkMinutes = 0.0;
    double totalWorkMinutes = 0.0;

    // Группируем по проектам и ищем длинные сессии
    final projectSessions = <String?, List<TimeEntry>>{};

    for (final entry in workEntries) {
      projectSessions.putIfAbsent(entry.projectId, () => []);
      projectSessions[entry.projectId]!.add(entry);
      totalWorkMinutes += entry.duration.inMinutes;
    }

    // Для каждого проекта ищем длинные блоки
    for (final sessions in projectSessions.values) {
      sessions.sort((a, b) => a.startTime.compareTo(b.startTime));

      for (final session in sessions) {
        if (session.duration.inMinutes >= 60) {
          deepWorkBlocks++;
          totalDeepWorkMinutes += session.duration.inMinutes;
        }
      }
    }

    // Если нет глубокой работы
    if (deepWorkBlocks == 0) return 0.2;

    // Процент времени в глубокой работе
    final deepWorkRatio = totalWorkMinutes > 0
        ? totalDeepWorkMinutes / totalWorkMinutes
        : 0.0;

    // Частота глубокой работы (блоков в день)
    final daysWorked = workEntries
        .map(
          (e) => '${e.startTime.year}-${e.startTime.month}-${e.startTime.day}',
        )
        .toSet()
        .length;

    final deepWorkFrequency = daysWorked > 0
        ? deepWorkBlocks / daysWorked
        : 0.0;

    // Комбинированная оценка
    double score = 0.0;

    // 60% - процент глубокой работы
    if (deepWorkRatio >= 0.6) {
      score += 0.6; // 60%+ времени в глубокой работе
    } else if (deepWorkRatio >= 0.4) {
      score += 0.5; // 40-60%
    } else if (deepWorkRatio >= 0.2) {
      score += 0.3; // 20-40%
    } else {
      score += 0.1; // <20%
    }

    // 40% - частота глубокой работы
    if (deepWorkFrequency >= 2.0) {
      score += 0.4; // 2+ блока в день
    } else if (deepWorkFrequency >= 1.0) {
      score += 0.3; // 1+ блок в день
    } else if (deepWorkFrequency >= 0.5) {
      score += 0.2; // блок через день
    } else {
      score += 0.1; // редкие блоки
    }

    return score;
  }

  static double _calculateProductivityScore(List<TimeEntry> workEntries) {
    if (workEntries.isEmpty) return 0.0;

    final totalHours = workEntries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.duration.inMinutes / 60,
    );
    final tasksPerHour = workEntries.length / totalHours;

    // Good productivity: 1-3 tasks per hour
    final productivityScore = (tasksPerHour / 2).clamp(0.0, 1.0);

    return (productivityScore * 10).clamp(0.0, 10.0);
  }
}
