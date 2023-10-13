// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchTodoControllerHash() =>
    r'46aaf80ead1c955c37f5f9b519aa001b494d4653';

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

/// See also [watchTodoController].
@ProviderFor(watchTodoController)
const watchTodoControllerProvider = WatchTodoControllerFamily();

/// See also [watchTodoController].
class WatchTodoControllerFamily extends Family<AsyncValue<Todo>> {
  /// See also [watchTodoController].
  const WatchTodoControllerFamily();

  /// See also [watchTodoController].
  WatchTodoControllerProvider call(
    String id,
  ) {
    return WatchTodoControllerProvider(
      id,
    );
  }

  @override
  WatchTodoControllerProvider getProviderOverride(
    covariant WatchTodoControllerProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchTodoControllerProvider';
}

/// See also [watchTodoController].
class WatchTodoControllerProvider extends AutoDisposeFutureProvider<Todo> {
  /// See also [watchTodoController].
  WatchTodoControllerProvider(
    String id,
  ) : this._internal(
          (ref) => watchTodoController(
            ref as WatchTodoControllerRef,
            id,
          ),
          from: watchTodoControllerProvider,
          name: r'watchTodoControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchTodoControllerHash,
          dependencies: WatchTodoControllerFamily._dependencies,
          allTransitiveDependencies:
              WatchTodoControllerFamily._allTransitiveDependencies,
          id: id,
        );

  WatchTodoControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Todo> Function(WatchTodoControllerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchTodoControllerProvider._internal(
        (ref) => create(ref as WatchTodoControllerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Todo> createElement() {
    return _WatchTodoControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchTodoControllerProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchTodoControllerRef on AutoDisposeFutureProviderRef<Todo> {
  /// The parameter `id` of this provider.
  String get id;
}

class _WatchTodoControllerProviderElement
    extends AutoDisposeFutureProviderElement<Todo> with WatchTodoControllerRef {
  _WatchTodoControllerProviderElement(super.provider);

  @override
  String get id => (origin as WatchTodoControllerProvider).id;
}

String _$watchTodoListControllerHash() =>
    r'16a81a1c76c7392a077397892a18c9bd6de5961d';

/// See also [watchTodoListController].
@ProviderFor(watchTodoListController)
final watchTodoListControllerProvider =
    AutoDisposeStreamProvider<List<Todo>>.internal(
  watchTodoListController,
  name: r'watchTodoListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchTodoListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchTodoListControllerRef = AutoDisposeStreamProviderRef<List<Todo>>;
String _$todoControllerHash() => r'3ff3b7be25b631287e6112888c71893bc5357285';

/// See also [TodoController].
@ProviderFor(TodoController)
final todoControllerProvider =
    AutoDisposeNotifierProvider<TodoController, AsyncValue<dynamic>>.internal(
  TodoController.new,
  name: r'todoControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoController = AutoDisposeNotifier<AsyncValue<dynamic>>;
String _$todoListLimitControllerHash() =>
    r'ffa242e63a7744854ac01849bf42329a6c8988c8';

/// See also [TodoListLimitController].
@ProviderFor(TodoListLimitController)
final todoListLimitControllerProvider =
    AutoDisposeNotifierProvider<TodoListLimitController, int>.internal(
  TodoListLimitController.new,
  name: r'todoListLimitControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoListLimitControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoListLimitController = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
