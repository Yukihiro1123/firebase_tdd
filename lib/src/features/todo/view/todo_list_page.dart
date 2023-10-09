import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoListPage extends HookConsumerWidget {
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
      body: const Text('Hi'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
        await ref.read(authControllerProvider.notifier).signOut();
      }
    }
  }
}
