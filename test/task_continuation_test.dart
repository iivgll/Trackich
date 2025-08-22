import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackich/core/services/storage_service.dart';
import 'package:trackich/core/models/time_entry.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Task Continuation Tests', () {
    late StorageService storageService;
    const uuid = Uuid();

    setUp(() async {
      // Initialize SharedPreferences with in-memory implementation for testing
      SharedPreferences.setMockInitialValues({});
      storageService = StorageService();
      await storageService.init();
    });

    test('should find existing task with same project and name', () async {
      const projectId = 'test-project';
      const taskName = 'Test Task';

      // Create first task entry
      final firstEntry = TimeEntry(
        id: uuid.v4(),
        projectId: projectId,
        taskName: taskName,
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 1)),
        duration: const Duration(minutes: 60),
        totalAccumulatedTime: const Duration(minutes: 60),
        isCompleted: true,
      );

      await storageService.saveTimeEntry(firstEntry);

      // Test finding existing task
      final existingTask = await storageService.findExistingTask(projectId, taskName);
      expect(existingTask, isNotNull);
      expect(existingTask!.projectId, equals(projectId));
      expect(existingTask.taskName, equals(taskName));
    });

    test('should calculate total accumulated time correctly', () async {
      const projectId = 'test-project';
      const taskName = 'Test Task';

      // Create multiple task entries
      final entries = [
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId,
          taskName: taskName,
          startTime: DateTime.now().subtract(const Duration(hours: 3)),
          endTime: DateTime.now().subtract(const Duration(hours: 2)),
          duration: const Duration(minutes: 60),
          totalAccumulatedTime: const Duration(minutes: 60),
          isCompleted: true,
        ),
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId,
          taskName: taskName,
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          endTime: DateTime.now().subtract(const Duration(hours: 1)),
          duration: const Duration(minutes: 45),
          totalAccumulatedTime: const Duration(minutes: 105), // 60 + 45
          isCompleted: true,
        ),
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId,
          taskName: taskName,
          startTime: DateTime.now().subtract(const Duration(minutes: 30)),
          endTime: DateTime.now(),
          duration: const Duration(minutes: 30),
          totalAccumulatedTime: const Duration(minutes: 135), // 105 + 30
          isCompleted: true,
        ),
      ];

      for (final entry in entries) {
        await storageService.saveTimeEntry(entry);
      }

      // Test total accumulated time calculation
      final totalTime = await storageService.getTotalAccumulatedTimeForTask(projectId, taskName);
      expect(totalTime, equals(const Duration(minutes: 135))); // 60 + 45 + 30
    });

    test('should group tasks correctly by project and name', () async {
      const projectId1 = 'project-1';
      const projectId2 = 'project-2';
      const taskName1 = 'Task One';
      const taskName2 = 'Task Two';

      // Create entries for different task groups
      final entries = [
        // Project 1, Task One - 2 sessions
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId1,
          taskName: taskName1,
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          endTime: DateTime.now().subtract(const Duration(hours: 1)),
          duration: const Duration(minutes: 60),
          isCompleted: true,
        ),
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId1,
          taskName: taskName1,
          startTime: DateTime.now().subtract(const Duration(minutes: 30)),
          endTime: DateTime.now(),
          duration: const Duration(minutes: 30),
          isCompleted: true,
        ),
        // Project 1, Task Two - 1 session
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId1,
          taskName: taskName2,
          startTime: DateTime.now().subtract(const Duration(hours: 3)),
          endTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          duration: const Duration(minutes: 30),
          isCompleted: true,
        ),
        // Project 2, Task One - 1 session
        TimeEntry(
          id: uuid.v4(),
          projectId: projectId2,
          taskName: taskName1,
          startTime: DateTime.now().subtract(const Duration(hours: 4)),
          endTime: DateTime.now().subtract(const Duration(hours: 3, minutes: 15)),
          duration: const Duration(minutes: 45),
          isCompleted: true,
        ),
      ];

      for (final entry in entries) {
        await storageService.saveTimeEntry(entry);
      }

      // Test task grouping
      final taskGroupEntries1 = await storageService.getTaskGroupEntries(projectId1, taskName1);
      expect(taskGroupEntries1.length, equals(2));

      final taskGroupEntries2 = await storageService.getTaskGroupEntries(projectId1, taskName2);
      expect(taskGroupEntries2.length, equals(1));

      final taskGroupEntries3 = await storageService.getTaskGroupEntries(projectId2, taskName1);
      expect(taskGroupEntries3.length, equals(1));
    });

    test('should handle case-insensitive task names', () async {
      const projectId = 'test-project';
      const taskName1 = 'Test Task';
      const taskName2 = 'test task'; // Different case

      // Create task entry
      final entry = TimeEntry(
        id: uuid.v4(),
        projectId: projectId,
        taskName: taskName1,
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        endTime: DateTime.now(),
        duration: const Duration(minutes: 60),
        isCompleted: true,
      );

      await storageService.saveTimeEntry(entry);

      // Test finding with different case
      final existingTask = await storageService.findExistingTask(projectId, taskName2);
      expect(existingTask, isNotNull);
      expect(existingTask!.taskName, equals(taskName1)); // Should find original case
    });
  });
}