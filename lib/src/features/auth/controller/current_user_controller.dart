import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tdd/src/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_controller.g.dart';

@riverpod
class CurrentUserController extends _$CurrentUserController {
  @override
  User? build() {
    return ref.watch(authRepositoryProvider);
  }
}
