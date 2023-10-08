import 'package:firebase_tdd/src/features/auth/view/login_view.dart';
import 'package:firebase_tdd/src/features/auth/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.android), text: "Sign In"),
                Tab(icon: Icon(Icons.phone_iphone), text: "Sign Up"),
              ],
            ),
            title: const Text('Welcome')),
        body: const TabBarView(
          children: [
            LoginView(),
            RegisterView(),
          ],
        ),
      ),
    );
  }
}
