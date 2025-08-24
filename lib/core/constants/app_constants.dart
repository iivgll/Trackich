class AppConstants {
  // App Information
  static const String appName = 'Trackich';
  static const String appVersion = '1.0.0';

  // Timing Constants
  static const Duration defaultWorkInterval = Duration(minutes: 25);
  static const Duration defaultShortBreak = Duration(minutes: 5);
  static const Duration defaultLongBreak = Duration(minutes: 15);
  static const Duration defaultDailyWorkLimit = Duration(hours: 8);
  static const Duration defaultPostureReminderInterval = Duration(minutes: 30);

  // UI Constants
  static const double minWindowWidth = 800;
  static const double minWindowHeight = 600;
  static const double optimalWindowWidth = 1200;
  static const double optimalWindowHeight = 800;

  static const double sidebarWidth = 280;
  static const double sidebarCollapsedWidth = 60;
  static const double navigationHeight = 64;

  // Grid and Layout
  static const int maxGridColumns = 4;
  static const double cardMinWidth = 280;
  static const double cardMaxWidth = 400;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 250);
  static const Duration slowAnimation = Duration(milliseconds: 400);

  // Storage Keys
  static const String settingsKey = 'app_settings';
  static const String projectsKey = 'projects';
  static const String timeEntriesKey = 'time_entries';
  static const String currentTimerKey = 'current_timer';

  // Notification IDs
  static const int breakReminderNotificationId = 1;
  static const int postureReminderNotificationId = 2;
  static const int dailyLimitNotificationId = 3;

  // Analytics Constants
  static const int defaultAnalyticsDays = 30;
  static const int maxAnalyticsDays = 365;

  // Focus and Productivity
  static const Duration minFocusSession = Duration(minutes: 5);
  static const Duration optimalFocusSession = Duration(minutes: 25);
  static const double excellentFocusScore = 90.0;
  static const double goodFocusScore = 70.0;
  static const double averageFocusScore = 50.0;

  // Break Compliance
  static const double excellentBreakCompliance = 90.0;
  static const double goodBreakCompliance = 70.0;
  static const double averageBreakCompliance = 50.0;

  // Health Recommendations
  static const Duration eyeStrainReminder = Duration(
    minutes: 20,
  ); // 20-20-20 rule
  static const Duration hydrationReminder = Duration(hours: 1);
  static const Duration stretchingReminder = Duration(minutes: 30);

  // Data Limits
  static const int maxProjectsCount = 100;
  static const int maxTimeEntriesPerProject = 10000;
  static const int maxTagsPerEntry = 10;
  static const int maxProjectNameLength = 100;
  static const int maxTaskNameLength = 200;
  static const int maxDescriptionLength = 500;

  // Export Formats
  static const List<String> supportedExportFormats = ['CSV', 'JSON', 'PDF'];

  // Localization
  static const List<String> supportedLanguages = ['en', 'ru'];
  static const String defaultLanguage = 'en';

  // Theme
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String systemTheme = 'system';

  // URL and Links
  static const String githubUrl = 'https://github.com/trackich/trackich';
  static const String privacyPolicyUrl = 'https://trackich.app/privacy';
  static const String supportUrl = 'https://trackich.app/support';

  // Error Messages
  static const String genericErrorMessage =
      'An unexpected error occurred. Please try again.';
  static const String networkErrorMessage =
      'Network connection error. Please check your internet connection.';
  static const String storageErrorMessage =
      'Unable to save data. Please check your storage permissions.';

  // Validation
  static const int minProjectNameLength = 1;
  static const int minTaskNameLength = 1;
  static const double minTargetHours = 0.0;
  static const double maxTargetHours = 168.0; // 24 hours * 7 days

  // Performance
  static const int maxRecentProjects = 10;
  static const int maxRecentTasks = 20;
  static const int chartDataPointLimit = 100;

  // Auto-save
  static const Duration autoSaveInterval = Duration(seconds: 30);
  static const Duration backupInterval = Duration(hours: 24);
}
