import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/time_entry.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../projects/presentation/providers/projects_provider.dart';
import '../providers/calendar_providers.dart';

/// Dialog for editing time entry start and end times
class EditTimeEntryDialog extends ConsumerStatefulWidget {
  final TimeEntry entry;
  final VoidCallback? onUpdated;

  const EditTimeEntryDialog({
    super.key,
    required this.entry,
    this.onUpdated,
  });

  @override
  ConsumerState<EditTimeEntryDialog> createState() =>
      _EditTimeEntryDialogState();
}

class _EditTimeEntryDialogState extends ConsumerState<EditTimeEntryDialog> {
  late DateTime _startTime;
  late DateTime _endTime;
  late TextEditingController _taskNameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startTime = widget.entry.startTime;
    _endTime = widget.entry.endTime ?? DateTime.now();
    _taskNameController = TextEditingController(text: widget.entry.taskName);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projectsAsync = ref.watch(projectsProvider);

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.space3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Symbols.edit_calendar,
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.editTimeEntry,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        widget.entry.taskName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.gray600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Symbols.close),
                  tooltip: l10n.close,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space6),

            // Project info
            projectsAsync.when(
              data: (projects) {
                final project = projects.firstWhere(
                  (p) => p.id == widget.entry.projectId,
                  orElse: () => projects.first,
                );
                return Container(
                  padding: const EdgeInsets.all(AppTheme.space4),
                  decoration: BoxDecoration(
                    color: project.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: project.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: project.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppTheme.space2),
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: project.color,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppTheme.space6),

            // Task Name Field
            Text(
              'Task Name',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppTheme.space2),
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                hintText: 'Enter task name',
                prefixIcon: const Icon(Symbols.edit_note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? AppTheme.gray50
                    : AppTheme.gray800,
              ),
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppTheme.space4),

            // Start Time
            _buildTimeField(
              context: context,
              label: l10n.startTime,
              icon: Symbols.schedule,
              dateTime: _startTime,
              onTap: () => _selectDateTime(context, true),
            ),
            const SizedBox(height: AppTheme.space4),

            // End Time
            _buildTimeField(
              context: context,
              label: l10n.endTime,
              icon: Symbols.event_available,
              dateTime: _endTime,
              onTap: () => _selectDateTime(context, false),
            ),
            const SizedBox(height: AppTheme.space6),

            // Duration info
            _buildDurationInfo(),
            const SizedBox(height: AppTheme.space6),

            // Action buttons
            Row(
              children: [
                // Delete button
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _confirmDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorRed,
                    side: const BorderSide(color: AppTheme.errorRed),
                  ),
                  icon: const Icon(Symbols.delete, size: 18),
                  label: Text(l10n.delete),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: AppTheme.space3),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required DateTime dateTime,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.space4),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryBlue),
            const SizedBox(width: AppTheme.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${TimeFormatter.formatDate(dateTime)} ${TimeFormatter.formatTime(dateTime)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Symbols.edit, size: 20, color: AppTheme.gray500),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationInfo() {
    final duration = _endTime.difference(_startTime);
    final isValid = duration.inSeconds > 0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: isValid
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isValid
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.errorRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Symbols.timer : Symbols.error,
            color: isValid ? AppTheme.successGreen : AppTheme.errorRed,
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isValid ? 'Duration' : 'Invalid Duration',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isValid ? AppTheme.successGreen : AppTheme.errorRed,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  isValid
                      ? TimeFormatter.formatDuration(duration)
                      : 'End time must be after start time',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isValid ? AppTheme.successGreen : AppTheme.errorRed,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final currentDateTime = isStartTime ? _startTime : _endTime;

    // Select date
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (selectedDate == null || !mounted) return;

    // Select time - use the same context since we're in a dialog
    final selectedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDateTime),
    );

    if (selectedTime == null || !mounted) return;

    // Combine date and time
    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      if (isStartTime) {
        _startTime = newDateTime;
        // If start time is after end time, adjust end time
        if (_startTime.isAfter(_endTime)) {
          _endTime = _startTime.add(const Duration(minutes: 30));
        }
      } else {
        _endTime = newDateTime;
        // If end time is before start time, adjust start time
        if (_endTime.isBefore(_startTime)) {
          _startTime = _endTime.subtract(const Duration(minutes: 30));
        }
      }
    });
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.space2),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(
                Symbols.delete,
                color: AppTheme.errorRed,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.space3),
            Expanded(
              child: Text(
                l10n.deleteTimeEntry,
                style: const TextStyle(
                  color: AppTheme.errorRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteTimeEntryConfirm),
            const SizedBox(height: AppTheme.space4),
            Container(
              padding: const EdgeInsets.all(AppTheme.space3),
              decoration: BoxDecoration(
                color: AppTheme.gray50,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.gray300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry.taskName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space1),
                  Text(
                    '${TimeFormatter.formatTime(widget.entry.startTime)} - ${TimeFormatter.formatTime(widget.entry.effectiveEndTime)}',
                    style: TextStyle(
                      color: AppTheme.gray600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    TimeFormatter.formatDuration(widget.entry.duration),
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteEntry();
    }
  }

  Future<void> _deleteEntry() async {
    setState(() => _isSaving = true);

    try {
      // Delete from storage
      final storage = ref.read(storageServiceProvider);
      await storage.deleteTimeEntry(widget.entry.id);

      // Refresh calendar data
      ref.invalidate(calendarDataByDateProvider);
      ref.invalidate(unfilteredTimeEntriesProvider);
      ref.invalidate(filteredTimeEntriesProvider);

      // Refresh projects (to update statistics)
      ref.invalidate(projectsProvider);

      if (!mounted) return;

      // Call callback if provided
      widget.onUpdated?.call();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).timeEntryDeleted),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // Close dialog
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting entry: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    final duration = _endTime.difference(_startTime);
    if (duration.inSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).invalidDuration),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    // Validate task name
    final taskName = _taskNameController.text.trim();
    if (taskName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task name cannot be empty'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Create updated entry
      final updatedEntry = widget.entry.copyWith(
        taskName: taskName,
        startTime: _startTime,
        endTime: _endTime,
        duration: duration,
      );

      // Save to storage
      final storage = ref.read(storageServiceProvider);
      await storage.saveTimeEntry(updatedEntry);

      // Refresh calendar data
      ref.invalidate(calendarDataByDateProvider);
      ref.invalidate(unfilteredTimeEntriesProvider);
      ref.invalidate(filteredTimeEntriesProvider);

      // Refresh projects (to update statistics)
      ref.invalidate(projectsProvider);

      if (!mounted) return;

      // Call callback if provided
      widget.onUpdated?.call();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).timeEntryUpdated),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // Close dialog
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating entry: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
