import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_tdd/src/features/todo/controller/todo_controller.dart';
import 'package:firebase_tdd/src/features/todo/data_model/todo.dart';
import 'package:firebase_tdd/src/routing/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditTodoPage extends HookConsumerWidget {
  final String id;
  const EditTodoPage({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('タスクの編集')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: ref.watch(watchTodoControllerProvider(id)).when(
            data: (Todo data) {
              titleController.text = data.title;
              return Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    key: const Key("titleForm"),
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "必須";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    key: const Key("editTodoButton"),
                    onPressed: () {
                      editTodo(
                        context: context,
                        ref: ref,
                        formKey: formKey,
                        title: titleController.text,
                        todo: data,
                      );
                    },
                    child: const Text('タスクの更新'),
                  )
                ],
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (error, stackTrace) {
              return const Center(child: Text('todo取得時にエラーが発生しました'));
            },
          ),
        ),
      ),
    );
  }

  void editTodo({
    required BuildContext context,
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required Todo todo,
    required String title,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final result = await showOkCancelAlertDialog(
      context: context,
      okLabel: 'はい',
      cancelLabel: 'いいえ',
      title: 'タスクを更新しても良いですか？',
    );
    if (result == OkCancelResult.ok) {
      await ref.read(todoControllerProvider.notifier).updateTodo(todo, title);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("タスクを更新しました"),
        ));
        context.goNamed(AppRoute.todo.name);
      }
    }
  }
}
