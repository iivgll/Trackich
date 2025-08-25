import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/system_tray/system_tray_service.dart';

// Navigation provider
final currentPageProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    AppLocalizations.of(context);

    // Initialize system tray context
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      SystemTrayService.setContext(context, ref);
    }

    return Scaffold(
      body: Row(
        children: [
          // Adaptive Sidebar
          _AdaptiveSidebar(
            currentPage: currentPage,
            onPageChanged: (page) =>
                ref.read(currentPageProvider.notifier).state = page,
          ),
          // Main Content Area
          Expanded(child: _getPageContent(currentPage)),
        ],
      ),
    );
  }

  Widget _getPageContent(int page) {
    switch (page) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const ProjectsScreen();
      case 2:
        return const CalendarScreen();
      case 3:
        return const AnalyticsScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }
}

class _AdaptiveSidebar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _AdaptiveSidebar({
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact =
        MediaQuery.of(context).size.width < AppTheme.tabletBreakpoint;

    return Container(
      width: isCompact ? AppTheme.space16 : AppTheme.sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppTheme.lightSurfaceGrouped
            : AppTheme.darkSurfaceGrouped,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? AppTheme.lightSeparator
                : AppTheme.darkSeparator,
            width: 0.33, // Apple border width
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo/Header Area
          Container(
            height: AppTheme.navigationHeight,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? AppTheme.space2 : AppTheme.space6,
              vertical: AppTheme.space4,
            ),
            child: isCompact
                ? Icon(
                    Symbols.timer,
                    size: 32,
                    color: AppTheme.getPrimaryColor(context),
                  )
                : Row(
                    children: [
                      Icon(
                        Symbols.timer,
                        size: 32,
                        color: AppTheme.getPrimaryColor(context),
                      ),
                      const SizedBox(width: AppTheme.space3),
                      Text(
                        AppLocalizations.of(context).appName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getPrimaryColor(context),
                        ),
                      ),
                    ],
                  ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? AppTheme.space1 : AppTheme.space3,
                vertical: AppTheme.space4,
              ),
              children: _buildNavigationItems(context, isCompact),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context, bool isCompact) {
    final l10n = AppLocalizations.of(context);
    final navigationItems = [
      _NavigationItem(icon: Symbols.dashboard, label: l10n.dashboard, index: 0),
      _NavigationItem(icon: Symbols.folder, label: l10n.projects, index: 1),
      _NavigationItem(
        icon: Symbols.calendar_month,
        label: l10n.calendar,
        index: 2,
      ),
      _NavigationItem(icon: Symbols.analytics, label: l10n.analytics, index: 3),
      _NavigationItem(icon: Symbols.settings, label: l10n.settings, index: 4),
    ];

    return navigationItems.map((item) {
      final isSelected = currentPage == item.index;

      return Container(
        margin: const EdgeInsets.only(bottom: AppTheme.space1),
        child: InkWell(
          onTap: () => onPageChanged(item.index),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            height: 44, // Apple list row height
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? AppTheme.space3 : AppTheme.space5,
              vertical: 0,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.getPrimaryColor(context).withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected
                      ? AppTheme.getPrimaryColor(context)
                      : (Theme.of(context).brightness == Brightness.light
                            ? AppTheme.lightTextSecondary
                            : AppTheme.darkTextSecondary),
                ),
                if (!isCompact) ...[
                  const SizedBox(width: AppTheme.space3),
                  Expanded(
                    child: Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? AppTheme.getPrimaryColor(context)
                            : (Theme.of(context).brightness == Brightness.light
                                  ? AppTheme.lightTextSecondary
                                  : AppTheme.darkTextSecondary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final int index;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}
