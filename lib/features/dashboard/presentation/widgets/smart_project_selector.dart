import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../projects/domain/models/project.dart';
import '../../../projects/presentation/providers/projects_provider.dart';

/// Smart project selector with recent projects, search, and favorites
class SmartProjectSelector extends ConsumerStatefulWidget {
  final String? selectedProjectId;
  final List<Project> projects;
  final ValueChanged<String?> onProjectSelected;
  final VoidCallback onCreateNew;

  const SmartProjectSelector({
    super.key,
    this.selectedProjectId,
    required this.projects,
    required this.onProjectSelected,
    required this.onCreateNew,
  });

  @override
  ConsumerState<SmartProjectSelector> createState() =>
      _SmartProjectSelectorState();
}

class _SmartProjectSelectorState extends ConsumerState<SmartProjectSelector> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Project? selectedProject;
    if (widget.selectedProjectId != null && widget.projects.isNotEmpty) {
      try {
        selectedProject = widget.projects.firstWhere(
          (p) => p.id == widget.selectedProjectId,
        );
      } catch (e) {
        selectedProject = null;
      }
    }

    return InkWell(
      onTap: () => _showProjectPicker(context),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.space4),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Row(
          children: [
            if (selectedProject != null) ...[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: selectedProject.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTheme.space3),
              Expanded(
                child: Text(
                  selectedProject.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else ...[
              Icon(
                Symbols.folder,
                color: Theme.of(context).hintColor,
                size: 20,
              ),
              const SizedBox(width: AppTheme.space3),
              Expanded(
                child: Text(
                  l10n.selectProject,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ),
            ],
            const Icon(Symbols.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }

  void _showProjectPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProjectPickerModal(
        projects: widget.projects,
        selectedProjectId: widget.selectedProjectId,
        onProjectSelected: widget.onProjectSelected,
        onCreateNew: widget.onCreateNew,
      ),
    );
  }

  Widget _buildProjectsList(ScrollController scrollController) {
    final l10n = AppLocalizations.of(context);

    // Filter projects by search query
    final filteredProjects = _searchQuery.isEmpty
        ? widget.projects
        : widget.projects
            .where((p) => p.name.toLowerCase().contains(_searchQuery))
            .toList();

    // Get recent project IDs synchronously (empty list if not loaded yet)
    final recentProjectIds = ref.watch(recentProjectIdsProvider).valueOrNull ?? [];

    // Separate recent and other projects
    final recentProjects = filteredProjects
        .where((p) => recentProjectIds.contains(p.id))
        .toList()
      ..sort((a, b) {
        final aIndex = recentProjectIds.indexOf(a.id);
        final bIndex = recentProjectIds.indexOf(b.id);
        return aIndex.compareTo(bIndex);
      });

    final otherProjects = filteredProjects
        .where((p) => !recentProjectIds.contains(p.id))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space6),
          children: [
            // Create new project button
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Icon(
                  Symbols.add,
                  color: AppTheme.primaryBlue,
                ),
              ),
              title: Text(
                l10n.createProject,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                widget.onCreateNew();
              },
            ),

            const Divider(height: AppTheme.space6),

            // Recent projects section
            if (recentProjects.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                  vertical: AppTheme.space2,
                ),
                child: Text(
                  'Recent Projects',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ...recentProjects.map((project) => _buildProjectTile(project, true)),
              const SizedBox(height: AppTheme.space4),
            ],

            // All projects section
            if (otherProjects.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                  vertical: AppTheme.space2,
                ),
                child: Text(
                  recentProjects.isEmpty ? 'All Projects' : 'Other Projects',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ...otherProjects.map((project) => _buildProjectTile(project, false)),
            ],

            // Empty state
            if (filteredProjects.isEmpty) ...[
              const SizedBox(height: AppTheme.space8),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Symbols.search_off,
                      size: 64,
                      color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      'No projects found',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppTheme.space8),
          ],
        );
  }

  Widget _buildProjectTile(Project project, bool isRecent) {
    final isSelected = widget.selectedProjectId == project.id;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryBlue.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: isSelected
            ? Border.all(color: AppTheme.primaryBlue, width: 2)
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: project.color,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: isSelected
              ? const Icon(
                  Symbols.check,
                  color: Colors.white,
                  size: 20,
                )
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                project.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppTheme.primaryBlue : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isRecent)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Text(
                  'RECENT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
          ],
        ),
        subtitle: project.description.isNotEmpty
            ? Text(
                project.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: () async {
          widget.onProjectSelected(project.id);

          // Update recent projects
          final storage = ref.read(storageServiceProvider);
          await storage.addRecentProject(project.id);
          ref.invalidate(recentProjectIdsProvider);

          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

// Separate modal widget to properly handle state updates
class _ProjectPickerModal extends ConsumerStatefulWidget {
  final List<Project> projects;
  final String? selectedProjectId;
  final ValueChanged<String?> onProjectSelected;
  final VoidCallback onCreateNew;

  const _ProjectPickerModal({
    required this.projects,
    this.selectedProjectId,
    required this.onProjectSelected,
    required this.onCreateNew,
  });

  @override
  ConsumerState<_ProjectPickerModal> createState() => _ProjectPickerModalState();
}

class _ProjectPickerModalState extends ConsumerState<_ProjectPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppTheme.radiusXLarge),
            topRight: Radius.circular(AppTheme.radiusXLarge),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: AppTheme.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.gray400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(AppTheme.space6),
              child: Row(
                children: [
                  Text(
                    l10n.selectProject,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Symbols.close),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space6,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  prefixIcon: const Icon(Symbols.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Symbols.close),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
            ),

            const SizedBox(height: AppTheme.space4),

            // Projects list
            Expanded(
              child: _buildProjectsList(scrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList(ScrollController scrollController) {
    final l10n = AppLocalizations.of(context);

    // Filter projects by search query
    final filteredProjects = _searchQuery.isEmpty
        ? widget.projects
        : widget.projects
            .where((p) => p.name.toLowerCase().contains(_searchQuery))
            .toList();

    // Get recent and favorite project IDs
    final recentProjectIds = ref.watch(recentProjectIdsProvider).valueOrNull ?? [];
    final favoriteProjectIds = ref.watch(favoriteProjectIdsProvider).valueOrNull ?? [];

    // Separate favorite, recent, and other projects
    final favoriteProjects = filteredProjects
        .where((p) => favoriteProjectIds.contains(p.id))
        .toList()
      ..sort((a, b) {
        final aIndex = favoriteProjectIds.indexOf(a.id);
        final bIndex = favoriteProjectIds.indexOf(b.id);
        return aIndex.compareTo(bIndex);
      });

    final recentProjects = filteredProjects
        .where((p) => !favoriteProjectIds.contains(p.id) && recentProjectIds.contains(p.id))
        .toList()
      ..sort((a, b) {
        final aIndex = recentProjectIds.indexOf(a.id);
        final bIndex = recentProjectIds.indexOf(b.id);
        return aIndex.compareTo(bIndex);
      });

    final otherProjects = filteredProjects
        .where((p) => !favoriteProjectIds.contains(p.id) && !recentProjectIds.contains(p.id))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space6),
      children: [
        // Create new project button
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: const Icon(
              Symbols.add,
              color: AppTheme.primaryBlue,
            ),
          ),
          title: Text(
            l10n.createProject,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
            widget.onCreateNew();
          },
        ),

        const Divider(height: AppTheme.space6),

        // Favorite projects section
        if (favoriteProjects.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space4,
              vertical: AppTheme.space2,
            ),
            child: Row(
              children: [
                const Icon(Symbols.star, size: 16, color: AppTheme.warningOrange),
                const SizedBox(width: AppTheme.space2),
                Text(
                  'Favorite Projects',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          ...favoriteProjects.map((project) => _buildProjectTile(project, isFavorite: true, isRecent: false)),
          const SizedBox(height: AppTheme.space4),
        ],

        // Recent projects section
        if (recentProjects.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space4,
              vertical: AppTheme.space2,
            ),
            child: Text(
              'Recent Projects',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.gray600,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          ...recentProjects.map((project) => _buildProjectTile(project, isFavorite: false, isRecent: true)),
          const SizedBox(height: AppTheme.space4),
        ],

        // All projects section
        if (otherProjects.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space4,
              vertical: AppTheme.space2,
            ),
            child: Text(
              favoriteProjects.isEmpty && recentProjects.isEmpty ? 'All Projects' : 'Other Projects',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.gray600,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          ...otherProjects.map((project) => _buildProjectTile(project, isFavorite: false, isRecent: false)),
        ],

        // Empty state
        if (filteredProjects.isEmpty) ...[
          const SizedBox(height: AppTheme.space8),
          Center(
            child: Column(
              children: [
                Icon(
                  Symbols.search_off,
                  size: 64,
                  color: Theme.of(context).hintColor,
                ),
                const SizedBox(height: AppTheme.space4),
                Text(
                  'No projects found',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: AppTheme.space8),
      ],
    );
  }

  Widget _buildProjectTile(Project project, {required bool isFavorite, required bool isRecent}) {
    final isSelected = widget.selectedProjectId == project.id;
    final favoriteProjectIds = ref.watch(favoriteProjectIdsProvider).valueOrNull ?? [];
    final isFav = favoriteProjectIds.contains(project.id);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryBlue.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: isSelected
            ? Border.all(color: AppTheme.primaryBlue, width: 2)
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: project.color,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: isSelected
              ? const Icon(
                  Symbols.check,
                  color: Colors.white,
                  size: 20,
                )
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                project.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppTheme.primaryBlue : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isRecent && !isFav)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Text(
                  'RECENT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
          ],
        ),
        subtitle: project.description.isNotEmpty
            ? Text(
                project.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: IconButton(
          icon: Icon(
            isFav ? Symbols.star : Symbols.star,
            fill: isFav ? 1.0 : 0.0,
            color: isFav ? AppTheme.warningOrange : AppTheme.gray400,
            size: 24,
          ),
          onPressed: () async {
            final storage = ref.read(storageServiceProvider);
            if (isFav) {
              await storage.removeFavoriteProject(project.id);
            } else {
              await storage.addFavoriteProject(project.id);
            }
            ref.invalidate(favoriteProjectIdsProvider);
          },
        ),
        onTap: () async {
          widget.onProjectSelected(project.id);

          // Update recent projects
          final storage = ref.read(storageServiceProvider);
          await storage.addRecentProject(project.id);
          ref.invalidate(recentProjectIdsProvider);

          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
