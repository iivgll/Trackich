import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/storage_service.dart';

part 'daily_time_provider.g.dart';

@riverpod
Future<Duration> dailyWorkTime(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));

  try {
    final entries = await storage.getTimeEntries();

    // Фильтруем записи за сегодня (только завершенные и не перерывы)
    final todayEntries = entries.where((entry) {
      return entry.isCompleted &&
          !entry.isBreak &&
          entry.startTime.isAfter(todayStart) &&
          entry.startTime.isBefore(todayEnd);
    }).toList();

    // Суммируем время
    final totalDuration = todayEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + entry.duration,
    );

    return totalDuration;
  } catch (e) {
    return Duration.zero;
  }
}

// Простой провайдер для обновления времени
final dailyTimeRefreshProvider = StateProvider<int>((ref) => 0);

// Провайдер для актуального времени работы за сегодня
@riverpod
Future<Duration> currentDailyWorkTime(Ref ref) async {
  // Следим за провайдером обновления
  ref.watch(dailyTimeRefreshProvider);

  // Автоматически обновляем каждую минуту
  final timer = Timer.periodic(const Duration(minutes: 1), (timer) {
    if (ref.exists(dailyTimeRefreshProvider)) {
      ref.read(dailyTimeRefreshProvider.notifier).state++;
    } else {
      timer.cancel();
    }
  });

  // Отменяем таймер при dispose
  ref.onDispose(() => timer.cancel());

  return ref.watch(dailyWorkTimeProvider.future);
}
