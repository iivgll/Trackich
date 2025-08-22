import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/settings/providers/settings_provider.dart';
import '../../../features/notifications/notification_service.dart';
import '../../../features/notifications/providers/notification_permission_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.gray50 
          : AppTheme.gray900,
      body: Column(
        children: [
          // Header
          _buildHeader(context, l10n),
          
          // Settings content
          Expanded(
            child: settingsAsync.when(
              data: (settings) => _buildSettingsContent(context, l10n, ref, settings),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Symbols.error, size: 64, color: AppTheme.errorRed),
                    const SizedBox(height: AppTheme.space4),
                    Text('Error loading settings: $error'),
                    const SizedBox(height: AppTheme.space4),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(settingsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            l10n.settings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, AppLocalizations l10n, WidgetRef ref, settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General Settings
          _buildSectionTitle(context, l10n.general),
          _buildGeneralSettings(context, l10n, ref, settings),
          const SizedBox(height: AppTheme.space8),
          
          // Timer & Breaks
          _buildSectionTitle(context, l10n.timerAndBreaks),
          _buildTimerSettings(context, l10n, ref, settings),
          const SizedBox(height: AppTheme.space8),
          
          // Notifications
          _buildSectionTitle(context, l10n.notifications),
          _buildNotificationSettings(context, l10n, ref, settings),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context, AppLocalizations l10n, WidgetRef ref, settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          children: [
            // Theme setting
            ListTile(
              leading: const Icon(Symbols.palette),
              title: Text(l10n.theme),
              subtitle: Text(_getThemeName(context, settings.themeMode)),
              trailing: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.systemTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.lightTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.darkTheme),
                  ),
                ],
                onChanged: (theme) {
                  if (theme != null) {
                    ref.read(settingsProvider.notifier).updateThemeMode(theme);
                  }
                },
              ),
            ),
            
            const Divider(),
            
            // Language setting
            ListTile(
              leading: const Icon(Symbols.language),
              title: Text(l10n.language),
              subtitle: Text(_getLanguageName(settings.language)),
              trailing: DropdownButton<String>(
                value: settings.language,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'ru',
                    child: Text('Русский'),
                  ),
                ],
                onChanged: (language) {
                  if (language != null) {
                    ref.read(settingsProvider.notifier).updateLanguage(language);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSettings(BuildContext context, AppLocalizations l10n, WidgetRef ref, settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          children: [
            // Short break duration
            ListTile(
              leading: const Icon(Symbols.coffee),
              title: Text(l10n.shortBreak),
              subtitle: Text('${settings.shortBreakDuration.inMinutes} ${l10n.minutes}'),
              trailing: SizedBox(
                width: 100,
                child: Slider(
                  value: settings.shortBreakDuration.inMinutes.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 5,
                  label: '${settings.shortBreakDuration.inMinutes} min',
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateTimerIntervals(
                      shortBreakDuration: Duration(minutes: value.round()),
                    );
                  },
                ),
              ),
            ),
            
            const Divider(),
            
            // Long break duration
            ListTile(
              leading: const Icon(Symbols.coffee),
              title: Text(l10n.longBreak),
              subtitle: Text('${settings.longBreakDuration.inMinutes} ${l10n.minutes}'),
              trailing: SizedBox(
                width: 100,
                child: Slider(
                  value: settings.longBreakDuration.inMinutes.toDouble(),
                  min: 15,
                  max: 60,
                  divisions: 9,
                  label: '${settings.longBreakDuration.inMinutes} min',
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateTimerIntervals(
                      longBreakDuration: Duration(minutes: value.round()),
                    );
                  },
                ),
              ),
            ),
            
            const Divider(),
            
            // Break reminders
            SwitchListTile(
              secondary: const Icon(Symbols.alarm),
              title: const Text('Break Reminders'),
              subtitle: const Text('Get notified to take breaks'),
              value: settings.enableBreakReminders,
              onChanged: (enabled) {
                ref.read(settingsProvider.notifier).updateNotificationSettings(
                  enableBreakReminders: enabled,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, AppLocalizations l10n, WidgetRef ref, settings) {
    final permissionState = ref.watch(notificationPermissionProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          children: [
            // Permission status indicator
            _buildPermissionStatusTile(context, l10n, ref, permissionState),
            
            const Divider(),
            
            SwitchListTile(
              secondary: const Icon(Symbols.notifications),
              title: Text(l10n.enableNotifications),
              subtitle: Text(permissionState.status == NotificationPermissionStatus.granted 
                  ? 'Enable app notifications'
                  : 'Notification permissions required'),
              value: settings.enableNotifications && permissionState.status == NotificationPermissionStatus.granted,
              onChanged: permissionState.status == NotificationPermissionStatus.granted 
                  ? (enabled) {
                      ref.read(settingsProvider.notifier).updateNotificationSettings(
                        enableNotifications: enabled,
                      );
                    }
                  : null,
            ),
            
            const Divider(),
            
            // Test notification button
            ListTile(
              leading: const Icon(Symbols.notification_add),
              title: const Text('Test Notifications'),
              subtitle: const Text('Send a test notification to verify the system is working'),
              trailing: ElevatedButton.icon(
                onPressed: (permissionState.status == NotificationPermissionStatus.granted && 
                           settings.enableNotifications && 
                           !permissionState.isLoading) 
                    ? () async {
                        final notificationService = ref.read(notificationServiceProvider);
                        await notificationService.showTestNotification();
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Test notification sent! Check your notification center.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    : null,
                icon: permissionState.isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Symbols.send),
                label: const Text('Test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStatusTile(
    BuildContext context, 
    AppLocalizations l10n, 
    WidgetRef ref, 
    NotificationPermissionState permissionState,
  ) {
    IconData statusIcon;
    Color statusColor;
    String statusText;
    String statusSubtitle;
    Widget? trailing;

    switch (permissionState.status) {
      case NotificationPermissionStatus.granted:
        statusIcon = Symbols.check_circle;
        statusColor = AppTheme.successGreen;
        statusText = 'Notifications Enabled';
        statusSubtitle = 'System notifications are working properly';
        trailing = IconButton(
          icon: const Icon(Symbols.refresh),
          onPressed: () => ref.read(notificationPermissionProvider.notifier).refreshPermissionStatus(),
          tooltip: 'Refresh status',
        );
        break;
      case NotificationPermissionStatus.denied:
        statusIcon = Symbols.block;
        statusColor = AppTheme.errorRed;
        statusText = 'Notifications Disabled';
        statusSubtitle = 'Enable in system settings to receive notifications';
        trailing = ElevatedButton.icon(
          icon: const Icon(Symbols.settings),
          label: const Text('Settings'),
          onPressed: () => _showPermissionInstructions(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.warningOrange,
            foregroundColor: Colors.white,
          ),
        );
        break;
      case NotificationPermissionStatus.notDetermined:
        statusIcon = Symbols.help;
        statusColor = AppTheme.warningOrange;
        statusText = 'Permission Required';
        statusSubtitle = 'Tap to request notification permissions';
        trailing = ElevatedButton.icon(
          icon: const Icon(Symbols.notification_add),
          label: const Text('Request'),
          onPressed: permissionState.isLoading 
              ? null 
              : () async {
                  final granted = await ref.read(notificationPermissionProvider.notifier).requestPermissions();
                  if (context.mounted && granted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification permissions granted!'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
          ),
        );
        break;
      case NotificationPermissionStatus.provisional:
        statusIcon = Symbols.notifications_paused;
        statusColor = AppTheme.warningOrange;
        statusText = 'Provisional Notifications';
        statusSubtitle = 'Notifications delivered quietly';
        trailing = IconButton(
          icon: const Icon(Symbols.refresh),
          onPressed: () => ref.read(notificationPermissionProvider.notifier).refreshPermissionStatus(),
          tooltip: 'Refresh status',
        );
        break;
    }

    if (permissionState.error != null) {
      statusIcon = Symbols.error;
      statusColor = AppTheme.errorRed;
      statusText = 'Permission Error';
      statusSubtitle = permissionState.error!;
      trailing = IconButton(
        icon: const Icon(Symbols.refresh),
        onPressed: () => ref.read(notificationPermissionProvider.notifier).refreshPermissionStatus(),
        tooltip: 'Retry',
      );
    }

    return ListTile(
      leading: permissionState.isLoading
          ? const CircularProgressIndicator()
          : Icon(
              statusIcon,
              color: statusColor,
            ),
      title: Text(statusText),
      subtitle: Text(statusSubtitle),
      trailing: trailing,
    );
  }

  void _showPermissionInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To enable notifications for Trackich:'),
            SizedBox(height: 16),
            Text('1. Open your device Settings'),
            Text('2. Find "Notifications" or "Apps & notifications"'),
            Text('3. Find "Trackich" in the app list'),
            Text('4. Toggle notifications ON'),
            SizedBox(height: 16),
            Text(
              'After enabling, return to this screen and tap the refresh button.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getThemeName(BuildContext context, ThemeMode themeMode) {
    final l10n = AppLocalizations.of(context);
    switch (themeMode) {
      case ThemeMode.system:
        return l10n.systemTheme;
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkTheme;
    }
  }

  String _getLanguageName(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return 'Unknown';
    }
  }
}