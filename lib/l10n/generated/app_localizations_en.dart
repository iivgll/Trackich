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
  String breakTime(String breakType) {
    return 'It\'s time for a $breakType break!';
  }

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
}
