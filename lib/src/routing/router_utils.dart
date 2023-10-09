enum AppRoute {
  auth,
  todo,
  addTodo,
}

extension AppRouteExtention on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.auth:
        return '/auth';
      case AppRoute.todo:
        return '/todo';
      case AppRoute.addTodo:
        return 'new';
    }
  }
}
