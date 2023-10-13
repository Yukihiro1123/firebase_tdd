import 'package:firebase_tdd/src/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    //
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final String result = await ref
        .read(authRepositoryProvider.notifier)
        .signIn(email: email, password: password);
    state = const AsyncData<void>(null);
    return result;
  }

  Future<String> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider.notifier)
        .register(email: email, password: password);
    state = const AsyncData<void>(null);
    return result;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider.notifier).signOut());
  }
}
