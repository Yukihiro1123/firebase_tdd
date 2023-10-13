import 'package:firebase_tdd/src/features/todo/controller/todo_controller.dart';
import 'package:firebase_tdd/src/routing/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTodoPage extends HookConsumerWidget {
  const AddTodoPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('タスクの追加')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
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
                key: const Key("addTodoButton"),
                onPressed: () {
                  addTodo(
                    context,
                    ref,
                    formKey,
                    titleController.text,
                  );
                },
                child: const Text('Add Todo'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addTodo(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String title,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    await ref.read(todoControllerProvider.notifier).addTodo(title);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("タスクを追加しました"),
      ));
      context.goNamed(AppRoute.todo.name);
    }
  }
}
