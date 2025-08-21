// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThemeModeHash() => r'e2ba1c5d3af668937a4301750e23541dcee22f77';

/// Provider for current theme mode
///
/// Copied from [currentThemeMode].
@ProviderFor(currentThemeMode)
final currentThemeModeProvider = AutoDisposeProvider<ThemeMode>.internal(
  currentThemeMode,
  name: r'currentThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentThemeModeRef = AutoDisposeProviderRef<ThemeMode>;
String _$currentLanguageHash() => r'c122f5e95838beea4e484d1a98afb1346b8b64ee';

/// Provider for current language
///
/// Copied from [currentLanguage].
@ProviderFor(currentLanguage)
final currentLanguageProvider = AutoDisposeProvider<String>.internal(
  currentLanguage,
  name: r'currentLanguageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLanguageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLanguageRef = AutoDisposeProviderRef<String>;
String _$breakSettingsHash() => r'a8bdf2377954d9bc4cfa4c69a4031ca990744e93';

/// Provider for break settings
///
/// Copied from [breakSettings].
@ProviderFor(breakSettings)
final breakSettingsProvider = AutoDisposeProvider<BreakSettings>.internal(
  breakSettings,
  name: r'breakSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$breakSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BreakSettingsRef = AutoDisposeProviderRef<BreakSettings>;
String _$settingsHash() => r'1f0b6eac388d8d2d9afd83defa5ae49749f9b1a3';

/// Provider for app settings with persistence
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
