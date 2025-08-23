import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../features/projects/providers/projects_provider.dart';
import '../../../../features/timer/providers/timer_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../projects/create_project_dialog.dart';

class QuickStartWidget extends ConsumerWidget {
  const QuickStartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentProjectsAsync = ref.watch(recentProjectsProvider);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shadowColor: AppTheme.shadowMd.color,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Symbols.bolt,
                  size: 20,
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppTheme.space2),
                Text(
                  'Quick Start',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showCreateProjectDialog(context),
                  icon: const Icon(Symbols.add, size: 16),
                  label: Text(l10n.createProject),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space3,
                      vertical: AppTheme.space2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space4),

            // Recent Projects Grid
            recentProjectsAsync.when(
              data: (projects) => LayoutBuilder(
                builder: (context, constraints) {
                  if (projects.isEmpty) {
                    return SizedBox(
                      height: 120,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Symbols.folder_off,
                              size: 32,
                              color: AppTheme.gray400,
                            ),
                            const SizedBox(height: AppTheme.space2),
                            Text(
                              'No recent projects',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.gray500,
                              ),
                            ),
                            const SizedBox(height: AppTheme.space3),
                            ElevatedButton.icon(
                              onPressed: () => _showCreateProjectDialog(context),
                              icon: const Icon(Symbols.add, size: 16),
                              label: Text(l10n.createProject),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.space3,
                                  vertical: AppTheme.space2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  // Calculate optimal grid layout based on available width
                  final cardWidth = 120.0;
                  final spacing = AppTheme.space3;
                  final columns = ((constraints.maxWidth + spacing) / (cardWidth + spacing)).floor().clamp(2, 4);
                  final rows = (projects.length / columns).ceil().clamp(1, 2); // Max 2 rows
                  final gridHeight = rows * (cardWidth / 0.9) + (rows - 1) * spacing; // Calculate height based on aspect ratio
                  
                  return SizedBox(
                    height: gridHeight,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: 0.9, // Slightly taller than wide
                      ),
                      itemCount: projects.length.clamp(0, columns * 2), // Max 2 rows
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return _ProjectCard(
                          project: project,
                          onTap: () => _startTimerWithProject(context, ref, project),
                        );
                      },
                    ),
                  );
                },
              ),
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    'Error loading projects',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimerWithProject(BuildContext context, WidgetRef ref, project) {
    // Navigate to main timer and pre-select the project
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).projectSelectedMessage(project.name)),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Update the timer with the selected project
    ref.read(timerProvider.notifier).updateProject(project.id);
  }

  Future<void> _showCreateProjectDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final project;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light 
                ? AppTheme.gray200 
                : AppTheme.gray600,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Column(
          children: [
            // Color header
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: project.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMd),
                  topRight: Radius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.space3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Project color dot
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: project.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Symbols.folder,
                        size: 16,
                        color: project.color,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2),
                    
                    // Project name
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.space1),
                    
                    // Last used
                    Text(
                      project.lastActiveAt != null 
                          ? TimeFormatter.formatTimeAgo(project.lastActiveAt!)
                          : 'Never used',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}