import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/notifications/notification_service.dart';
import '../../../../features/notifications/providers/notification_permission_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/settings_provider.dart';

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
              data: (settings) =>
                  _buildSettingsContent(context, l10n, ref, settings),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.error,
                      size: 64,
                      color: AppTheme.getErrorColor(context),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      '${AppLocalizations.of(context).error} loading settings: $error',
                    ),
                    const SizedBox(height: AppTheme.space4),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(settingsProvider),
                      child: Text(AppLocalizations.of(context).retry),
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
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            l10n.settings,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    settings,
  ) {
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
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildGeneralSettings(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    settings,
  ) {
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
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(AppLocalizations.of(context).english),
                  ),
                  DropdownMenuItem(
                    value: 'ru',
                    child: Text(AppLocalizations.of(context).russian),
                  ),
                ],
                onChanged: (language) {
                  if (language != null) {
                    ref
                        .read(settingsProvider.notifier)
                        .updateLanguage(language);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSettings(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    settings,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          children: [
            // Break interval setting
            ListTile(
              leading: const Icon(Symbols.schedule),
              title: Text(l10n.breakInterval),
              subtitle: Text(
                l10n.breakReminderDescription(settings.breakInterval.inMinutes),
              ),
              trailing: SizedBox(
                width: 120,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        initialValue: settings.breakInterval.inMinutes
                            .toString(),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final minutes = int.tryParse(value);
                          if (minutes != null &&
                              minutes > 0 &&
                              minutes <= 120) {
                            ref
                                .read(settingsProvider.notifier)
                                .updateBreakInterval(
                                  Duration(minutes: minutes),
                                );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).min),
                  ],
                ),
              ),
            ),

            const Divider(),

            // Break reminders toggle
            SwitchListTile(
              secondary: const Icon(Symbols.alarm),
              title: Text(l10n.breakRemindersToggle),
              subtitle: Text(l10n.breakRemindersDescription),
              value: settings.enableBreakReminders,
              onChanged: (enabled) {
                ref
                    .read(settingsProvider.notifier)
                    .updateNotificationSettings(enableBreakReminders: enabled);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    settings,
  ) {
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
              subtitle: Text(
                permissionState.status == NotificationPermissionStatus.granted
                    ? l10n.enableAppNotifications
                    : l10n.notificationPermissionsRequired,
              ),
              value:
                  settings.enableNotifications &&
                  permissionState.status ==
                      NotificationPermissionStatus.granted,
              onChanged:
                  permissionState.status == NotificationPermissionStatus.granted
                  ? (enabled) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateNotificationSettings(
                            enableNotifications: enabled,
                          );
                    }
                  : null,
            ),

            const Divider(),

            // Test notification button
            ListTile(
              leading: const Icon(Symbols.notification_add),
              title: Text(AppLocalizations.of(context).testNotifications),
              subtitle: Text(
                AppLocalizations.of(context).testNotificationsSubtitle,
              ),
              trailing: ElevatedButton.icon(
                onPressed:
                    (permissionState.status ==
                            NotificationPermissionStatus.granted &&
                        settings.enableNotifications &&
                        !permissionState.isLoading)
                    ? () async {
                        final notificationService = ref.read(
                          notificationServiceProvider,
                        );
                        await notificationService.showTestNotification(l10n);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                ).testNotificationSent,
                              ),
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
                label: Text(AppLocalizations.of(context).test),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getPrimaryColor(context),
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
        statusText = l10n.notificationsEnabled;
        statusSubtitle = l10n.notificationsEnabledDescription;
        trailing = IconButton(
          icon: const Icon(Symbols.refresh),
          onPressed: () => ref
              .read(notificationPermissionProvider.notifier)
              .refreshPermissionStatus(),
          tooltip: l10n.refreshStatus,
        );
        break;
      case NotificationPermissionStatus.denied:
        statusIcon = Symbols.block;
        statusColor = AppTheme.getErrorColor(context);
        statusText = l10n.notificationsDisabled;
        statusSubtitle = l10n.notificationsDisabledDescription;
        trailing = ElevatedButton.icon(
          icon: const Icon(Symbols.settings),
          label: Text(l10n.settings),
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
        statusText = l10n.permissionRequired;
        statusSubtitle = l10n.permissionRequiredDescription;
        trailing = ElevatedButton.icon(
          icon: const Icon(Symbols.notification_add),
          label: Text(AppLocalizations.of(context).request),
          onPressed: permissionState.isLoading
              ? null
              : () async {
                  final granted = await ref
                      .read(notificationPermissionProvider.notifier)
                      .requestPermissions();
                  if (context.mounted && granted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          ).notificationPermissionsGranted,
                        ),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.getPrimaryColor(context),
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
          onPressed: () => ref
              .read(notificationPermissionProvider.notifier)
              .refreshPermissionStatus(),
          tooltip: l10n.refreshStatus,
        );
        break;
    }

    if (permissionState.error != null) {
      statusIcon = Symbols.error;
      statusColor = AppTheme.getErrorColor(context);
      statusText = 'Permission Error';
      statusSubtitle = permissionState.error!;
      trailing = IconButton(
        icon: const Icon(Symbols.refresh),
        onPressed: () => ref
            .read(notificationPermissionProvider.notifier)
            .refreshPermissionStatus(),
        tooltip: 'Retry',
      );
    }

    return ListTile(
      leading: permissionState.isLoading
          ? const CircularProgressIndicator()
          : Icon(statusIcon, color: statusColor),
      title: Text(statusText),
      subtitle: Text(statusSubtitle),
      trailing: trailing,
    );
  }

  void _showPermissionInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).enableNotificationsTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).enableNotificationsInstructions),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context).step1),
            Text(AppLocalizations.of(context).step2),
            Text(AppLocalizations.of(context).step3),
            Text(AppLocalizations.of(context).step4),
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
            child: Text(AppLocalizations.of(context).ok),
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
