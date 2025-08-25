import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/storage_service.dart';
import '../../../projects/presentation/providers/projects_provider.dart';

part 'timer_recovery_provider.g.dart';

/// Provider to check for recovery data on app startup
@riverpod
Future<TimerRecoveryData?> timerRecovery(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  final recoveryData = await storage.getRecoveryData();

  if (recoveryData == null) return null;

  // Get project details
  final projects = await ref.read(projectsProvider.future);
  final project = projects
      .where((p) => p.id == recoveryData['projectId'])
      .firstOrNull;

  if (project == null) {
    // Project doesn't exist anymore, clear recovery data
    await storage.clearRecoveryData();
    return null;
  }

  return TimerRecoveryData(
    projectId: recoveryData['projectId'],
    project: project,
    taskName: recoveryData['taskName'],
    duration: Duration(milliseconds: recoveryData['duration']),
    recoveryDataMap: recoveryData,
  );
}

/// Recovery data model
class TimerRecoveryData {
  final String projectId;
  final dynamic project; // Project object
  final String taskName;
  final Duration duration;
  final Map<String, dynamic> recoveryDataMap;

  const TimerRecoveryData({
    required this.projectId,
    required this.project,
    required this.taskName,
    required this.duration,
    required this.recoveryDataMap,
  });
}
