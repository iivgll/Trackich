// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timerNotifierHash() => r'fa3575a41c41084509ffdcfd75408154c7d7943b';

/// Current timer state
///
/// Copied from [TimerNotifier].
@ProviderFor(TimerNotifier)
final timerNotifierProvider =
    AutoDisposeNotifierProvider<TimerNotifier, TimerState>.internal(
      TimerNotifier.new,
      name: r'timerNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TimerNotifier = AutoDisposeNotifier<TimerState>;
String _$timeEntriesHash() => r'fb4b156f09967697da5b5b0e1af9b6909bed9d16';

/// Provider for managing time entries
///
/// Copied from [TimeEntries].
@ProviderFor(TimeEntries)
final timeEntriesProvider =
    AutoDisposeNotifierProvider<TimeEntries, List<TimeEntry>>.internal(
      TimeEntries.new,
      name: r'timeEntriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timeEntriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TimeEntries = AutoDisposeNotifier<List<TimeEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
