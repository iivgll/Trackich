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
          ? AppTheme.lightBackground 
          : AppTheme.darkBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.space5), // 16px
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
            ? AppTheme.lightSurface 
            : AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light 
              ? AppTheme.lightSeparator 
              : AppTheme.darkSeparator,
          width: 0.33,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getTimeOfDayGreeting()}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light 
                        ? AppTheme.lightText 
                        : AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: AppTheme.space2),
                Text(
                  TimeFormatter.formatDate(now),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light 
                        ? AppTheme.lightTextSecondary 
                        : AppTheme.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
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