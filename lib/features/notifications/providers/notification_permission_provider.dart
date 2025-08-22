import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notification_permission_provider.g.dart';

enum NotificationPermissionStatus {
  granted,
  denied,
  notDetermined,
  provisional, // iOS only
}

class NotificationPermissionState {
  final NotificationPermissionStatus status;
  final bool isLoading;
  final String? error;
  final bool canOpenSettings;

  const NotificationPermissionState({
    required this.status,
    this.isLoading = false,
    this.error,
    this.canOpenSettings = false,
  });

  NotificationPermissionState copyWith({
    NotificationPermissionStatus? status,
    bool? isLoading,
    String? error,
    bool? canOpenSettings,
  }) {
    return NotificationPermissionState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      canOpenSettings: canOpenSettings ?? this.canOpenSettings,
    );
  }
}

@riverpod
class NotificationPermission extends _$NotificationPermission {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  NotificationPermissionState build() {
    // Return initial state - DO NOT call async methods here
    // Use a separate method to check permissions after initialization
    return const NotificationPermissionState(
      status: NotificationPermissionStatus.notDetermined,
      isLoading: false,
    );
  }

  /// Checks current notification permission status
  Future<void> _checkPermissionStatus() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      NotificationPermissionStatus status;
      
      if (Platform.isAndroid) {
        status = await _checkAndroidPermissions();
      } else if (Platform.isIOS) {
        status = await _checkIOSPermissions();
      } else if (Platform.isMacOS) {
        status = await _checkMacOSPermissions();
      } else {
        // For other platforms, assume granted for now
        status = NotificationPermissionStatus.granted;
      }

      state = state.copyWith(
        status: status,
        isLoading: false,
        canOpenSettings: status == NotificationPermissionStatus.denied,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check permission status: $e',
      );
    }
  }

  /// Check Android notification permissions
  Future<NotificationPermissionStatus> _checkAndroidPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation == null) {
      return NotificationPermissionStatus.notDetermined;
    }

    // For Android 13+, we need to check if notification permission is granted
    try {
      final bool? areNotificationsEnabled = await androidImplementation.areNotificationsEnabled();
      if (areNotificationsEnabled == true) {
        return NotificationPermissionStatus.granted;
      } else if (areNotificationsEnabled == false) {
        return NotificationPermissionStatus.denied;
      }
    } catch (e) {
      // Fallback for older Android versions
    }

    return NotificationPermissionStatus.notDetermined;
  }

  /// Check iOS notification permissions
  Future<NotificationPermissionStatus> _checkIOSPermissions() async {
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation == null) {
      return NotificationPermissionStatus.notDetermined;
    }

    try {
      // For iOS, we'll simplify and use permission request to determine status
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (granted == true) {
        return NotificationPermissionStatus.granted;
      } else {
        return NotificationPermissionStatus.denied;
      }
    } catch (e) {
      // Handle error checking permissions
    }

    return NotificationPermissionStatus.notDetermined;
  }

  /// Check macOS notification permissions
  Future<NotificationPermissionStatus> _checkMacOSPermissions() async {
    final macosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    
    if (macosImplementation == null) {
      return NotificationPermissionStatus.notDetermined;
    }

    try {
      // For macOS, we'll simplify and use permission request to determine status
      final bool? granted = await macosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (granted == true) {
        return NotificationPermissionStatus.granted;
      } else {
        return NotificationPermissionStatus.denied;
      }
    } catch (e) {
      // Handle error checking permissions
    }

    return NotificationPermissionStatus.notDetermined;
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      bool granted = false;
      
      if (Platform.isAndroid) {
        granted = await _requestAndroidPermissions();
      } else if (Platform.isIOS) {
        granted = await _requestIOSPermissions();
      } else if (Platform.isMacOS) {
        granted = await _requestMacOSPermissions();
      } else {
        // For other platforms, assume granted
        granted = true;
      }

      // Update status after requesting permissions
      await _checkPermissionStatus();
      
      return granted;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to request permissions: $e',
      );
      return false;
    }
  }

  /// Request Android notification permissions
  Future<bool> _requestAndroidPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation == null) {
      return false;
    }

    try {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Request iOS notification permissions
  Future<bool> _requestIOSPermissions() async {
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation == null) {
      return false;
    }

    try {
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Request macOS notification permissions
  Future<bool> _requestMacOSPermissions() async {
    final macosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    
    if (macosImplementation == null) {
      return false;
    }

    try {
      final bool? granted = await macosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Open system notification settings
  Future<void> openNotificationSettings() async {
    try {
      if (Platform.isAndroid) {
        // On Android, we can guide user to settings but cannot open directly
        // The app should show instructions to manually navigate to settings
      } else if (Platform.isIOS || Platform.isMacOS) {
        // iOS and macOS don't provide direct API to open notification settings
        // The app should show instructions to manually navigate to settings
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to open notification settings: $e',
      );
    }
  }

  /// Refresh permission status
  Future<void> refreshPermissionStatus() async {
    await _checkPermissionStatus();
  }

  /// Get human-readable permission status description
  String getPermissionStatusDescription() {
    switch (state.status) {
      case NotificationPermissionStatus.granted:
        return 'Notifications are enabled';
      case NotificationPermissionStatus.denied:
        return 'Notifications are disabled';
      case NotificationPermissionStatus.notDetermined:
        return 'Notification permission not requested';
      case NotificationPermissionStatus.provisional:
        return 'Notifications are provisionally enabled';
    }
  }

  /// Check if notifications can be shown
  bool get canShowNotifications {
    return state.status == NotificationPermissionStatus.granted ||
           state.status == NotificationPermissionStatus.provisional;
  }

  /// Check if we should show permission request UI
  bool get shouldShowPermissionRequest {
    return state.status == NotificationPermissionStatus.notDetermined ||
           state.status == NotificationPermissionStatus.denied;
  }
}