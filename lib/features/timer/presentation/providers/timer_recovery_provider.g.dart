// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_recovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timerRecoveryHash() => r'12b6ff3716da4b980f2cd2f81210f6ba34a6692e';

/// Provider to check for recovery data on app startup
///
/// Copied from [timerRecovery].
@ProviderFor(timerRecovery)
final timerRecoveryProvider =
    AutoDisposeFutureProvider<TimerRecoveryData?>.internal(
      timerRecovery,
      name: r'timerRecoveryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timerRecoveryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimerRecoveryRef = AutoDisposeFutureProviderRef<TimerRecoveryData?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
