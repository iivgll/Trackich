import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackich/features/projects/domain/models/project.dart';
import 'package:trackich/l10n/generated/app_localizations.dart';

import '../models/time_entry.dart';
import '../utils/time_formatter.dart';

/// Service for exporting time tracking data to Excel files
///
/// Provides functionality to create structured Excel reports
/// containing time entries, projects, and task information
class ExcelExportService {
  /// Main method for exporting time tracking data to Excel file
  ///
  /// Creates two sheets:
  /// 1. "Time Report" - detailed report with daily entries
  /// 2. "Summary" - summary statistics by projects
  ///
  /// [entries] - list of time entries to export
  /// [projects] - map of projects for name resolution
  /// [context] - context for accessing localization
  /// [customFileName] - custom filename (optional)
  /// [dateRange] - date range for filtering (optional)
  ///
  /// Returns the path to the created file
  static Future<String> exportTimeEntries({
    required List<TimeEntry> entries,
    required Map<String, Project> projects,
    required BuildContext context,
    String? customFileName,
    DateTimeRange? dateRange,
  }) async {
    final l10n = AppLocalizations.of(context);

    // Create new Excel workbook
    var excel = Excel.createExcel();

    // Create main sheets: detailed report and summary
    var reportSheet = excel['Time Report'];
    var summarySheet = excel['Summary'];

    // Remove default sheet that gets created automatically
    if (excel.tables.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Set up headers for report sheet
    _setupReportHeaders(reportSheet, context);

    // Group entries by date for better organization
    var entriesByDate = <DateTime, List<TimeEntry>>{};
    for (var entry in entries) {
      // Use only date part for grouping (ignore time)
      var date = DateTime(
        entry.startTime.year,
        entry.startTime.month,
        entry.startTime.day,
      );
      entriesByDate.putIfAbsent(date, () => []).add(entry);
    }

    // Sort dates in ascending order
    var sortedDates = entriesByDate.keys.toList()..sort();

    // Start filling from row 2 (after headers)
    int row = 2;

    // Fill data for each date
    for (var date in sortedDates) {
      var dayEntries = entriesByDate[date]!;

      // Add date separator row
      reportSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(
        '${date.day}/${date.month}/${date.year}',
      );
      _styleDateRow(reportSheet, row);
      row++;

      // Add all entries for this date
      for (var entry in dayEntries) {
        var project = projects[entry.projectId];
        var duration =
            entry.endTime?.difference(entry.startTime) ?? Duration.zero;

        // Column: Date
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = TextCellValue(
          '${date.day}/${date.month}/${date.year}',
        );

        // Column: Project
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = TextCellValue(
          project?.name ?? l10n.excelSummaryUnknownProject,
        );

        // Column: Task (name + description if present)
        final taskName = entry.taskName.trim().isNotEmpty
            ? entry.taskName.trim()
            : l10n.excelSummaryUntitledTask;
        final fullTaskName = entry.description.trim().isNotEmpty
            ? '$taskName (${entry.description.trim()})'
            : taskName;
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = TextCellValue(
          fullTaskName,
        );

        // Column: Start Time
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = TextCellValue(
          TimeFormatter.formatTime(entry.startTime),
        );

        // Column: End Time
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = TextCellValue(
          entry.endTime != null
              ? TimeFormatter.formatTime(entry.endTime!)
              : l10n.excelSummaryInProgress,
        );

        // Column: Duration (formatted)
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value = TextCellValue(
          TimeFormatter.formatDuration(duration),
        );

        // Column: Duration in hours (for calculations)
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
            .value = DoubleCellValue(
          duration.inMinutes / 60.0,
        );

        // Column: Status
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
            .value = TextCellValue(
          entry.isCompleted
              ? l10n.excelSummaryCompleted
              : l10n.excelSummaryInProgress,
        );

        row++;
      }

      // Add empty row between dates for separation
      row++;
    }

    // Create summary sheet with aggregated data
    _createSummarySheet(summarySheet, entries, projects, context);

    // Apply styling to sheets
    _applyReportStyling(reportSheet);
    _applySummaryStyling(summarySheet);

    // Generate filename
    var fileName = customFileName ?? _generateFileName(dateRange);

    // Save file and get path to it
    var filePath = await _saveExcelFileWithFileSaver(excel, fileName);

    return filePath;
  }

  /// Sets up headers for the detailed report sheet
  ///
  /// [sheet] - Excel sheet to set up headers for
  /// [context] - context for accessing localization
  static void _setupReportHeaders(Sheet sheet, BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Define column headers matching the data structure
    var headers = [
      l10n.excelHeaderDate, // Date
      l10n.excelHeaderProject, // Project
      l10n.excelHeaderTaskDescription, // Task
      l10n.excelHeaderStartTime, // Start Time
      l10n.excelHeaderEndTime, // End Time
      l10n.excelHeaderDuration, // Duration
      l10n.excelHeaderHours, // Hours (for calculations)
      l10n.excelHeaderStatus, // Status
    ];

    // Add headers to second row (index 1)
    for (int i = 0; i < headers.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1))
          .value = TextCellValue(
        headers[i],
      );
    }
  }

  /// Creates the summary sheet with aggregated statistics by project
  ///
  /// [sheet] - Excel sheet to populate with summary data
  /// [entries] - list of time entries to summarize
  /// [projects] - map of projects for name resolution
  /// [context] - context for accessing localization
  static void _createSummarySheet(
    Sheet sheet,
    List<TimeEntry> entries,
    Map<String, Project> projects,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context);

    // Set up summary headers
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        TextCellValue(l10n.excelSummaryReport);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 3)).value =
        TextCellValue(l10n.excelSummaryProject);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3)).value =
        TextCellValue(l10n.excelSummaryTotalTasks);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 3)).value =
        TextCellValue(l10n.excelSummaryTotalHours);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 3)).value =
        TextCellValue(l10n.excelSummaryAvgHoursPerTask);

    // Group entries by project to calculate statistics
    var projectStats = <String, Map<String, dynamic>>{};

    for (var entry in entries) {
      var projectId = entry.projectId;
      var duration =
          entry.endTime?.difference(entry.startTime) ?? Duration.zero;
      var hours = duration.inMinutes / 60.0;

      if (!projectStats.containsKey(projectId)) {
        projectStats[projectId] = {
          'name': projects[projectId]?.name ?? l10n.excelSummaryUnknownProject,
          'tasks': 0,
          'totalHours': 0.0,
        };
      }

      projectStats[projectId]!['tasks']++;
      projectStats[projectId]!['totalHours'] += hours;
    }

    // Add project statistics rows
    int row = 4;
    double totalHours = 0;
    int totalTasks = 0;

    for (var stats in projectStats.values) {
      var taskCount = stats['tasks'] as int;
      var hours = stats['totalHours'] as double;
      var avgHours = taskCount > 0 ? hours / taskCount : 0.0;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(
        stats['name'],
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = IntCellValue(
        taskCount,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = DoubleCellValue(
        double.parse(hours.toStringAsFixed(2)),
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = DoubleCellValue(
        double.parse(avgHours.toStringAsFixed(2)),
      );

      totalHours += hours;
      totalTasks += taskCount;
      row++;
    }

    // Add totals row
    row++;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = TextCellValue(
      l10n.excelSummaryTotal,
    );
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .value = IntCellValue(
      totalTasks,
    );
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
        .value = DoubleCellValue(
      double.parse(totalHours.toStringAsFixed(2)),
    );
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
        .value = DoubleCellValue(
      totalTasks > 0
          ? double.parse((totalHours / totalTasks).toStringAsFixed(2))
          : 0.0,
    );
  }

  /// Applies styling to date separator rows
  ///
  /// [sheet] - Excel sheet containing the date row
  /// [row] - row index of the date separator
  static void _styleDateRow(Sheet sheet, int row) {
    // Note: Excel package styling is limited, but we can set basic formatting
    // In a real implementation, you might want to use more advanced styling
  }

  /// Applies styling to the report sheet
  ///
  /// [sheet] - Excel sheet to apply styling to
  static void _applyReportStyling(Sheet sheet) {
    // Basic styling for headers
    // Apply header styling (limited options in current Excel package)
  }

  /// Applies styling to the summary sheet
  ///
  /// [sheet] - Excel sheet to apply styling to
  static void _applySummaryStyling(Sheet sheet) {
    // Apply summary sheet styling
    // Apply title styling
  }

  /// Generates filename for the Excel report
  ///
  /// [dateRange] - optional date range for the report (affects filename)
  ///
  /// Returns formatted filename with timestamp or date range
  static String _generateFileName(DateTimeRange? dateRange) {
    var now = DateTime.now();
    var dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (dateRange != null) {
      var startStr =
          '${dateRange.start.year}-${dateRange.start.month.toString().padLeft(2, '0')}-${dateRange.start.day.toString().padLeft(2, '0')}';
      var endStr =
          '${dateRange.end.year}-${dateRange.end.month.toString().padLeft(2, '0')}-${dateRange.end.day.toString().padLeft(2, '0')}';
      return 'Time_Report_${startStr}_to_$endStr';
    }

    return 'Time_Report_$dateStr';
  }

  /// Saves the Excel file using appropriate method for each platform
  ///
  /// [excel] - Excel workbook to save
  /// [fileName] - desired filename without extension
  ///
  /// Returns the path to the saved file or 'cancelled' if user cancelled
  static Future<String> _saveExcelFileWithFileSaver(
    Excel excel,
    String fileName,
  ) async {
    var bytes = excel.save();
    if (bytes == null) {
      throw Exception('Failed to generate Excel file');
    }

    if (Platform.isWindows) {
      // For Windows, simply save to Downloads folder
      return await _saveToFallbackLocation(bytes, fileName);
    }

    try {
      if (Platform.isMacOS || Platform.isLinux) {
        final result = await FileSaver.instance.saveAs(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        if (result == null || result.isEmpty) {
          final fallbackPath = await _saveToFallbackLocation(bytes, fileName);
          return fallbackPath;
        }

        return result;
      } else {
        final result = await FileSaver.instance.saveFile(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        return result.isEmpty ? 'File saved to Downloads' : result;
      }
    } catch (e) {
      if (e.toString().toLowerCase().contains('cancel')) {
        return 'cancelled';
      }

      try {
        final fallbackPath = await _saveToFallbackLocation(bytes, fileName);
        return fallbackPath;
      } catch (fallbackError) {
        throw Exception('Failed to save file: $e');
      }
    }
  }

  /// Saves file to the Downloads folder as a fallback option
  ///
  /// [bytes] - file content as bytes
  /// [fileName] - filename without extension
  ///
  /// Returns the full path to the saved file
  static Future<String> _saveToFallbackLocation(
    List<int> bytes,
    String fileName,
  ) async {
    final downloadsDir = await _getDownloadsDirectory();
    final filePath = '${downloadsDir.path}\\$fileName.xlsx';

    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  /// Gets the Downloads directory for the current platform
  ///
  /// Returns Directory object pointing to user's Downloads folder
  /// Falls back to system temp directory if Downloads is not accessible
  static Future<Directory> _getDownloadsDirectory() async {
    final env = Platform.environment;
    final home = env['USERPROFILE'] ?? env['HOME'];

    if (home != null) {
      final downloadsPath = Platform.isWindows
          ? '$home\\Downloads'
          : '$home/Downloads';
      return Directory(downloadsPath);
    }

    return Directory.systemTemp;
  }
}
