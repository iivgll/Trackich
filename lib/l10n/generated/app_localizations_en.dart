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
  String get projects => 'Projects';

  @override
  String get calendar => 'Calendar';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get startTimer => 'Start Timer';

  @override
  String get pauseTimer => 'Pause Timer';

  @override
  String get stopTimer => 'Stop Timer';

  @override
  String get selectProject => 'Select project...';

  @override
  String get taskDescription => 'What are you working on?';

  @override
  String get todayActivity => 'Today\'s Activity';

  @override
  String get createProject => 'Create Project';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectDescription => 'Description';

  @override
  String get projectColor => 'Project Color';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get totalHours => 'Total Hours';

  @override
  String get focusScore => 'Focus Score';

  @override
  String get breakCompliance => 'Break Compliance';

  @override
  String get productivity => 'Productivity';

  @override
  String get timeBreakdown => 'Time Breakdown';

  @override
  String get productivityTrend => 'Productivity Trend';

  @override
  String get weekView => 'Week';

  @override
  String get monthView => 'Month';

  @override
  String get dayView => 'Day';

  @override
  String get general => 'General';

  @override
  String get timerAndBreaks => 'Timer & Breaks';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get workInterval => 'Work Interval';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get minutes => 'minutes';

  @override
  String get takeBreak => 'Take a Break';

  @override
  String get breakTime => 'Break Time';

  @override
  String workCompleted(double hours) {
    final intl.NumberFormat hoursNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return 'Great work! You\'ve completed $hoursString hours today.';
  }

  @override
  String get breakInterval => 'Break Interval';

  @override
  String breakReminderDescription(int minutes) {
    return 'Get break reminders every $minutes minutes';
  }

  @override
  String get breakRemindersToggle => 'Break Reminders';

  @override
  String get breakRemindersDescription =>
      'Get notified to take breaks automatically';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get quarter => 'Quarter';

  @override
  String get year => 'Year';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get allTime => 'All Time';

  @override
  String get startSimilarTask => 'Start Similar Task';

  @override
  String get continueTask => 'Continue Task';

  @override
  String get project => 'Project:';

  @override
  String get task => 'Task:';

  @override
  String get noProjectsAvailable => 'No projects available. Create one first.';

  @override
  String get selectProjectHint => 'Select a project';

  @override
  String get day => 'Day';

  @override
  String get exportingToExcel => 'Exporting to Excel...';

  @override
  String get exportSuccess => 'Excel report exported successfully!';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get errorLoadingProject => 'Error loading project';

  @override
  String get filterCalendar => 'Filter Calendar';

  @override
  String get allProjects => 'All Projects';

  @override
  String get clearAll => 'Clear All';

  @override
  String get apply => 'Apply';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get filteredResults => 'Filtered Results';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get min => 'min';

  @override
  String get testNotifications => 'Test Notifications';

  @override
  String get testNotificationsSubtitle =>
      'Send a test notification to verify the system is working';

  @override
  String get testNotificationSent =>
      'Test notification sent! Check your notification center.';

  @override
  String get test => 'Test';

  @override
  String get request => 'Request';

  @override
  String get notificationPermissionsGranted =>
      'Notification permissions granted!';

  @override
  String get enableNotificationsTitle => 'Enable Notifications';

  @override
  String get enableNotificationsInstructions =>
      'To enable notifications for Trackich:';

  @override
  String get step1 => '1. Open your device Settings';

  @override
  String get step2 => '2. Find \"Notifications\" or \"Apps & notifications\"';

  @override
  String get step3 => '3. Find \"Trackich\" in the app list';

  @override
  String get step4 => '4. Toggle notifications ON';

  @override
  String get ok => 'OK';

  @override
  String get hoursPerWeek => 'hours/week';

  @override
  String projectCreated(String name) {
    return 'Project \"$name\" created successfully!';
  }

  @override
  String errorCreatingProject(String error) {
    return 'Error creating project: $error';
  }

  @override
  String get active => 'Active';

  @override
  String get archived => 'Archived';

  @override
  String get deleteProject => 'Delete Project';

  @override
  String deleteProjectConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone and will also delete all associated time entries.';
  }

  @override
  String projectDeleted(String name) {
    return 'Project \"$name\" deleted';
  }

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get created => 'created';

  @override
  String get updated => 'updated';

  @override
  String projectSelectedMessage(String projectName) {
    return 'Selected $projectName. Enter a task to start the timer.';
  }

  @override
  String get appName => 'Trackich';

  @override
  String get noDataForPeriod => 'No data for this period';

  @override
  String get startTrackingMessage => 'Start tracking time to see analytics';

  @override
  String get keyMetrics => 'Key Metrics';

  @override
  String get totalWorkTime => 'Total Work Time';

  @override
  String get tasksCompleted => 'Tasks Completed';

  @override
  String get projectBreakdown => 'Project Breakdown';

  @override
  String get dailyActivity => 'Daily Activity';

  @override
  String get enableAppNotifications => 'Enable app notifications';

  @override
  String get notificationPermissionsRequired =>
      'Notification permissions required';

  @override
  String get notificationsEnabled => 'Notifications Enabled';

  @override
  String get notificationsEnabledDescription =>
      'System notifications are working properly';

  @override
  String get refreshStatus => 'Refresh status';

  @override
  String get notificationsDisabled => 'Notifications Disabled';

  @override
  String get notificationsDisabledDescription =>
      'Enable in system settings to receive notifications';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get permissionRequiredDescription =>
      'Tap to request notification permissions';

  @override
  String get morning => 'morning';

  @override
  String get afternoon => 'afternoon';

  @override
  String get evening => 'evening';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get errorLoadingTasks => 'Error loading tasks';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noTasksToday => 'No tasks today';

  @override
  String get startTimerToTrack => 'Start a timer to track your work';

  @override
  String get noTasksThisWeek => 'No tasks this week';

  @override
  String get recentActivityWillAppear =>
      'Your recent activity will appear here';

  @override
  String get noTasksThisMonth => 'No tasks this month';

  @override
  String get monthlyActivityWillAppear =>
      'Your monthly activity will appear here';

  @override
  String get noTasksFound => 'No tasks found';

  @override
  String get startTrackingToSeeActivity =>
      'Start tracking time to see your activity';

  @override
  String get totalTime => 'Total Time';

  @override
  String get sessions => 'Sessions';

  @override
  String get lastActivity => 'Last Activity';

  @override
  String get averagePerSession => 'Average per Session';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get timeForBreakTitle => 'Time for a Break!';

  @override
  String breakReminderBody(String projectText, int workMinutes) {
    return 'You have been working$projectText for ${workMinutes}m. Consider taking a short break to stay productive.';
  }

  @override
  String get backToWorkTitle => 'Break Time Over!';

  @override
  String workReminderBody(int breakMinutes) {
    return 'You have been on break for $breakMinutes minutes. Ready to get back to work?';
  }

  @override
  String get taskCompletedTitle => 'Task Completed!';

  @override
  String taskCompletedBody(String taskName, String projectName, int minutes) {
    return 'Great job! You completed \"$taskName\" in $projectName after ${minutes}m of focused work.';
  }

  @override
  String get testNotificationTitle => 'Test Notification';

  @override
  String get testNotificationBody =>
      'This is a test notification to verify that notifications are working properly.';

  @override
  String get skip => 'Skip';

  @override
  String get notificationPermissionTitle => 'Enable Notifications';

  @override
  String get notificationPermissionBody =>
      'Get break reminders and stay productive with timely notifications. You can change this setting later in Settings.';

  @override
  String get notificationPermissionDenied =>
      'Notification permission denied. You can enable it later in Settings.';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';
}
