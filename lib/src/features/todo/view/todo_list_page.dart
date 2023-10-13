import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:firebase_tdd/src/features/todo/controller/todo_controller.dart';
import 'package:firebase_tdd/src/features/todo/data_model/todo.dart';
import 'package:firebase_tdd/src/routing/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            key: const Key('logoutButton'),
            tooltip: 'Logout',
            onPressed: () => signOut(context, ref),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: ref.watch(watchTodoListControllerProvider).when(
        data: (List<Todo> todoList) {
          return todoList.isEmpty
              ? const Center(child: Text('データが存在しません'))
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final Todo todo = todoList[index];
                    return InkWell(
                      onTap: () {
                        goToEditTodoPage(context, todo.id);
                      },
                      child: ListTile(
                        title: Text(todo.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTodo(context, ref, todo.id);
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0.5),
                  itemCount: todoList.length,
                );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return const Center(child: Text('todoリスト取得時にエラーが発生しました'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToAddTodoPage(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @visibleForTesting
  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    if (context.mounted) {
      final result = await showOkCancelAlertDialog(
        context: context,
        okLabel: 'はい',
        cancelLabel: 'いいえ',
        title: 'ログアウトしますか？',
      );
      if (result == OkCancelResult.ok) {
        // final sub =
        //     ref.listenManual(authControllerProvider.notifier, (_, __) {});
        // await sub.read().signOut();
        // sub.close();
        await ref.read(authControllerProvider.notifier).signOut();
      }
    }
  }

  void goToEditTodoPage(BuildContext context, String id) {
    if (context.mounted) {
      context.goNamed(AppRoute.editTodo.name, pathParameters: {"id": id});
    }
  }

  void goToAddTodoPage(BuildContext context) {
    if (context.mounted) {
      context.goNamed(AppRoute.addTodo.name);
    }
  }

  Future<void> deleteTodo(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    if (context.mounted) {
      final result = await showOkCancelAlertDialog(
        context: context,
        okLabel: 'はい',
        cancelLabel: 'いいえ',
        title: 'タスクを削除しますか？',
      );
      if (result == OkCancelResult.ok) {
        await ref.read(todoControllerProvider.notifier).deleteTodo(id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("タスクを更新しました"),
          ));
        }
      }
    }
  }
}
