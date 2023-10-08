import 'package:firebase_tdd/src/features/auth/view/auth_page.dart';
import 'package:firebase_tdd/src/features/todo/view/todo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'router_utils.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoute.auth.path,
    redirect: (context, state) {
      if (ref.read(currentUserControllerProvider) == null) {
        return AppRoute.auth.path;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const AuthPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.todo.path,
        name: AppRoute.todo.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const TodoListPage(),
          );
        },
      ),
    ],
  );
}
