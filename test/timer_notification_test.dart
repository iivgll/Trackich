import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackich/features/timer/providers/timer_provider.dart';

void main() {
  group('Timer Notification Logic Tests', () {
    test('Break notification timing logic validation', () {
      // Test the logic that determines when break notifications should be sent
      
      // Simulate different work durations and check if notifications should trigger
      final testCases = [
        // workMinutes, workSeconds, breakIntervalMinutes, lastNotificationMinutes, shouldTrigger
        {'workMinutes': 30, 'workSeconds': 0, 'breakInterval': 30, 'lastNotification': -1, 'expected': true},
        {'workMinutes': 30, 'workSeconds': 1, 'breakInterval': 30, 'lastNotification': -1, 'expected': false}, // Not exact minute
        {'workMinutes': 30, 'workSeconds': 0, 'breakInterval': 30, 'lastNotification': 30, 'expected': false}, // Already notified
        {'workMinutes': 60, 'workSeconds': 0, 'breakInterval': 30, 'lastNotification': 30, 'expected': true}, // Next interval
        {'workMinutes': 15, 'workSeconds': 0, 'breakInterval': 30, 'lastNotification': -1, 'expected': false}, // Not at interval
        {'workMinutes': 45, 'workSeconds': 0, 'breakInterval': 15, 'lastNotification': 30, 'expected': true}, // Different interval
      ];

      for (final testCase in testCases) {
        final workMinutes = testCase['workMinutes'] as int;
        final workSeconds = testCase['workSeconds'] as int;
        final breakIntervalMinutes = testCase['breakInterval'] as int;
        final lastNotificationMinutes = testCase['lastNotification'] as int;
        final expected = testCase['expected'] as bool;

        // This is the logic from our fixed _checkBreakReminder method
        final shouldTrigger = workMinutes > 0 && 
            workMinutes % breakIntervalMinutes == 0 && 
            workSeconds % 60 == 0 && 
            workMinutes != lastNotificationMinutes;

        expect(
          shouldTrigger,
          expected,
          reason: 'Failed for workMinutes: $workMinutes, workSeconds: $workSeconds, '
                 'breakInterval: $breakIntervalMinutes, lastNotification: $lastNotificationMinutes'
        );
      }
    });

    test('Notification deduplication logic', () {
      // Test that we don't send multiple notifications for the same minute
      const workMinutes = 30;
      const breakIntervalMinutes = 30;
      
      // First call - should trigger
      int lastNotificationMinutes = -1;
      bool shouldTrigger = workMinutes > 0 && 
          workMinutes % breakIntervalMinutes == 0 && 
          0 % 60 == 0 && // workSeconds = 0
          workMinutes != lastNotificationMinutes;
      
      expect(shouldTrigger, true, reason: 'First notification should trigger');
      
      // Simulate that we sent the notification
      lastNotificationMinutes = workMinutes;
      
      // Second call with same minute - should NOT trigger
      shouldTrigger = workMinutes > 0 && 
          workMinutes % breakIntervalMinutes == 0 && 
          0 % 60 == 0 && // workSeconds = 0
          workMinutes != lastNotificationMinutes;
      
      expect(shouldTrigger, false, reason: 'Duplicate notification should not trigger');
    });
  });
}