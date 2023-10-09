// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$todoControllerHash() => r'13fa869ea8e73d18970dee444690bc58ae632639';

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
