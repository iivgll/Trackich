// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trackich';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get calendar => 'Calendar';

  @override
  String get projects => 'Projects';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get startTask => 'Start Task';

  @override
  String get pauseTask => 'Pause';

  @override
  String get resumeTask => 'Resume';

  @override
  String get stopTask => 'Stop';

  @override
  String workingOn(String taskName) {
    return 'Working on: $taskName';
  }

  @override
  String get project => 'Project';

  @override
  String get selectProject => 'Select Project';

  @override
  String get taskName => 'Task name...';

  @override
  String get addNote => 'Add Note';

  @override
  String get todaysSummary => 'Today\'s Summary';

  @override
  String todayWorked(String duration) {
    return 'Today: $duration worked';
  }

  @override
  String tasksCompleted(int count) {
    return '$count tasks completed';
  }

  @override
  String breaksTaken(int count) {
    return '$count breaks taken';
  }

  @override
  String goal(String goal, int percentage) {
    return 'Goal: $goal ($percentage% complete)';
  }

  @override
  String get recentTasks => 'Recent Tasks';

  @override
  String get viewAllTasks => 'View all tasks...';

  @override
  String get newProject => 'New Project';

  @override
  String activeProjects(int count, int archived) {
    return '$count active, $archived archived';
  }

  @override
  String thisWeek(String duration) {
    return 'This week: $duration';
  }

  @override
  String lastActivity(String time) {
    return 'Last activity: $time';
  }

  @override
  String get edit => 'Edit';

  @override
  String get archive => 'Archive';

  @override
  String get viewTasks => 'View Tasks';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get timeFormat => 'Time Format';

  @override
  String get weekStartsOn => 'Week Starts On';

  @override
  String get defaultProject => 'Default Project';

  @override
  String get breakConfiguration => 'Break Configuration';

  @override
  String get workSessionDuration => 'Work Session Duration';

  @override
  String get shortBreakDuration => 'Short Break Duration';

  @override
  String get longBreakDuration => 'Long Break Duration';

  @override
  String get longBreakInterval => 'Long Break Interval';

  @override
  String get enableBreakNotifications => 'Enable Break Notifications';

  @override
  String get notificationSound => 'Notification Sound';

  @override
  String get testSound => 'Test Sound';

  @override
  String get notifications => 'Notifications';

  @override
  String get systemNotifications => 'System Notifications';

  @override
  String get breakReminders => 'Break Reminders';

  @override
  String get dailySummary => 'Daily Summary';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get storageUsed => 'Storage Used';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get hour12 => '12-hour';

  @override
  String get hour24 => '24-hour';

  @override
  String get monday => 'Monday';

  @override
  String get sunday => 'Sunday';

  @override
  String get minutes => 'minutes';

  @override
  String get sessions => 'sessions';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get today => 'Today';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String total(String duration) {
    return 'Total: $duration';
  }

  @override
  String get takeBreak => 'Take Break';

  @override
  String shortBreak(String duration) {
    return 'Short break ($duration)';
  }

  @override
  String longBreak(String duration) {
    return 'Long break ($duration)';
  }

  @override
  String get customDuration => 'Custom duration';

  @override
  String get justPause => 'Just pause';

  @override
  String get readyToResume => 'Ready to resume?';

  @override
  String resume(String taskName) {
    return 'Resume $taskName';
  }

  @override
  String get startNewTask => 'Start new task';

  @override
  String get extendBreak => 'Extend break';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get startTimer => 'Start Timer';

  @override
  String get enterTaskName => 'Enter task name...';

  @override
  String get errorLoadingProjects => 'Error loading projects';

  @override
  String get noRecentTasks => 'No recent tasks available';

  @override
  String get todaySummary => 'Today\'s Summary';

  @override
  String get timeWorked => 'Time Worked';

  @override
  String get dailyGoalProgress => 'Daily Goal Progress';

  @override
  String get complete => 'complete';

  @override
  String get breakTime => 'Break Time';

  @override
  String get breaks => 'Breaks';

  @override
  String get currentTime => 'Current Time';

  @override
  String get noTasksToday => 'No tasks worked on today';

  @override
  String get projectBreakdown => 'Project Breakdown';
}
