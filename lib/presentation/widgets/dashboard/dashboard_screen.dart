import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/timer_widget.dart';
import 'widgets/today_summary_widget.dart';
import 'widgets/quick_start_widget.dart';
import 'widgets/enhanced_recent_tasks_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.youtubeLightBg 
          : AppTheme.youtubeDarkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context, l10n),
            const SizedBox(height: AppTheme.space8),
            
            // Main Content Grid
            _buildMainContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final now = DateTime.now();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.space8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light 
            ? AppTheme.youtubeLightSurface 
            : AppTheme.youtubeDarkSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light 
              ? AppTheme.youtubeLightBorder 
              : AppTheme.youtubeDarkBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getTimeOfDayGreeting()}, User!',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light 
                        ? AppTheme.youtubeLightText 
                        : AppTheme.youtubeDarkText,
                  ),
                ),
                const SizedBox(height: AppTheme.space2),
                Text(
                  TimeFormatter.formatDate(now),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light 
                        ? AppTheme.youtubeLightTextSecondary 
                        : AppTheme.youtubeDarkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            // TODO: Navigate to create project
          },
          icon: const Icon(Symbols.add_circle),
          iconSize: 32,
          color: AppTheme.youtubeRed,
          tooltip: 'Create Project',
        ),
        const SizedBox(width: AppTheme.space2),
        IconButton(
          onPressed: () {
            // TODO: Navigate to settings
          },
          icon: const Icon(Symbols.settings),
          iconSize: 32,
          color: Theme.of(context).brightness == Brightness.light 
              ? AppTheme.youtubeLightTextSecondary 
              : AppTheme.youtubeDarkTextSecondary,
          tooltip: 'Settings',
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= AppTheme.desktopBreakpoint;
        final isTablet = constraints.maxWidth >= AppTheme.tabletBreakpoint && 
                        constraints.maxWidth < AppTheme.desktopBreakpoint;
        
        if (isLargeScreen) {
          return _buildDesktopLayout();
        } else if (isTablet) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        // Timer and Summary Row
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timer Section (8 columns)
              Expanded(
                flex: 8,
                child: const TimerWidget(),
              ),
              const SizedBox(width: AppTheme.space6),
              // Summary Section (4 columns)
              Expanded(
                flex: 4,
                child: const TodaySummaryWidget(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.space8),
        
        // Quick Actions and Recent Tasks Row
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Quick Actions (6 columns)
              Expanded(
                flex: 6,
                child: const QuickStartWidget(),
              ),
              const SizedBox(width: AppTheme.space6),
              // Recent Tasks (6 columns)
              Expanded(
                flex: 6,
                child: const EnhancedRecentTasksWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        // Timer Section
        const TimerWidget(),
        const SizedBox(height: AppTheme.space6),
        
        // Summary and Quick Actions Row
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: const TodaySummaryWidget()),
              const SizedBox(width: AppTheme.space6),
              Expanded(child: const QuickStartWidget()),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.space6),
        
        // Recent Tasks Section
        const EnhancedRecentTasksWidget(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const TimerWidget(),
        const SizedBox(height: AppTheme.space6),
        const TodaySummaryWidget(),
        const SizedBox(height: AppTheme.space6),
        const QuickStartWidget(),
        const SizedBox(height: AppTheme.space6),
        const EnhancedRecentTasksWidget(),
      ],
    );
  }

  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    } else if (hour < 17) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }
}