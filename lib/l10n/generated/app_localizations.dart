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

  /// Start timer button text
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

  /// Project name field label
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

  /// Enable notifications setting
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

  /// Break time notification message
  ///
  /// In en, this message translates to:
  /// **'It\'s time for a {breakType} break!'**
  String breakTime(String breakType);

  /// Work completion message
  ///
  /// In en, this message translates to:
  /// **'Great work! You\'ve completed {hours} hours today.'**
  String workCompleted(double hours);
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
