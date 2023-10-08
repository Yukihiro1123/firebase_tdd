enum AppRoute {
  auth,
  todo,
}

extension AppRouteExtention on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.auth:
        return '/auth';
      case AppRoute.todo:
        return '/todo';
    }
  }
}
