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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Trackich'**
  String get appTitle;

  /// Dashboard navigation label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Projects navigation label
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// Calendar navigation label
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Analytics navigation label
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Start timer button
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get startTimer;

  /// Pause timer button text
  ///
  /// In en, this message translates to:
  /// **'Pause Timer'**
  String get pauseTimer;

  /// Stop timer button text
  ///
  /// In en, this message translates to:
  /// **'Stop Timer'**
  String get stopTimer;

  /// Project selector placeholder
  ///
  /// In en, this message translates to:
  /// **'Select project...'**
  String get selectProject;

  /// Task input placeholder
  ///
  /// In en, this message translates to:
  /// **'What are you working on?'**
  String get taskDescription;

  /// Today's activity widget title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get todayActivity;

  /// Create project button text
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// Project name label
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// Project description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get projectDescription;

  /// Project color selection label
  ///
  /// In en, this message translates to:
  /// **'Project Color'**
  String get projectColor;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Total hours metric label
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// Focus score metric label
  ///
  /// In en, this message translates to:
  /// **'Focus Score'**
  String get focusScore;

  /// Break compliance metric label
  ///
  /// In en, this message translates to:
  /// **'Break Compliance'**
  String get breakCompliance;

  /// Productivity metric label
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// Time breakdown chart title
  ///
  /// In en, this message translates to:
  /// **'Time Breakdown'**
  String get timeBreakdown;

  /// Productivity trend chart title
  ///
  /// In en, this message translates to:
  /// **'Productivity Trend'**
  String get productivityTrend;

  /// Week view button text
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekView;

  /// Month view button text
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthView;

  /// Day view button text
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayView;

  /// General settings category
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Timer and breaks settings category
  ///
  /// In en, this message translates to:
  /// **'Timer & Breaks'**
  String get timerAndBreaks;

  /// Notifications settings category
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Enable notifications button text
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Work interval setting
  ///
  /// In en, this message translates to:
  /// **'Work Interval'**
  String get workInterval;

  /// Short break setting
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// Long break setting
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Take break reminder notification
  ///
  /// In en, this message translates to:
  /// **'Take a Break'**
  String get takeBreak;

  /// Break time metric
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// Work completion message
  ///
  /// In en, this message translates to:
  /// **'Great work! You\'ve completed {hours} hours today.'**
  String workCompleted(double hours);

  /// Break interval setting label
  ///
  /// In en, this message translates to:
  /// **'Break Interval'**
  String get breakInterval;

  /// Break reminder interval description
  ///
  /// In en, this message translates to:
  /// **'Get break reminders every {minutes} minutes'**
  String breakReminderDescription(int minutes);

  /// Break reminders toggle setting
  ///
  /// In en, this message translates to:
  /// **'Break Reminders'**
  String get breakRemindersToggle;

  /// Break reminders description
  ///
  /// In en, this message translates to:
  /// **'Get notified to take breaks automatically'**
  String get breakRemindersDescription;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Week filter option
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Month filter option
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Quarter filter option
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get quarter;

  /// Year filter option
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Today filter option
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// This week filter option
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// This month filter option
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// All time filter option
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// Start similar task button
  ///
  /// In en, this message translates to:
  /// **'Start Similar Task'**
  String get startSimilarTask;

  /// Continue task button
  ///
  /// In en, this message translates to:
  /// **'Continue Task'**
  String get continueTask;

  /// Project label
  ///
  /// In en, this message translates to:
  /// **'Project:'**
  String get project;

  /// Task label
  ///
  /// In en, this message translates to:
  /// **'Task:'**
  String get task;

  /// No projects message
  ///
  /// In en, this message translates to:
  /// **'No projects available. Create one first.'**
  String get noProjectsAvailable;

  /// Select project hint
  ///
  /// In en, this message translates to:
  /// **'Select a project'**
  String get selectProjectHint;

  /// Day view option
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Export progress message
  ///
  /// In en, this message translates to:
  /// **'Exporting to Excel...'**
  String get exportingToExcel;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Excel report exported successfully!'**
  String get exportSuccess;

  /// Export failed message
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// Error loading project message
  ///
  /// In en, this message translates to:
  /// **'Error loading project'**
  String get errorLoadingProject;

  /// Filter calendar title
  ///
  /// In en, this message translates to:
  /// **'Filter Calendar'**
  String get filterCalendar;

  /// All projects filter option
  ///
  /// In en, this message translates to:
  /// **'All Projects'**
  String get allProjects;

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Apply filters button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Clear filters button
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Filtered results title
  ///
  /// In en, this message translates to:
  /// **'Filtered Results'**
  String get filteredResults;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Russian language option
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// Test notifications title
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get testNotifications;

  /// Test notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Send a test notification to verify the system is working'**
  String get testNotificationsSubtitle;

  /// Test notification sent message
  ///
  /// In en, this message translates to:
  /// **'Test notification sent! Check your notification center.'**
  String get testNotificationSent;

  /// Test button text
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// Request button text
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// Notification permissions granted message
  ///
  /// In en, this message translates to:
  /// **'Notification permissions granted!'**
  String get notificationPermissionsGranted;

  /// Enable notifications dialog title
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotificationsTitle;

  /// Enable notifications instructions
  ///
  /// In en, this message translates to:
  /// **'To enable notifications for Trackich:'**
  String get enableNotificationsInstructions;

  /// Step 1 instruction
  ///
  /// In en, this message translates to:
  /// **'1. Open your device Settings'**
  String get step1;

  /// Step 2 instruction
  ///
  /// In en, this message translates to:
  /// **'2. Find \"Notifications\" or \"Apps & notifications\"'**
  String get step2;

  /// Step 3 instruction
  ///
  /// In en, this message translates to:
  /// **'3. Find \"Trackich\" in the app list'**
  String get step3;

  /// Step 4 instruction
  ///
  /// In en, this message translates to:
  /// **'4. Toggle notifications ON'**
  String get step4;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Hours per week label
  ///
  /// In en, this message translates to:
  /// **'hours/week'**
  String get hoursPerWeek;

  /// Project created message
  ///
  /// In en, this message translates to:
  /// **'Project \"{name}\" created successfully!'**
  String projectCreated(String name);

  /// Error creating project message
  ///
  /// In en, this message translates to:
  /// **'Error creating project: {error}'**
  String errorCreatingProject(String error);

  /// Active filter option
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Archived filter option
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// Delete project dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get deleteProject;

  /// Delete project confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone and will also delete all associated time entries.'**
  String deleteProjectConfirmation(String name);

  /// Project deleted message
  ///
  /// In en, this message translates to:
  /// **'Project \"{name}\" deleted'**
  String projectDeleted(String name);

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Created date label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Updated action text
  ///
  /// In en, this message translates to:
  /// **'updated'**
  String get updated;

  /// Message when project is selected
  ///
  /// In en, this message translates to:
  /// **'Selected {projectName}. Enter a task to start the timer.'**
  String projectSelectedMessage(String projectName);

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Trackich'**
  String get appName;

  /// No data message for analytics
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get noDataForPeriod;

  /// Message to start tracking time
  ///
  /// In en, this message translates to:
  /// **'Start tracking time to see analytics'**
  String get startTrackingMessage;

  /// Key metrics section title
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// Total work time metric
  ///
  /// In en, this message translates to:
  /// **'Total Work Time'**
  String get totalWorkTime;

  /// Tasks completed metric
  ///
  /// In en, this message translates to:
  /// **'Tasks Completed'**
  String get tasksCompleted;

  /// Project breakdown section title
  ///
  /// In en, this message translates to:
  /// **'Project Breakdown'**
  String get projectBreakdown;

  /// Daily activity chart title
  ///
  /// In en, this message translates to:
  /// **'Daily Activity'**
  String get dailyActivity;

  /// Enable notifications button text
  ///
  /// In en, this message translates to:
  /// **'Enable app notifications'**
  String get enableAppNotifications;

  /// Permissions required message
  ///
  /// In en, this message translates to:
  /// **'Notification permissions required'**
  String get notificationPermissionsRequired;

  /// Notifications enabled status
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled'**
  String get notificationsEnabled;

  /// Notifications enabled description
  ///
  /// In en, this message translates to:
  /// **'System notifications are working properly'**
  String get notificationsEnabledDescription;

  /// Refresh status tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh status'**
  String get refreshStatus;

  /// Notifications disabled status
  ///
  /// In en, this message translates to:
  /// **'Notifications Disabled'**
  String get notificationsDisabled;

  /// Notifications disabled description
  ///
  /// In en, this message translates to:
  /// **'Enable in system settings to receive notifications'**
  String get notificationsDisabledDescription;

  /// Permission required status
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Permission required description
  ///
  /// In en, this message translates to:
  /// **'Tap to request notification permissions'**
  String get permissionRequiredDescription;

  /// Morning time period
  ///
  /// In en, this message translates to:
  /// **'morning'**
  String get morning;

  /// Afternoon time period
  ///
  /// In en, this message translates to:
  /// **'afternoon'**
  String get afternoon;

  /// Evening time period
  ///
  /// In en, this message translates to:
  /// **'evening'**
  String get evening;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Error loading tasks message
  ///
  /// In en, this message translates to:
  /// **'Error loading tasks'**
  String get errorLoadingTasks;

  /// Recent activity section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No tasks today message
  ///
  /// In en, this message translates to:
  /// **'No tasks today'**
  String get noTasksToday;

  /// Start timer instruction
  ///
  /// In en, this message translates to:
  /// **'Start a timer to track your work'**
  String get startTimerToTrack;

  /// No tasks this week message
  ///
  /// In en, this message translates to:
  /// **'No tasks this week'**
  String get noTasksThisWeek;

  /// Recent activity placeholder
  ///
  /// In en, this message translates to:
  /// **'Your recent activity will appear here'**
  String get recentActivityWillAppear;

  /// No tasks this month message
  ///
  /// In en, this message translates to:
  /// **'No tasks this month'**
  String get noTasksThisMonth;

  /// Monthly activity placeholder
  ///
  /// In en, this message translates to:
  /// **'Your monthly activity will appear here'**
  String get monthlyActivityWillAppear;

  /// No tasks found message
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get noTasksFound;

  /// Start tracking instruction
  ///
  /// In en, this message translates to:
  /// **'Start tracking time to see your activity'**
  String get startTrackingToSeeActivity;

  /// Total time label
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// Shows session count
  ///
  /// In en, this message translates to:
  /// **'({count} sessions)'**
  String sessions(int count);

  /// Last activity column header
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// Average per session column header
  ///
  /// In en, this message translates to:
  /// **'Average per Session'**
  String get averagePerSession;

  /// Good morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// Good afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// Good evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// Break reminder notification title
  ///
  /// In en, this message translates to:
  /// **'Time for a Break!'**
  String get timeForBreakTitle;

  /// Break reminder notification body
  ///
  /// In en, this message translates to:
  /// **'You have been working{projectText} for {workMinutes}m. Consider taking a short break to stay productive.'**
  String breakReminderBody(String projectText, int workMinutes);

  /// Work reminder notification title
  ///
  /// In en, this message translates to:
  /// **'Break Time Over!'**
  String get backToWorkTitle;

  /// Work reminder notification body
  ///
  /// In en, this message translates to:
  /// **'You have been on break for {breakMinutes} minutes. Ready to get back to work?'**
  String workReminderBody(int breakMinutes);

  /// Task completed notification title
  ///
  /// In en, this message translates to:
  /// **'Task Completed!'**
  String get taskCompletedTitle;

  /// Task completed notification body
  ///
  /// In en, this message translates to:
  /// **'Great job! You completed \"{taskName}\" in {projectName} after {minutes}m of focused work.'**
  String taskCompletedBody(String taskName, String projectName, int minutes);

  /// Test notification title
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotificationTitle;

  /// Test notification body
  ///
  /// In en, this message translates to:
  /// **'This is a test notification to verify that notifications are working properly.'**
  String get testNotificationBody;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Notification permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notificationPermissionTitle;

  /// Notification permission dialog body
  ///
  /// In en, this message translates to:
  /// **'Get break reminders and stay productive with timely notifications. You can change this setting later in Settings.'**
  String get notificationPermissionBody;

  /// Archive project button text
  ///
  /// In en, this message translates to:
  /// **'Archive Project'**
  String get archiveProject;

  /// Unarchive project button text
  ///
  /// In en, this message translates to:
  /// **'Unarchive Project'**
  String get unarchiveProject;

  /// Archive project confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Archive Project?'**
  String get archiveProjectConfirmTitle;

  /// Archive project confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive this project? Any active timers for this project will be stopped.'**
  String get archiveProjectConfirmMessage;

  /// Unarchive project confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Unarchive Project?'**
  String get unarchiveProjectConfirmTitle;

  /// Unarchive project confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This project will be restored to your active projects list.'**
  String get unarchiveProjectConfirmMessage;

  /// Warning message about active timer being stopped
  ///
  /// In en, this message translates to:
  /// **'Warning: There is an active timer running for this project. It will be automatically stopped if you archive the project.'**
  String get activeTimerWillBeStopped;

  /// Message when notification permission is denied
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. You can enable it later in Settings.'**
  String get notificationPermissionDenied;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;

  /// Timer widget title
  ///
  /// In en, this message translates to:
  /// **'Focus Timer'**
  String get focusTimer;

  /// Timer running status
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// Timer paused status
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Shows previous accumulated time and current session time
  ///
  /// In en, this message translates to:
  /// **'Previous: {previousTime} + Session: {sessionTime}'**
  String previousSession(String previousTime, String sessionTime);

  /// Resume timer button text
  ///
  /// In en, this message translates to:
  /// **'Resume Timer'**
  String get resumeTimer;

  /// Error message when projects fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading projects'**
  String get errorLoadingProjects;

  /// Create new project option in dropdown
  ///
  /// In en, this message translates to:
  /// **'Create New Project'**
  String get createNewProject;

  /// Empty state title when no projects exist
  ///
  /// In en, this message translates to:
  /// **'No Projects Yet'**
  String get noProjectsYet;

  /// Empty state description when no projects exist
  ///
  /// In en, this message translates to:
  /// **'Create your first project to start tracking time'**
  String get createFirstProject;

  /// Indicates task will continue with previous time
  ///
  /// In en, this message translates to:
  /// **'This task will be continued'**
  String get taskWillBeContinued;

  /// Shows previous time for continued task
  ///
  /// In en, this message translates to:
  /// **'Continue task - Previous time: {previousTime}'**
  String continueTaskPreviousTime(String previousTime);

  /// Message when no projects found in search
  ///
  /// In en, this message translates to:
  /// **'No projects found'**
  String get noProjectsFound;

  /// Suggestion when no search results found
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get tryAdjustingSearch;

  /// Message when no projects exist yet
  ///
  /// In en, this message translates to:
  /// **'Create your first project to get started'**
  String get createFirstProjectToStart;

  /// Project name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter project name'**
  String get enterProjectName;

  /// Project name validation error
  ///
  /// In en, this message translates to:
  /// **'Project name is required'**
  String get projectNameRequired;

  /// Optional field indicator
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get optional;

  /// Project description input hint
  ///
  /// In en, this message translates to:
  /// **'Enter project description'**
  String get enterProjectDescription;

  /// Tags input hint
  ///
  /// In en, this message translates to:
  /// **'Enter tags separated by commas'**
  String get enterTagsCommaSeparated;

  /// Validation message for invalid number input
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Statistics section label
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Last active date label
  ///
  /// In en, this message translates to:
  /// **'Last Active'**
  String get lastActive;

  /// Weekly target label
  ///
  /// In en, this message translates to:
  /// **'Weekly Target'**
  String get weeklyTarget;

  /// Tags label
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Total work time completed for today in dashboard header
  ///
  /// In en, this message translates to:
  /// **'Work time today: {time}'**
  String todayWorkTime(String time);

  /// Timer recovery dialog title
  ///
  /// In en, this message translates to:
  /// **'Timer Recovery'**
  String get timerRecoveryTitle;

  /// Timer recovery dialog message
  ///
  /// In en, this message translates to:
  /// **'The timer was not stopped properly when the app was closed. You were working on:'**
  String get timerRecoveryMessage;

  /// Button to add recovered time to task
  ///
  /// In en, this message translates to:
  /// **'Add Time to Task'**
  String get addTimeToTask;

  /// Button to discard recovered time
  ///
  /// In en, this message translates to:
  /// **'Discard Time'**
  String get discardTime;

  /// Shows the task name in recovery dialog
  ///
  /// In en, this message translates to:
  /// **'Task: {taskName}'**
  String timerRecoveryTask(String taskName);

  /// Shows the project name in recovery dialog
  ///
  /// In en, this message translates to:
  /// **'Project: {projectName}'**
  String timerRecoveryProject(String projectName);

  /// Shows the recovered duration in dialog
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String timerRecoveryDuration(String duration);

  /// Search projects hint text
  ///
  /// In en, this message translates to:
  /// **'Search projects...'**
  String get searchProjects;

  /// Weekly target hours input label
  ///
  /// In en, this message translates to:
  /// **'Weekly Target Hours (optional)'**
  String get weeklyTargetHours;

  /// Hours unit label
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// Task description input hint
  ///
  /// In en, this message translates to:
  /// **'Enter task description'**
  String get enterTaskDescription;

  /// Project description input hint
  ///
  /// In en, this message translates to:
  /// **'Brief description of the project'**
  String get briefProjectDescription;

  /// Excel export date column header
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get excelHeaderDate;

  /// Excel export project column header
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get excelHeaderProject;

  /// Excel export task description column header
  ///
  /// In en, this message translates to:
  /// **'Task Description'**
  String get excelHeaderTaskDescription;

  /// Excel export start time column header
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get excelHeaderStartTime;

  /// Excel export end time column header
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get excelHeaderEndTime;

  /// Excel export duration column header
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get excelHeaderDuration;

  /// Excel export hours column header
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get excelHeaderHours;

  /// Excel export status column header
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get excelHeaderStatus;

  /// Excel summary report title
  ///
  /// In en, this message translates to:
  /// **'Summary Report'**
  String get excelSummaryReport;

  /// Excel summary project column header
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get excelSummaryProject;

  /// Excel summary total tasks column header
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get excelSummaryTotalTasks;

  /// Excel summary total hours column header
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get excelSummaryTotalHours;

  /// Excel summary average hours per task column header
  ///
  /// In en, this message translates to:
  /// **'Avg Hours/Task'**
  String get excelSummaryAvgHoursPerTask;

  /// Excel summary total row label
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get excelSummaryTotal;

  /// Excel summary unknown project label
  ///
  /// In en, this message translates to:
  /// **'Unknown Project'**
  String get excelSummaryUnknownProject;

  /// Excel summary untitled task label
  ///
  /// In en, this message translates to:
  /// **'Untitled Task'**
  String get excelSummaryUntitledTask;

  /// Excel summary in progress status
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get excelSummaryInProgress;

  /// Excel summary completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get excelSummaryCompleted;

  /// Just now time formatting
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeUnitsJustNow;

  /// Hour ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{hours} hour ago'**
  String timeUnitsHourAgo(int hours);

  /// Hours ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String timeUnitsHoursAgo(int hours);

  /// Minute ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{minutes} minute ago'**
  String timeUnitsMinuteAgo(int minutes);

  /// Minutes ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String timeUnitsMinutesAgo(int minutes);

  /// Today time formatting
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get timeUnitsToday;

  /// Yesterday time formatting
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeUnitsYesterday;

  /// Shows applied filters
  ///
  /// In en, this message translates to:
  /// **'Filters: {filterInfo}'**
  String filters(String filterInfo);

  /// Total tasks label
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totalTasks;

  /// Average per task label
  ///
  /// In en, this message translates to:
  /// **'Avg per Task'**
  String get avgPerTask;

  /// Shows unique tasks count and duration
  ///
  /// In en, this message translates to:
  /// **'{count} unique tasks • {duration}'**
  String uniqueTasks(int count, String duration);

  /// Export to Excel tooltip
  ///
  /// In en, this message translates to:
  /// **'Export to Excel'**
  String get exportToExcel;

  /// Shows export path
  ///
  /// In en, this message translates to:
  /// **'Excel report exported to:\n{path}'**
  String excelReportExportedTo(String path);

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Excel report exported successfully!'**
  String get excelReportExportedSuccessfully;

  /// Unknown label
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Project filter label
  ///
  /// In en, this message translates to:
  /// **'Project: {name}'**
  String projectLabel(String name);

  /// Date range filter label
  ///
  /// In en, this message translates to:
  /// **'{startDay}/{startMonth}/{startYear} - {endDay}/{endMonth}/{endYear}'**
  String dateRangeLabel(
    int startDay,
    int startMonth,
    int startYear,
    int endDay,
    int endMonth,
    int endYear,
  );

  /// Default task name when empty
  ///
  /// In en, this message translates to:
  /// **'Untitled Task'**
  String get untitledTask;

  /// Task status in progress
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Unknown project label
  ///
  /// In en, this message translates to:
  /// **'Unknown Project'**
  String get unknownProject;

  /// Work time today label
  ///
  /// In en, this message translates to:
  /// **'Work Time Today'**
  String get workTimeToday;

  /// Tasks label
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// Last activity label
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get last;

  /// Day ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{days} day ago'**
  String timeUnitsDayAgo(int days);

  /// Days ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String timeUnitsDaysAgo(int days);

  /// Second ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{seconds} second ago'**
  String timeUnitsSecondAgo(int seconds);

  /// Seconds ago time formatting
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds ago'**
  String timeUnitsSecondsAgo(int seconds);

  /// Time separator in date-time format
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get timeUnitsAt;

  /// Week range format
  ///
  /// In en, this message translates to:
  /// **'{startDate} - {endDate}'**
  String timeUnitsWeekRange(String startDate, String endDate);

  /// Week range format when start and end are in same month
  ///
  /// In en, this message translates to:
  /// **'{startDate} - {endDate}'**
  String timeUnitsWeekRangeSameMonth(String startDate, String endDate);

  /// Hours abbreviation
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get timeUnitsHours;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get timeUnitsMinutes;

  /// Seconds abbreviation
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get timeUnitsSeconds;

  /// Percentage format
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String timeUnitsPercentage(String value);

  /// Generic error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// Generic error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorGenericWithDetails(String details);

  /// Error message when recent tasks fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading recent tasks'**
  String get errorLoadingRecentTasks;

  /// Error message when today's activity fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading today\'s activity'**
  String get errorLoadingTodaysActivity;

  /// Error message when data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// Custom date range filter label
  ///
  /// In en, this message translates to:
  /// **'Custom Date Range'**
  String get customDateRange;

  /// Select date range button label
  ///
  /// In en, this message translates to:
  /// **'Select Range'**
  String get selectRange;

  /// Quick filters section label
  ///
  /// In en, this message translates to:
  /// **'Quick Filters'**
  String get quickFilters;

  /// Last 7 days filter option
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// Last 30 days filter option
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// Last 3 months filter option
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get last3Months;

  /// This year filter option
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get thisYear;
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
