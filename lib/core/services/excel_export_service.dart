import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';

import '../models/time_entry.dart';
import '../models/project.dart';
import '../utils/time_formatter.dart';

class ExcelExportService {
  static Future<String> exportTimeEntries({
    required List<TimeEntry> entries,
    required Map<String, Project> projects,
    String? customFileName,
    DateTimeRange? dateRange,
  }) async {
    // Create Excel workbook
    var excel = Excel.createExcel();

    // Create main report sheet first
    var reportSheet = excel['Time Report'];
    var summarySheet = excel['Summary'];

    // Remove default sheet after creating our sheets
    if (excel.tables.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Set up headers for report sheet
    _setupReportHeaders(reportSheet);

    // Group entries by date
    var entriesByDate = <DateTime, List<TimeEntry>>{};
    for (var entry in entries) {
      var date = DateTime(
        entry.startTime.year,
        entry.startTime.month,
        entry.startTime.day,
      );
      entriesByDate.putIfAbsent(date, () => []).add(entry);
    }

    // Sort dates
    var sortedDates = entriesByDate.keys.toList()..sort();

    int row = 2; // Start from row 2 (after header)

    // Add data rows
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

      // Add entries for this date
      for (var entry in dayEntries) {
        var project = projects[entry.projectId];
        var duration =
            entry.endTime?.difference(entry.startTime) ?? Duration.zero;

        // Date
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = TextCellValue(
          '${date.day}/${date.month}/${date.year}',
        );

        // Project
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = TextCellValue(
          project?.name ?? 'Unknown Project',
        );

        // Task
        final taskName = entry.taskName.trim().isNotEmpty
            ? entry.taskName.trim()
            : 'Untitled Task';
        final fullTaskName = entry.description.trim().isNotEmpty
            ? '$taskName (${entry.description.trim()})'
            : taskName;
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = TextCellValue(
          fullTaskName,
        );

        // Start Time
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = TextCellValue(
          TimeFormatter.formatTime(entry.startTime),
        );

        // End Time
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = TextCellValue(
          entry.endTime != null
              ? TimeFormatter.formatTime(entry.endTime!)
              : 'In Progress',
        );

        // Duration
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value = TextCellValue(
          TimeFormatter.formatDuration(duration),
        );

        // Duration in hours (for calculations)
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
            .value = DoubleCellValue(
          duration.inMinutes / 60.0,
        );

        // Status
        reportSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
            .value = TextCellValue(
          entry.isCompleted ? 'Completed' : 'In Progress',
        );

        row++;
      }

      // Add empty row between dates
      row++;
    }

    // Create summary sheet
    _createSummarySheet(summarySheet, entries, projects);

    // Apply styling
    _applyReportStyling(reportSheet);
    _applySummaryStyling(summarySheet);

    // Generate file name
    var fileName = customFileName ?? _generateFileName(dateRange);

    // Save file with FileSaver
    var filePath = await _saveExcelFileWithFileSaver(excel, fileName);

    return filePath;
  }

  static void _setupReportHeaders(Sheet sheet) {
    var headers = [
      'Date',
      'Project',
      'Task Description',
      'Start Time',
      'End Time',
      'Duration',
      'Hours',
      'Status',
    ];

    for (int i = 0; i < headers.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1))
          .value = TextCellValue(
        headers[i],
      );
    }
  }

  static void _createSummarySheet(
    Sheet sheet,
    List<TimeEntry> entries,
    Map<String, Project> projects,
  ) {
    // Set up headers
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        TextCellValue('Summary Report');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 3)).value =
        TextCellValue('Project');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3)).value =
        TextCellValue('Total Tasks');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 3)).value =
        TextCellValue('Total Hours');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 3)).value =
        TextCellValue('Avg Hours/Task');

    // Group by project
    var projectStats = <String, Map<String, dynamic>>{};

    for (var entry in entries) {
      var projectId = entry.projectId;
      var duration =
          entry.endTime?.difference(entry.startTime) ?? Duration.zero;
      var hours = duration.inMinutes / 60.0;

      if (!projectStats.containsKey(projectId)) {
        projectStats[projectId] = {
          'name': projects[projectId]?.name ?? 'Unknown Project',
          'tasks': 0,
          'totalHours': 0.0,
        };
      }

      projectStats[projectId]!['tasks']++;
      projectStats[projectId]!['totalHours'] += hours;
    }

    // Add project statistics
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

    // Add totals
    row++;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = TextCellValue(
      'TOTAL',
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

  static void _styleDateRow(Sheet sheet, int row) {
    // Note: Excel package styling is limited, but we can set basic formatting
    // In a real implementation, you might want to use more advanced styling
  }

  static void _applyReportStyling(Sheet sheet) {
    // Basic styling for headers
    // Apply header styling (limited options in current Excel package)
  }

  static void _applySummaryStyling(Sheet sheet) {
    // Apply summary sheet styling
    // Apply title styling
  }

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

  static Future<String> _saveExcelFileWithFileSaver(
    Excel excel,
    String fileName,
  ) async {
    var bytes = excel.save();
    if (bytes == null) {
      throw Exception('Failed to generate Excel file');
    }

    try {
      // Use FileSaver's saveAs method for better user control on desktop
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        // For desktop platforms, use saveAs to let user choose location
        final result = await FileSaver.instance.saveAs(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        return (result?.isEmpty ?? true) ? 'File saved successfully' : result!;
      } else {
        // For mobile platforms, use regular saveFile
        final result = await FileSaver.instance.saveFile(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        return (result.isEmpty) ? 'File saved successfully' : result;
      }
    } catch (e) {
      // Handle specific error cases
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('cancelled') ||
          errorMessage.contains('cancel') ||
          errorMessage.contains('user canceled') ||
          errorMessage.contains('pathaccessexception') ||
          errorMessage.contains('operation not permitted') ||
          errorMessage.contains('errno = 1')) {
        return 'cancelled';
      }
      throw Exception('Failed to save file: $errorMessage');
    }
  }

  // Removed _getDownloadsDirectory as we now use system file picker
}
