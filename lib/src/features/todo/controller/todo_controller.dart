import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tdd/src/features/todo/data_model/todo.dart';
import 'package:firebase_tdd/src/features/todo/repository/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:uuid/uuid.dart';

part 'todo_controller.g.dart';

@riverpod
class TodoController extends _$TodoController {
  @override
  AsyncValue build() {
    return const AsyncData(null);
  }

  Future<void> addTodo(String title) async {
    state = const AsyncLoading();
    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title,
      createdAt: Timestamp.now(),
    );
    await ref.read(todoRepositoryProvider.notifier).addTodo(newTodo);
    state = const AsyncData(null);
  }

  Future<void> updateTodo(Todo todo, String title) async {
    state = const AsyncLoading();
    final Todo editTodoData = todo.copyWith(
      title: title,
    );
    await ref.read(todoRepositoryProvider.notifier).updateTodo(editTodoData);
    state = const AsyncData(null);
  }

  Future<void> deleteTodo(String id) async {
    state = const AsyncLoading();
    await ref.read(todoRepositoryProvider.notifier).deleteTodo(id);
    state = const AsyncData(null);
  }
}

@riverpod
Stream<List<Todo>> watchTodoListController(WatchTodoListControllerRef ref) {
  final int todoListLimit = ref.watch(todoListLimitControllerProvider);
  return ref.read(todoRepositoryProvider.notifier).watchTodos(todoListLimit);
}

@riverpod
class TodoListLimitController extends _$TodoListLimitController {
  @override
  int build() {
    return 20;
  }

  //limitを+20する
  void increment() {
    state = state + 20;
  }
}
