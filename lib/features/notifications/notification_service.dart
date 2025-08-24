import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';

// Provider for the notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  Timer? _breakTimer;
  Timer? _workTimer;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Android initialization
      const androidSettings = AndroidInitializationSettings(
        '@drawable/ic_notification',
      );

      // Darwin (iOS/macOS) initialization with proper settings
      const darwinSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        requestCriticalPermission: false,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Request permissions explicitly for macOS
      if (Platform.isMacOS) {
        final result = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        debugPrint('macOS notification permissions granted: $result');
      }

      // Request permissions for iOS
      if (Platform.isIOS) {
        final result = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        debugPrint('iOS notification permissions granted: $result');
      }

      _initialized = true;
      debugPrint(
        'Notification service initialized successfully for ${Platform.operatingSystem}',
      );
    } catch (e) {
      debugPrint('Failed to initialize notification service: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
    }
  }

  static void _onNotificationTap(NotificationResponse notificationResponse) {
    // Handle notification tap
    debugPrint('Notification tapped: ${notificationResponse.payload}');
  }

  // Show break reminder notification
  Future<void> showBreakReminder({
    required Duration workDuration,
    String? projectName,
    AppLocalizations? l10n,
  }) async {
    if (!_initialized) await initialize();

    // Check if notifications are enabled before showing
    final bool enabled = await areNotificationsEnabled();
    if (!enabled) {
      debugPrint('Notifications are disabled, skipping break reminder');
      return;
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'break_reminders',
        'Break Reminders',
        channelDescription: 'Notifications to remind you to take breaks',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      final workMinutes = workDuration.inMinutes;
      final projectText = projectName != null ? ' on $projectName' : '';

      final title = l10n != null
          ? '${l10n.timeForBreakTitle} 🌱'
          : 'Time for a Break! 🌱';
      final body = l10n != null
          ? l10n.breakReminderBody(projectText, workMinutes)
          : 'You have been working$projectText for ${workMinutes}m. Consider taking a short break to stay productive.';

      await _notificationsPlugin.show(
        1,
        title,
        body,
        notificationDetails,
        payload: 'break_reminder',
      );

      debugPrint(
        'Break reminder notification sent after ${workMinutes}m of work',
      );
    } catch (e) {
      debugPrint('Failed to show break reminder: $e');
    }
  }

  // Show work reminder notification
  Future<void> showWorkReminder({
    required Duration breakDuration,
    AppLocalizations? l10n,
  }) async {
    if (!_initialized) await initialize();

    // Check if notifications are enabled before showing
    final bool enabled = await areNotificationsEnabled();
    if (!enabled) {
      debugPrint('Notifications are disabled, skipping work reminder');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'work_reminders',
      'Work Reminders',
      channelDescription: 'Notifications to remind you to get back to work',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    final breakMinutes = breakDuration.inMinutes;

    final title = l10n != null
        ? '${l10n.backToWorkTitle} 🚀'
        : 'Break Time Over! 🚀';
    final body = l10n != null
        ? l10n.workReminderBody(breakMinutes)
        : 'You have been on break for $breakMinutes minutes. Ready to get back to work?';

    await _notificationsPlugin.show(
      2,
      title,
      body,
      notificationDetails,
      payload: 'work_reminder',
    );
  }

  // Show pomodoro completion notification
  Future<void> showPomodoroComplete({
    required String taskName,
    required String projectName,
    required Duration duration,
    AppLocalizations? l10n,
  }) async {
    if (!_initialized) await initialize();

    // Check if notifications are enabled before showing
    final bool enabled = await areNotificationsEnabled();
    if (!enabled) {
      debugPrint('Notifications are disabled, skipping pomodoro completion');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_complete',
      'Pomodoro Complete',
      channelDescription: 'Notifications when a pomodoro session is completed',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    final minutes = duration.inMinutes;

    final title = l10n != null
        ? '${l10n.taskCompletedTitle} ✅'
        : 'Task Completed! ✅';
    final body = l10n != null
        ? l10n.taskCompletedBody(taskName, projectName, minutes)
        : 'Great job! You completed "$taskName" in $projectName after ${minutes}m of focused work.';

    await _notificationsPlugin.show(
      3,
      title,
      body,
      notificationDetails,
      payload: 'pomodoro_complete',
    );
  }

  // Stop all timers and clear any pending notifications
  void stopAllTimers() {
    _breakTimer?.cancel();
    _workTimer?.cancel();
    _breakTimer = null;
    _workTimer = null;

    // Cancel any pending break reminder notifications
    cancelNotification(1);
  }

  // Clean shutdown method
  static void shutdown() {
    final instance = NotificationService();
    instance.stopAllTimers();
    instance.cancelAllNotifications();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (!_initialized) await initialize();

    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        if (androidImplementation != null) {
          final bool? enabled = await androidImplementation
              .areNotificationsEnabled();
          return enabled ?? false;
        }
      } else if (Platform.isIOS) {
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

        if (iosImplementation != null) {
          // For iOS, we'll use a simplified approach - assume enabled if we can create notifications
          return true;
        }
      } else if (Platform.isMacOS) {
        final macosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();

        if (macosImplementation != null) {
          // For macOS, we'll use a simplified approach - assume enabled if we can create notifications
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Failed to check notification permissions: $e');
      return false;
    }
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();

    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        if (androidImplementation != null) {
          final bool? granted = await androidImplementation
              .requestNotificationsPermission();
          return granted ?? false;
        }
      } else if (Platform.isIOS) {
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

        if (iosImplementation != null) {
          final bool? granted = await iosImplementation.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          return granted ?? false;
        }
      } else if (Platform.isMacOS) {
        final macosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();

        if (macosImplementation != null) {
          final bool? granted = await macosImplementation.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          return granted ?? false;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Failed to request notification permissions: $e');
      return false;
    }
  }

  // Test notification to verify the system is working
  Future<void> showTestNotification([AppLocalizations? l10n]) async {
    if (!_initialized) await initialize();

    try {
      const androidDetails = AndroidNotificationDetails(
        'test_notifications',
        'Test Notifications',
        channelDescription:
            'Test notifications to verify the system is working',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      final title = l10n != null
          ? '${l10n.testNotificationTitle} 🧪'
          : 'Test Notification 🧪';
      final body = l10n != null
          ? l10n.testNotificationBody
          : 'This is a test notification to verify that notifications are working properly.';

      await _notificationsPlugin.show(
        999,
        title,
        body,
        notificationDetails,
        payload: 'test_notification',
      );

      debugPrint('Test notification sent successfully');
    } catch (e) {
      debugPrint('Failed to show test notification: $e');
    }
  }
}
