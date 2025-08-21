import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../features/timer/providers/timer_provider.dart';
import 'widgets/current_task_widget.dart';
import 'widgets/quick_start_widget.dart';
import 'widgets/today_summary_widget.dart';
import 'widgets/recent_tasks_widget.dart';

/// Dashboard screen showing current task, quick start, and summary
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final timerState = ref.watch(timerNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Theme toggle button
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle theme - we'll implement this later
            },
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout
          final isWideScreen = constraints.maxWidth > 1024;
          
          if (isWideScreen) {
            return _buildWideScreenLayout(context, timerState, l10n);
          } else {
            return _buildNarrowScreenLayout(context, timerState, l10n);
          }
        },
      ),
    );
  }

  Widget _buildWideScreenLayout(BuildContext context, TimerState timerState, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content area (left side)
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current task widget (if active)
                  if (timerState.isActive) ...[
                    const CurrentTaskWidget(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Quick start widget
                  const QuickStartWidget(),
                  const SizedBox(height: 32),
                  
                  // Today's summary
                  const TodaySummaryWidget(),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 32),
          
          // Right sidebar
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recentTasks,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Flexible(child: RecentTasksWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowScreenLayout(BuildContext context, TimerState timerState, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current task widget (if active)
          if (timerState.isActive) ...[
            const CurrentTaskWidget(),
            const SizedBox(height: 24),
          ],
          
          // Quick start widget
          const QuickStartWidget(),
          const SizedBox(height: 24),
          
          // Today's summary and recent tasks in a grid
          const TodaySummaryWidget(),
          const SizedBox(height: 24),
          
          Text(
            l10n.recentTasks,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const RecentTasksWidget(),
        ],
      ),
    );
  }
}