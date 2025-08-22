import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/projects/providers/projects_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color _selectedColor = AppTheme.projectColors.first;
  final _tagsController = TextEditingController();
  double _targetHoursPerWeek = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Get the next available color from the projects provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectsNotifier = ref.read(projectsProvider.notifier);
      _selectedColor = projectsNotifier.getNextAvailableColor();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Symbols.add_circle,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: AppTheme.space2),
          Text(l10n.createProject),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Name
                Text(
                  'Project Name',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter project name',
                    prefixIcon: const Icon(Symbols.folder),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Project name is required';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: AppTheme.space4),
                
                // Project Description
                Text(
                  'Description (Optional)',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Brief description of the project',
                    prefixIcon: const Icon(Symbols.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  maxLines: 2,
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: AppTheme.space4),
                
                // Color Selection
                Text(
                  'Project Color',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                Container(
                  padding: const EdgeInsets.all(AppTheme.space3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Wrap(
                    spacing: AppTheme.space2,
                    runSpacing: AppTheme.space2,
                    children: AppTheme.projectColors.map((color) {
                      final isSelected = color == _selectedColor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.primary 
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Symbols.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: AppTheme.space4),
                
                // Tags (Optional)
                Text(
                  'Tags (Optional)',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    hintText: 'Enter tags separated by commas',
                    prefixIcon: const Icon(Symbols.label),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: AppTheme.space4),
                
                // Target Hours Per Week
                Text(
                  'Target Hours Per Week (Optional)',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixIcon: const Icon(Symbols.schedule),
                    suffix: const Text('hours/week'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    _targetHoursPerWeek = double.tryParse(value) ?? 0.0;
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
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _createProject,
          icon: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Symbols.add),
          label: Text(l10n.createProject),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      await ref.read(projectsProvider.notifier).createProject(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        color: _selectedColor,
        tags: tags,
        targetHoursPerWeek: _targetHoursPerWeek,
      );

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${_nameController.text.trim()}" created successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (error) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating project: $error'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
}