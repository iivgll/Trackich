import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Trackich'**
  String get appTitle;

  /// Main dashboard tab
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Calendar view tab
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Projects management tab
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// Analytics and reports tab
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Button to start a new task
  ///
  /// In en, this message translates to:
  /// **'Start Task'**
  String get startTask;

  /// Button to pause current task
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseTask;

  /// Button to resume paused task
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeTask;

  /// Button to stop current task
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopTask;

  /// Currently active task display
  ///
  /// In en, this message translates to:
  /// **'Working on: {taskName}'**
  String workingOn(String taskName);

  /// Project label
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// Dropdown hint for project selection
  ///
  /// In en, this message translates to:
  /// **'Select Project'**
  String get selectProject;

  /// Task name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Task name...'**
  String get taskName;

  /// Button to add note to task
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Today's work summary section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// Total time worked today
  ///
  /// In en, this message translates to:
  /// **'Today: {duration} worked'**
  String todayWorked(String duration);

  /// Number of tasks completed
  ///
  /// In en, this message translates to:
  /// **'{count} tasks completed'**
  String tasksCompleted(int count);

  /// Number of breaks taken
  ///
  /// In en, this message translates to:
  /// **'{count} breaks taken'**
  String breaksTaken(int count);

  /// Daily goal progress
  ///
  /// In en, this message translates to:
  /// **'Goal: {goal} ({percentage}% complete)'**
  String goal(String goal, int percentage);

  /// Recent tasks section title
  ///
  /// In en, this message translates to:
  /// **'Recent Tasks'**
  String get recentTasks;

  /// Link to view all tasks
  ///
  /// In en, this message translates to:
  /// **'View all tasks...'**
  String get viewAllTasks;

  /// Button to create new project
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// Project count summary
  ///
  /// In en, this message translates to:
  /// **'{count} active, {archived} archived'**
  String activeProjects(int count, int archived);

  /// Time worked this week
  ///
  /// In en, this message translates to:
  /// **'This week: {duration}'**
  String thisWeek(String duration);

  /// Last activity time
  ///
  /// In en, this message translates to:
  /// **'Last activity: {time}'**
  String lastActivity(String time);

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Archive button
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// View tasks button
  ///
  /// In en, this message translates to:
  /// **'View Tasks'**
  String get viewTasks;

  /// General settings section
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Time format setting
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// Week start day setting
  ///
  /// In en, this message translates to:
  /// **'Week Starts On'**
  String get weekStartsOn;

  /// Default project setting
  ///
  /// In en, this message translates to:
  /// **'Default Project'**
  String get defaultProject;

  /// Break settings section
  ///
  /// In en, this message translates to:
  /// **'Break Configuration'**
  String get breakConfiguration;

  /// Work session duration setting
  ///
  /// In en, this message translates to:
  /// **'Work Session Duration'**
  String get workSessionDuration;

  /// Short break duration setting
  ///
  /// In en, this message translates to:
  /// **'Short Break Duration'**
  String get shortBreakDuration;

  /// Long break duration setting
  ///
  /// In en, this message translates to:
  /// **'Long Break Duration'**
  String get longBreakDuration;

  /// Long break interval setting
  ///
  /// In en, this message translates to:
  /// **'Long Break Interval'**
  String get longBreakInterval;

  /// Break notifications toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Break Notifications'**
  String get enableBreakNotifications;

  /// Notification sound setting
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// Test sound button
  ///
  /// In en, this message translates to:
  /// **'Test Sound'**
  String get testSound;

  /// Notifications section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// System notifications toggle
  ///
  /// In en, this message translates to:
  /// **'System Notifications'**
  String get systemNotifications;

  /// Break reminders toggle
  ///
  /// In en, this message translates to:
  /// **'Break Reminders'**
  String get breakReminders;

  /// Daily summary notifications toggle
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummary;

  /// Quiet hours setting
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// Data management section
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// Export data button
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Import data button
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// Clear all data button
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Storage usage display
  ///
  /// In en, this message translates to:
  /// **'Storage Used'**
  String get storageUsed;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Russian language option
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// 12-hour time format
  ///
  /// In en, this message translates to:
  /// **'12-hour'**
  String get hour12;

  /// 24-hour time format
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get hour24;

  /// Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Sessions unit
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get sessions;

  /// Enabled status
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Today navigation button
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Week view
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Month view
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Total time display
  ///
  /// In en, this message translates to:
  /// **'Total: {duration}'**
  String total(String duration);

  /// Take break button
  ///
  /// In en, this message translates to:
  /// **'Take Break'**
  String get takeBreak;

  /// Short break option
  ///
  /// In en, this message translates to:
  /// **'Short break ({duration})'**
  String shortBreak(String duration);

  /// Long break option
  ///
  /// In en, this message translates to:
  /// **'Long break ({duration})'**
  String longBreak(String duration);

  /// Custom break duration option
  ///
  /// In en, this message translates to:
  /// **'Custom duration'**
  String get customDuration;

  /// Just pause option
  ///
  /// In en, this message translates to:
  /// **'Just pause'**
  String get justPause;

  /// Break end notification message
  ///
  /// In en, this message translates to:
  /// **'Ready to resume?'**
  String get readyToResume;

  /// Resume specific task
  ///
  /// In en, this message translates to:
  /// **'Resume {taskName}'**
  String resume(String taskName);

  /// Start new task option
  ///
  /// In en, this message translates to:
  /// **'Start new task'**
  String get startNewTask;

  /// Extend break option
  ///
  /// In en, this message translates to:
  /// **'Extend break'**
  String get extendBreak;

  /// Quick start section title
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStart;

  /// Start timer button
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get startTimer;

  /// Task name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter task name...'**
  String get enterTaskName;

  /// Error message when projects fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading projects'**
  String get errorLoadingProjects;

  /// Message when no recent tasks exist
  ///
  /// In en, this message translates to:
  /// **'No recent tasks available'**
  String get noRecentTasks;

  /// Today's summary section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaySummary;

  /// Time worked label
  ///
  /// In en, this message translates to:
  /// **'Time Worked'**
  String get timeWorked;

  /// Daily goal progress label
  ///
  /// In en, this message translates to:
  /// **'Daily Goal Progress'**
  String get dailyGoalProgress;

  /// Complete status
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get complete;

  /// Break time label
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// Breaks label
  ///
  /// In en, this message translates to:
  /// **'Breaks'**
  String get breaks;

  /// Current time label
  ///
  /// In en, this message translates to:
  /// **'Current Time'**
  String get currentTime;

  /// Message when no tasks worked today
  ///
  /// In en, this message translates to:
  /// **'No tasks worked on today'**
  String get noTasksToday;

  /// Project breakdown section title
  ///
  /// In en, this message translates to:
  /// **'Project Breakdown'**
  String get projectBreakdown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
