import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/project.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../features/projects/providers/projects_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

// UI state providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final projectsViewModeProvider = StateProvider<ProjectsViewMode>((ref) => ProjectsViewMode.grid);
final selectedProjectFilterProvider = StateProvider<ProjectFilter>((ref) => ProjectFilter.active);

enum ProjectsViewMode { grid, list }
enum ProjectFilter { all, active, archived }

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchQuery = ref.watch(searchQueryProvider);
    final viewMode = ref.watch(projectsViewModeProvider);
    final filter = ref.watch(selectedProjectFilterProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light 
          ? AppTheme.lightBackground 
          : AppTheme.darkBackground,
      body: Column(
        children: [
          // Toolbar
          _buildToolbar(context, l10n, ref, viewMode, filter),
          
          // Projects Content
          Expanded(
            child: _buildProjectsContent(context, ref, searchQuery, viewMode, filter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProjectDialog(context, ref),
        tooltip: l10n.createProject,
        backgroundColor: AppTheme.getPrimaryColor(context),
        child: const Icon(Symbols.add, color: Colors.white),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, AppLocalizations l10n, WidgetRef ref, 
                      ProjectsViewMode viewMode, ProjectFilter filter) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light 
            ? AppTheme.lightSurface 
            : AppTheme.darkSurface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light 
                ? AppTheme.lightSeparator 
                : AppTheme.darkSeparator,
            width: 0.33,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Symbols.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppTheme.space3,
                  horizontal: AppTheme.space4,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Symbols.close, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: AppTheme.space4),
          
          // Filter Dropdown
          DropdownButton<ProjectFilter>(
            value: filter,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: ProjectFilter.all,
                child: Text(l10n.allProjects),
              ),
              DropdownMenuItem(
                value: ProjectFilter.active,
                child: Text(l10n.active),
              ),
              DropdownMenuItem(
                value: ProjectFilter.archived,
                child: Text(l10n.archived),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(selectedProjectFilterProvider.notifier).state = value;
              }
            },
          ),
          const SizedBox(width: AppTheme.space4),
          
          // View Mode Toggle
          ToggleButtons(
            isSelected: [
              viewMode == ProjectsViewMode.grid,
              viewMode == ProjectsViewMode.list,
            ],
            onPressed: (index) {
              ref.read(projectsViewModeProvider.notifier).state = 
                  index == 0 ? ProjectsViewMode.grid : ProjectsViewMode.list;
            },
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            children: const [
              Icon(Symbols.grid_view, size: 18),
              Icon(Symbols.list, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsContent(BuildContext context, WidgetRef ref, String searchQuery,
                              ProjectsViewMode viewMode, ProjectFilter filter) {
    final l10n = AppLocalizations.of(context);
    final projectsAsync = _getFilteredProjects(ref, filter);
    
    return projectsAsync.when(
      data: (projects) {
        // Apply search filter
        final filteredProjects = searchQuery.isEmpty
            ? projects
            : projects.where((project) {
                return project.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                       project.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
                       project.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
              }).toList();

        if (filteredProjects.isEmpty) {
          return _buildEmptyState(context, searchQuery.isNotEmpty);
        }

        return Padding(
          padding: const EdgeInsets.all(AppTheme.space6),
          child: viewMode == ProjectsViewMode.grid
              ? _buildGridView(filteredProjects)
              : _buildListView(filteredProjects),
        );
      },
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
              'Error loading projects',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space4),
            ElevatedButton(
              onPressed: () => ref.invalidate(projectsProvider),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  AsyncValue<List<Project>> _getFilteredProjects(WidgetRef ref, ProjectFilter filter) {
    try {
      switch (filter) {
        case ProjectFilter.all:
          return ref.watch(projectsProvider);
        case ProjectFilter.active:
          return ref.watch(activeProjectsProvider);
        case ProjectFilter.archived:
          return ref.watch(archivedProjectsProvider);
      }
    } catch (e) {
      // If there's an error with filtered providers, fall back to all projects and filter manually
      return ref.watch(projectsProvider).when(
        data: (projects) {
          List<Project> filtered;
          switch (filter) {
            case ProjectFilter.all:
              filtered = projects;
              break;
            case ProjectFilter.active:
              filtered = projects.where((p) => p.isActive).toList();
              break;
            case ProjectFilter.archived:
              filtered = projects.where((p) => !p.isActive).toList();
              break;
          }
          return AsyncValue.data(filtered);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context, bool isSearchResult) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearchResult ? Symbols.search_off : Symbols.folder_off,
            size: 64,
            color: AppTheme.gray400,
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            isSearchResult ? 'No projects found' : 'No projects yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          Text(
            isSearchResult 
                ? 'Try adjusting your search terms'
                : 'Create your first project to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isSearchResult) ...[
            const SizedBox(height: AppTheme.space6),
            ElevatedButton.icon(
              onPressed: () => _showCreateProjectDialog(context, ref),
              icon: const Icon(Symbols.add),
              label: Text(l10n.createProject),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridView(List<Project> projects) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = AppTheme.getGridColumns(context).clamp(2, 4);
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppTheme.space4,
            mainAxisSpacing: AppTheme.space4,
            childAspectRatio: 1.2,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return _ProjectCard(
              project: projects[index],
              onTap: () => _showProjectDetailsDialog(context, ref, projects[index]),
              onEdit: () => _showEditProjectDialog(context, ref, projects[index]),
              onDelete: () => _showDeleteConfirmation(context, ref, projects[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildListView(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _ProjectListTile(
          project: projects[index],
          onTap: () => _showProjectDetailsDialog(context, ref, projects[index]),
          onEdit: () => _showEditProjectDialog(context, ref, projects[index]),
          onDelete: () => _showDeleteConfirmation(context, ref, projects[index]),
        );
      },
    );
  }

  void _showCreateProjectDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => _ProjectFormDialog(
        title: l10n.createProject,
        onSave: (name, description, color, tags, targetHours) {
          ref.read(projectsProvider.notifier).createProject(
            name: name,
            description: description,
            color: color,
            tags: tags,
            targetHoursPerWeek: targetHours,
          );
        },
      ),
    );
  }

  void _showEditProjectDialog(BuildContext context, WidgetRef ref, Project project) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => _ProjectFormDialog(
        title: l10n.edit,
        project: project,
        onSave: (name, description, color, tags, targetHours) {
          ref.read(projectsProvider.notifier).updateProject(
            project.copyWith(
              name: name,
              description: description,
              color: color,
              tags: tags,
              targetHoursPerWeek: targetHours,
            ),
          );
        },
      ),
    );
  }

  void _showProjectDetailsDialog(BuildContext context, WidgetRef ref, Project project) {
    showDialog(
      context: context,
      builder: (context) => _ProjectDetailsDialog(project: project),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Project project) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProject),
        content: Text(l10n.deleteProjectConfirmation(project.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(projectsProvider.notifier).deleteProject(project.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.projectDeleted(project.name))),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.getErrorColor(context)),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

// Project Card Widget
class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? AppTheme.lightSeparator
              : AppTheme.darkSeparator,
          width: 0.33,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with color and menu
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: project.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Symbols.edit, size: 16),
                            const SizedBox(width: AppTheme.space2),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(
                              project.isActive ? Symbols.archive : Symbols.unarchive,
                              size: 16,
                            ),
                            const SizedBox(width: AppTheme.space2),
                            Text(project.isActive ? 'Archive' : 'Unarchive'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Symbols.delete, size: 16, color: AppTheme.getErrorColor(context)),
                            const SizedBox(width: AppTheme.space2),
                            Text('Delete', style: TextStyle(color: AppTheme.getErrorColor(context))),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'archive':
                          // TODO: Toggle archive status
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space3),
              
              // Project name
              Text(
                project.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.space2),
              
              // Description
              if (project.description.isNotEmpty) ...[
                Expanded(
                  child: Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.gray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else ...[
                Expanded(child: Container()),
              ],
              
              // Footer with time tracked and last active
              const SizedBox(height: AppTheme.space3),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TimeFormatter.formatHours(project.totalTimeTracked),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: project.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Total time',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!project.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.space2,
                        vertical: AppTheme.space1,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gray400.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Text(
                        l10n.archived,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Project List Tile Widget
class _ProjectListTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectListTile({
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(AppTheme.space4),
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: project.color,
            shape: BoxShape.circle,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                project.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!project.isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space2,
                  vertical: AppTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.gray400.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  l10n.archived,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.description.isNotEmpty) ...[
              const SizedBox(height: AppTheme.space1),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppTheme.space2),
            Row(
              children: [
                Text(
                  '${TimeFormatter.formatHours(project.totalTimeTracked)} total',
                  style: TextStyle(
                    color: project.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (project.lastActiveAt != null) ...[
                  Text(' • ', style: TextStyle(color: AppTheme.gray400)),
                  Text(
                    TimeFormatter.formatTimeAgo(project.lastActiveAt!),
                    style: TextStyle(color: AppTheme.gray500),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Symbols.edit, size: 16),
                  const SizedBox(width: AppTheme.space2),
                  Text(l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Symbols.delete, size: 16, color: AppTheme.getErrorColor(context)),
                  const SizedBox(width: AppTheme.space2),
                  Text(l10n.delete, style: TextStyle(color: AppTheme.getErrorColor(context))),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
      ),
    );
  }
}

// Project Form Dialog
class _ProjectFormDialog extends StatefulWidget {
  final String title;
  final Project? project;
  final Function(String name, String description, Color color, List<String> tags, double targetHours) onSave;

  const _ProjectFormDialog({
    required this.title,
    this.project,
    required this.onSave,
  });

  @override
  State<_ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<_ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetHoursController = TextEditingController();
  final _tagsController = TextEditingController();
  
  Color? _selectedColor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _nameController.text = widget.project!.name;
      _descriptionController.text = widget.project!.description;
      _selectedColor = widget.project!.color;
      _targetHoursController.text = widget.project!.targetHoursPerWeek.toString();
      _tagsController.text = widget.project!.tags.join(', ');
    } else {
      // Initialize with first project color for new projects
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _selectedColor = AppTheme.getProjectColors(context).first;
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetHoursController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    hintText: 'Enter project name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Project name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.space4),
                
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter project description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppTheme.space4),
                
                // Color selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Color',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppTheme.space3),
                    Wrap(
                      spacing: AppTheme.space3,
                      children: AppTheme.getProjectColors(context).map((color) {
                        final isSelected = _selectedColor != null && _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      width: 3,
                                    )
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space4),
                
                // Tags
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags (optional)',
                    hintText: 'Enter tags separated by commas',
                  ),
                ),
                const SizedBox(height: AppTheme.space4),
                
                // Target hours
                TextFormField(
                  controller: _targetHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Weekly Target Hours (optional)',
                    hintText: '0',
                    suffixText: 'hours',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final hours = double.tryParse(value);
                      if (hours == null || hours < 0) {
                        return 'Please enter a valid number';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveProject,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  void _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final targetHours = double.tryParse(_targetHoursController.text) ?? 0.0;

    try {
      widget.onSave(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _selectedColor ?? AppTheme.getProjectColors(context).first,
        tags,
        targetHours,
      );
      final l10n = AppLocalizations.of(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.project == null ? l10n.created : l10n.updated)),
      );
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: ${e.toString()}'),
          backgroundColor: AppTheme.getErrorColor(context),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Project Details Dialog
class _ProjectDetailsDialog extends StatelessWidget {
  final Project project;

  const _ProjectDetailsDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: project.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.space2),
          Expanded(child: Text(project.name)),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.description.isNotEmpty) ...[
              Text(
                'Description',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppTheme.space2),
              Text(project.description),
              const SizedBox(height: AppTheme.space4),
            ],
            
            // Statistics
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppTheme.space2),
            
            _DetailRow(
              icon: Symbols.timer,
              label: 'Total Time',
              value: TimeFormatter.formatHours(project.totalTimeTracked),
            ),
            _DetailRow(
              icon: Symbols.calendar_month,
              label: 'Created',
              value: TimeFormatter.formatDate(project.createdAt),
            ),
            if (project.lastActiveAt != null)
              _DetailRow(
                icon: Symbols.schedule,
                label: 'Last Active',
                value: TimeFormatter.formatTimeAgo(project.lastActiveAt!),
              ),
            if (project.targetHoursPerWeek > 0)
              _DetailRow(
                icon: Symbols.target,
                label: 'Weekly Target',
                value: '${project.targetHoursPerWeek}h',
              ),
            
            if (project.tags.isNotEmpty) ...[
              const SizedBox(height: AppTheme.space4),
              Text(
                'Tags',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppTheme.space2),
              Wrap(
                spacing: AppTheme.space2,
                children: project.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: project.color.withOpacity(0.1),
                    side: BorderSide(color: project.color),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.space1),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.gray600),
          const SizedBox(width: AppTheme.space2),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}