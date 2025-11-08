import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/projects_provider.dart';

class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color? _selectedColor;
  final _tagsController = TextEditingController();
  double _targetHoursPerWeek = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with first project color
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final projectsNotifier = ref.read(projectsProvider.notifier);
        _selectedColor = projectsNotifier.getNextAvailableColor();
        setState(() {});
      }
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
          Icon(
            Symbols.add_circle,
            color: AppTheme.getPrimaryColor(context),
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
                  l10n.projectName,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: l10n.enterProjectName,
                    prefixIcon: const Icon(Symbols.folder),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.projectNameRequired;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: AppTheme.space4),

                // Project Description
                Text(
                  l10n.description,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: l10n.briefProjectDescription,
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
                  l10n.projectColor,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                GestureDetector(
                  onTap: _showColorPicker,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.space4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _selectedColor ?? AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppTheme.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tap to choose color',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedColor != null
                                    ? '#${_selectedColor!.toARGB32().toRadixString(16).substring(2).toUpperCase()}'
                                    : 'Select a color',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.gray600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Symbols.palette,
                          color: AppTheme.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.space4),

                // Tags (Optional)
                Text(l10n.tags, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    hintText: l10n.enterTagsCommaSeparated,
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
                  l10n.weeklyTargetHours,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppTheme.space2),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixIcon: const Icon(Symbols.schedule),
                    suffix: Text(l10n.hoursPerWeek),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
            backgroundColor: AppTheme.getPrimaryColor(context),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _showColorPicker() async {
    final Color colorBeforeDialog = _selectedColor ?? AppTheme.primaryBlue;

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: colorBeforeDialog,
              onColorChanged: (Color color) {
                setState(() => _selectedColor = color);
              },
              width: 44,
              height: 44,
              borderRadius: 8,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 200,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              showMaterialName: true,
              showColorName: true,
              showColorCode: true,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                longPressMenu: true,
              ),
              materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
              colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
              colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
              colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
              selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() => _selectedColor = colorBeforeDialog);
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == null || !result) {
      setState(() => _selectedColor = colorBeforeDialog);
    }
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

      await ref
          .read(projectsProvider.notifier)
          .createProject(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            color: _selectedColor ?? AppTheme.getProjectColors(context).first,
            tags: tags,
            targetHoursPerWeek: _targetHoursPerWeek,
          );

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).projectCreated(_nameController.text.trim()),
            ),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (error) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).errorCreatingProject(error.toString()),
            ),
            backgroundColor: AppTheme.getErrorColor(context),
          ),
        );
      }
    }
  }
}
