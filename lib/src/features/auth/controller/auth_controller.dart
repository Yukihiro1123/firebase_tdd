import 'package:firebase_tdd/src/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue build() {
    return const AsyncData(null);
  }

  Future<String> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider.notifier)
        .register(email: email, password: password);
    state = const AsyncData(null);
    return result;
  }
}
