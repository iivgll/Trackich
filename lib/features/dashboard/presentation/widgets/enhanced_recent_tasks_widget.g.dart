// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_recent_tasks_widget.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredTimeEntriesHash() =>
    r'd05691d5b8db34d998191375be7391245ab83630';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredTimeEntries].
@ProviderFor(filteredTimeEntries)
const filteredTimeEntriesProvider = FilteredTimeEntriesFamily();

/// See also [filteredTimeEntries].
class FilteredTimeEntriesFamily
    extends Family<AsyncValue<Map<String, List<TaskGroupWithProject>>>> {
  /// See also [filteredTimeEntries].
  const FilteredTimeEntriesFamily();

  /// See also [filteredTimeEntries].
  FilteredTimeEntriesProvider call(TaskFilterPeriod period) {
    return FilteredTimeEntriesProvider(period);
  }

  @override
  FilteredTimeEntriesProvider getProviderOverride(
    covariant FilteredTimeEntriesProvider provider,
  ) {
    return call(provider.period);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredTimeEntriesProvider';
}

/// See also [filteredTimeEntries].
class FilteredTimeEntriesProvider
    extends AutoDisposeFutureProvider<Map<String, List<TaskGroupWithProject>>> {
  /// See also [filteredTimeEntries].
  FilteredTimeEntriesProvider(TaskFilterPeriod period)
    : this._internal(
        (ref) => filteredTimeEntries(ref as FilteredTimeEntriesRef, period),
        from: filteredTimeEntriesProvider,
        name: r'filteredTimeEntriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$filteredTimeEntriesHash,
        dependencies: FilteredTimeEntriesFamily._dependencies,
        allTransitiveDependencies:
            FilteredTimeEntriesFamily._allTransitiveDependencies,
        period: period,
      );

  FilteredTimeEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final TaskFilterPeriod period;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<TaskGroupWithProject>>> Function(
      FilteredTimeEntriesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredTimeEntriesProvider._internal(
        (ref) => create(ref as FilteredTimeEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<TaskGroupWithProject>>>
  createElement() {
    return _FilteredTimeEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTimeEntriesProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredTimeEntriesRef
    on AutoDisposeFutureProviderRef<Map<String, List<TaskGroupWithProject>>> {
  /// The parameter `period` of this provider.
  TaskFilterPeriod get period;
}

class _FilteredTimeEntriesProviderElement
    extends
        AutoDisposeFutureProviderElement<
          Map<String, List<TaskGroupWithProject>>
        >
    with FilteredTimeEntriesRef {
  _FilteredTimeEntriesProviderElement(super.provider);

  @override
  TaskFilterPeriod get period => (origin as FilteredTimeEntriesProvider).period;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
