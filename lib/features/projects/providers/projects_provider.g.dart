// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeProjectsHash() => r'687afe5c16311abe19fba26e8b18b0d610b89c88';

/// Provider that filters active projects
///
/// Copied from [activeProjects].
@ProviderFor(activeProjects)
final activeProjectsProvider = AutoDisposeProvider<List<Project>>.internal(
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
typedef ActiveProjectsRef = AutoDisposeProviderRef<List<Project>>;
String _$archivedProjectsHash() => r'6791fd2a945ec71cd5db607afe5c0d6646874d50';

/// Provider that filters archived projects
///
/// Copied from [archivedProjects].
@ProviderFor(archivedProjects)
final archivedProjectsProvider = AutoDisposeProvider<List<Project>>.internal(
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
typedef ArchivedProjectsRef = AutoDisposeProviderRef<List<Project>>;
String _$projectByIdHash() => r'9db365b9ea0e50f93fd9508da6eda2ce5303c717';

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

/// Provider for getting a specific project by ID
///
/// Copied from [projectById].
@ProviderFor(projectById)
const projectByIdProvider = ProjectByIdFamily();

/// Provider for getting a specific project by ID
///
/// Copied from [projectById].
class ProjectByIdFamily extends Family<Project?> {
  /// Provider for getting a specific project by ID
  ///
  /// Copied from [projectById].
  const ProjectByIdFamily();

  /// Provider for getting a specific project by ID
  ///
  /// Copied from [projectById].
  ProjectByIdProvider call(String projectId) {
    return ProjectByIdProvider(projectId);
  }

  @override
  ProjectByIdProvider getProviderOverride(
    covariant ProjectByIdProvider provider,
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
  String? get name => r'projectByIdProvider';
}

/// Provider for getting a specific project by ID
///
/// Copied from [projectById].
class ProjectByIdProvider extends AutoDisposeProvider<Project?> {
  /// Provider for getting a specific project by ID
  ///
  /// Copied from [projectById].
  ProjectByIdProvider(String projectId)
    : this._internal(
        (ref) => projectById(ref as ProjectByIdRef, projectId),
        from: projectByIdProvider,
        name: r'projectByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectByIdHash,
        dependencies: ProjectByIdFamily._dependencies,
        allTransitiveDependencies: ProjectByIdFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectByIdProvider._internal(
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
  Override overrideWith(Project? Function(ProjectByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: ProjectByIdProvider._internal(
        (ref) => create(ref as ProjectByIdRef),
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
  AutoDisposeProviderElement<Project?> createElement() {
    return _ProjectByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectByIdProvider && other.projectId == projectId;
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
mixin ProjectByIdRef on AutoDisposeProviderRef<Project?> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectByIdProviderElement extends AutoDisposeProviderElement<Project?>
    with ProjectByIdRef {
  _ProjectByIdProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectByIdProvider).projectId;
}

String _$projectStatisticsHash() => r'90bcaa3b50446da74ca48270622d2d5dbdc11441';

/// Provider for project statistics
///
/// Copied from [projectStatistics].
@ProviderFor(projectStatistics)
const projectStatisticsProvider = ProjectStatisticsFamily();

/// Provider for project statistics
///
/// Copied from [projectStatistics].
class ProjectStatisticsFamily extends Family<ProjectStatistics> {
  /// Provider for project statistics
  ///
  /// Copied from [projectStatistics].
  const ProjectStatisticsFamily();

  /// Provider for project statistics
  ///
  /// Copied from [projectStatistics].
  ProjectStatisticsProvider call(String projectId) {
    return ProjectStatisticsProvider(projectId);
  }

  @override
  ProjectStatisticsProvider getProviderOverride(
    covariant ProjectStatisticsProvider provider,
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
  String? get name => r'projectStatisticsProvider';
}

/// Provider for project statistics
///
/// Copied from [projectStatistics].
class ProjectStatisticsProvider extends AutoDisposeProvider<ProjectStatistics> {
  /// Provider for project statistics
  ///
  /// Copied from [projectStatistics].
  ProjectStatisticsProvider(String projectId)
    : this._internal(
        (ref) => projectStatistics(ref as ProjectStatisticsRef, projectId),
        from: projectStatisticsProvider,
        name: r'projectStatisticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectStatisticsHash,
        dependencies: ProjectStatisticsFamily._dependencies,
        allTransitiveDependencies:
            ProjectStatisticsFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectStatisticsProvider._internal(
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
    ProjectStatistics Function(ProjectStatisticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectStatisticsProvider._internal(
        (ref) => create(ref as ProjectStatisticsRef),
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
  AutoDisposeProviderElement<ProjectStatistics> createElement() {
    return _ProjectStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectStatisticsProvider && other.projectId == projectId;
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
mixin ProjectStatisticsRef on AutoDisposeProviderRef<ProjectStatistics> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectStatisticsProviderElement
    extends AutoDisposeProviderElement<ProjectStatistics>
    with ProjectStatisticsRef {
  _ProjectStatisticsProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectStatisticsProvider).projectId;
}

String _$projectsHash() => r'b823a979b08ed0e8dbb09924e704f6d51e6d550a';

/// Provider for managing projects
///
/// Copied from [Projects].
@ProviderFor(Projects)
final projectsProvider =
    AutoDisposeNotifierProvider<Projects, List<Project>>.internal(
      Projects.new,
      name: r'projectsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Projects = AutoDisposeNotifier<List<Project>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
