// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeProjectsHash() => r'00e0d1eadd66f5dc2dd122a5ce370aaebecfcf9f';

/// Provider for active projects only
///
/// Copied from [activeProjects].
@ProviderFor(activeProjects)
final activeProjectsProvider =
    AutoDisposeFutureProvider<List<Project>>.internal(
      activeProjects,
      name: r'activeProjectsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeProjectsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveProjectsRef = AutoDisposeFutureProviderRef<List<Project>>;
String _$archivedProjectsHash() => r'a2d18927b19a90bee5c5087ddf5a15bdc8947328';

/// Provider for archived projects only
///
/// Copied from [archivedProjects].
@ProviderFor(archivedProjects)
final archivedProjectsProvider =
    AutoDisposeFutureProvider<List<Project>>.internal(
      archivedProjects,
      name: r'archivedProjectsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$archivedProjectsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArchivedProjectsRef = AutoDisposeFutureProviderRef<List<Project>>;
String _$recentProjectIdsHash() => r'6351833670e317f52caf381991c4e8a7618e9af4';

/// Provider for recent project IDs
///
/// Copied from [recentProjectIds].
@ProviderFor(recentProjectIds)
final recentProjectIdsProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      recentProjectIds,
      name: r'recentProjectIdsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentProjectIdsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentProjectIdsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$favoriteProjectIdsHash() =>
    r'e6dec1bcb51e02d15fc2d16f47ce5bc28fd237eb';

/// Provider for favorite project IDs
///
/// Copied from [favoriteProjectIds].
@ProviderFor(favoriteProjectIds)
final favoriteProjectIdsProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      favoriteProjectIds,
      name: r'favoriteProjectIdsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteProjectIdsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteProjectIdsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$recentProjectsHash() => r'5dc79c259eba30f38531759aec733fcbe1315456';

/// Provider for recent projects
///
/// Copied from [recentProjects].
@ProviderFor(recentProjects)
final recentProjectsProvider =
    AutoDisposeFutureProvider<List<Project>>.internal(
      recentProjects,
      name: r'recentProjectsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentProjectsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentProjectsRef = AutoDisposeFutureProviderRef<List<Project>>;
String _$projectsByUsageHash() => r'7f7b99cbeee587e1979939339e61afea584c1a31';

/// Provider for projects sorted by most used
///
/// Copied from [projectsByUsage].
@ProviderFor(projectsByUsage)
final projectsByUsageProvider =
    AutoDisposeFutureProvider<List<Project>>.internal(
      projectsByUsage,
      name: r'projectsByUsageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectsByUsageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectsByUsageRef = AutoDisposeFutureProviderRef<List<Project>>;
String _$projectHash() => r'7bae8a8dcabda381368eeaa59fd7f092c586ac25';

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

/// Provider for a specific project by ID
///
/// Copied from [project].
@ProviderFor(project)
const projectProvider = ProjectFamily();

/// Provider for a specific project by ID
///
/// Copied from [project].
class ProjectFamily extends Family<AsyncValue<Project?>> {
  /// Provider for a specific project by ID
  ///
  /// Copied from [project].
  const ProjectFamily();

  /// Provider for a specific project by ID
  ///
  /// Copied from [project].
  ProjectProvider call(String projectId) {
    return ProjectProvider(projectId);
  }

  @override
  ProjectProvider getProviderOverride(covariant ProjectProvider provider) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectProvider';
}

/// Provider for a specific project by ID
///
/// Copied from [project].
class ProjectProvider extends AutoDisposeFutureProvider<Project?> {
  /// Provider for a specific project by ID
  ///
  /// Copied from [project].
  ProjectProvider(String projectId)
    : this._internal(
        (ref) => project(ref as ProjectRef, projectId),
        from: projectProvider,
        name: r'projectProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectHash,
        dependencies: ProjectFamily._dependencies,
        allTransitiveDependencies: ProjectFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    FutureOr<Project?> Function(ProjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectProvider._internal(
        (ref) => create(ref as ProjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Project?> createElement() {
    return _ProjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectRef on AutoDisposeFutureProviderRef<Project?> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectProviderElement extends AutoDisposeFutureProviderElement<Project?>
    with ProjectRef {
  _ProjectProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectProvider).projectId;
}

String _$searchProjectsHash() => r'907fd8a741db0aa2cf8b91e54a03f0fe0f933251';

/// Provider for searching projects
///
/// Copied from [searchProjects].
@ProviderFor(searchProjects)
const searchProjectsProvider = SearchProjectsFamily();

/// Provider for searching projects
///
/// Copied from [searchProjects].
class SearchProjectsFamily extends Family<AsyncValue<List<Project>>> {
  /// Provider for searching projects
  ///
  /// Copied from [searchProjects].
  const SearchProjectsFamily();

  /// Provider for searching projects
  ///
  /// Copied from [searchProjects].
  SearchProjectsProvider call(String query) {
    return SearchProjectsProvider(query);
  }

  @override
  SearchProjectsProvider getProviderOverride(
    covariant SearchProjectsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchProjectsProvider';
}

/// Provider for searching projects
///
/// Copied from [searchProjects].
class SearchProjectsProvider extends AutoDisposeFutureProvider<List<Project>> {
  /// Provider for searching projects
  ///
  /// Copied from [searchProjects].
  SearchProjectsProvider(String query)
    : this._internal(
        (ref) => searchProjects(ref as SearchProjectsRef, query),
        from: searchProjectsProvider,
        name: r'searchProjectsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchProjectsHash,
        dependencies: SearchProjectsFamily._dependencies,
        allTransitiveDependencies:
            SearchProjectsFamily._allTransitiveDependencies,
        query: query,
      );

  SearchProjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Project>> Function(SearchProjectsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchProjectsProvider._internal(
        (ref) => create(ref as SearchProjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Project>> createElement() {
    return _SearchProjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProjectsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchProjectsRef on AutoDisposeFutureProviderRef<List<Project>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchProjectsProviderElement
    extends AutoDisposeFutureProviderElement<List<Project>>
    with SearchProjectsRef {
  _SearchProjectsProviderElement(super.provider);

  @override
  String get query => (origin as SearchProjectsProvider).query;
}

String _$projectsHash() => r'45271734f40d9d6b17475569d41bbd8dc6f9e04a';

/// Provider for managing projects
///
/// Copied from [Projects].
@ProviderFor(Projects)
final projectsProvider =
    AutoDisposeAsyncNotifierProvider<Projects, List<Project>>.internal(
      Projects.new,
      name: r'projectsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Projects = AutoDisposeAsyncNotifier<List<Project>>;
String _$projectStatsHash() => r'07327508d09f607557f3d36c416f5843ee51fb88';

abstract class _$ProjectStats
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String projectId;

  FutureOr<Map<String, dynamic>> build(String projectId);
}

/// Provider for project statistics
///
/// Copied from [ProjectStats].
@ProviderFor(ProjectStats)
const projectStatsProvider = ProjectStatsFamily();

/// Provider for project statistics
///
/// Copied from [ProjectStats].
class ProjectStatsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Provider for project statistics
  ///
  /// Copied from [ProjectStats].
  const ProjectStatsFamily();

  /// Provider for project statistics
  ///
  /// Copied from [ProjectStats].
  ProjectStatsProvider call(String projectId) {
    return ProjectStatsProvider(projectId);
  }

  @override
  ProjectStatsProvider getProviderOverride(
    covariant ProjectStatsProvider provider,
  ) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectStatsProvider';
}

/// Provider for project statistics
///
/// Copied from [ProjectStats].
class ProjectStatsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProjectStats,
          Map<String, dynamic>
        > {
  /// Provider for project statistics
  ///
  /// Copied from [ProjectStats].
  ProjectStatsProvider(String projectId)
    : this._internal(
        () => ProjectStats()..projectId = projectId,
        from: projectStatsProvider,
        name: r'projectStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectStatsHash,
        dependencies: ProjectStatsFamily._dependencies,
        allTransitiveDependencies:
            ProjectStatsFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant ProjectStats notifier,
  ) {
    return notifier.build(projectId);
  }

  @override
  Override overrideWith(ProjectStats Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProjectStatsProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProjectStats, Map<String, dynamic>>
  createElement() {
    return _ProjectStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectStatsProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectStatsRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectStatsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProjectStats,
          Map<String, dynamic>
        >
    with ProjectStatsRef {
  _ProjectStatsProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectStatsProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
