import 'package:firebase_tdd/src/features/auth/view/login_view.dart';
import 'package:firebase_tdd/src/features/auth/view/register_view.dart';
import 'package:firebase_tdd/src/features/todo/view/todo_list_page.dart';
import 'package:firebase_tdd/src/routing/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final loginViewRouter = GoRouter(
  initialLocation: AppRoute.auth.path,
  routes: [
    GoRoute(
      path: AppRoute.auth.path,
      name: AppRoute.auth.name,
      pageBuilder: (context, state) => const MaterialPage(
        child: Material(child: Scaffold(body: LoginView())),
      ),
    ),
    GoRoute(
      path: AppRoute.todo.path,
      name: AppRoute.todo.name,
      pageBuilder: (context, state) => const MaterialPage(
        child: TodoListPage(),
      ),
    ),
  ],
);

final registerViewRouter = GoRouter(
  initialLocation: AppRoute.auth.path,
  routes: [
    GoRoute(
      path: AppRoute.auth.path,
      name: AppRoute.auth.name,
      pageBuilder: (context, state) => const MaterialPage(
        child: RegisterView(),
      ),
    ),
    GoRoute(
      path: AppRoute.todo.path,
      name: AppRoute.todo.name,
      pageBuilder: (context, state) => const MaterialPage(
        child: TodoListPage(),
      ),
    ),
  ],
);
