import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tdd/config/firebase/firebase_auth_error_text.dart';
import 'package:firebase_tdd/config/firebase/firebase_instance_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepository extends _$AuthRepository {
  @override
  User? build() {
    return ref.watch(firebaseAuthInstanceProvider).currentUser;
  }

  Future<String> register({
    required String email,
    required String password,
  }) async {
    try {
      await ref
          .read(firebaseAuthInstanceProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
      state = ref.read(firebaseAuthInstanceProvider).currentUser;
      return 'success';
    } on FirebaseAuthException catch (e) {
      return FirebaseAuthErrorExt.fromCode(e.code).message;
    } catch (e) {
      return 'error';
    }
  }
}
