// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayTimeSummaryHash() => r'0fa01162a445e8f0909c778581feed689ea7bf52';

/// Provider for today's time summary
///
/// Copied from [todayTimeSummary].
@ProviderFor(todayTimeSummary)
final todayTimeSummaryProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      todayTimeSummary,
      name: r'todayTimeSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayTimeSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTimeSummaryRef =
    AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$recentTaskNamesHash() => r'72a59bd6dfc098eb52ab4646f31ced670577c8b1';

/// Provider for recent task names
///
/// Copied from [recentTaskNames].
@ProviderFor(recentTaskNames)
final recentTaskNamesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      recentTaskNames,
      name: r'recentTaskNamesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentTaskNamesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentTaskNamesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$timerHash() => r'0be2404ff81e2f7f9a1ba162bb0108d273e32145';

/// Provider for the current timer
///
/// Copied from [Timer].
@ProviderFor(Timer)
final timerProvider = AutoDisposeNotifierProvider<Timer, CurrentTimer>.internal(
  Timer.new,
  name: r'timerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Timer = AutoDisposeNotifier<CurrentTimer>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
