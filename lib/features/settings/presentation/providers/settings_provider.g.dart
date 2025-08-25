// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeModeHash() => r'f65f854326ff90335f49f559a7d75d0268dbc8a5';

/// Provider for watching specific setting values
///
/// Copied from [themeMode].
@ProviderFor(themeMode)
final themeModeProvider = AutoDisposeProvider<ThemeMode>.internal(
  themeMode,
  name: r'themeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThemeModeRef = AutoDisposeProviderRef<ThemeMode>;
String _$languageHash() => r'5b1502a195659247270344f67d633bce9480db67';

/// See also [language].
@ProviderFor(language)
final languageProvider = AutoDisposeProvider<String>.internal(
  language,
  name: r'languageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$languageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LanguageRef = AutoDisposeProviderRef<String>;
String _$notificationsEnabledHash() =>
    r'407b89cd499fca47db7f03b9d7591b69632fbb8b';

/// See also [notificationsEnabled].
@ProviderFor(notificationsEnabled)
final notificationsEnabledProvider = AutoDisposeProvider<bool>.internal(
  notificationsEnabled,
  name: r'notificationsEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsEnabledRef = AutoDisposeProviderRef<bool>;
String _$timeFormatHash() => r'851171df8d8b567f66bb89b46557f6f279e4d556';

/// See also [timeFormat].
@ProviderFor(timeFormat)
final timeFormatProvider = AutoDisposeProvider<TimeFormat>.internal(
  timeFormat,
  name: r'timeFormatProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timeFormatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimeFormatRef = AutoDisposeProviderRef<TimeFormat>;
String _$weekStartDayHash() => r'dbe9a30b329f6a4bdf502220cc7e4a7222575d40';

/// See also [weekStartDay].
@ProviderFor(weekStartDay)
final weekStartDayProvider = AutoDisposeProvider<WeekStartDay>.internal(
  weekStartDay,
  name: r'weekStartDayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weekStartDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeekStartDayRef = AutoDisposeProviderRef<WeekStartDay>;
String _$settingsHash() => r'ad29c2f4749f173df73e37c784ec91c22b59dd51';

/// Provider for app settings
///
/// Copied from [Settings].
@ProviderFor(Settings)
final settingsProvider =
    AutoDisposeAsyncNotifierProvider<Settings, AppSettings>.internal(
      Settings.new,
      name: r'settingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Settings = AutoDisposeAsyncNotifier<AppSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
