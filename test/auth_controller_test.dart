import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_tdd/config/firebase/firebase_instance_provider.dart';
import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void main() {
  late ProviderContainer container;
  late MockFirebaseAuth mockFirebaseAuth;

  //setup テストの実行前に行う共通の処理を記述
  setUp(() async {
    // authをmock化
    mockFirebaseAuth = MockFirebaseAuth();

    container = ProviderContainer(
      overrides: [
        firebaseAuthInstanceProvider.overrideWithValue(mockFirebaseAuth),
      ],
    );
  });

  //テストの実行後に実行される共通の処理を記述
  tearDown(() {
    //コンテナを破棄する
    container.dispose();
  });

  //group: テストケースをグループごとにまとめる
  group('email-passwordによるログイン処理', () {
    group('正常系', () {
      //test(description, body)
      //descriptionにはテストの名前、bodyにはテストしたい処理を書く
      test('会員登録が済んでいる状態でログインに成功するとcurrentUserにユーザーが設定され、successというメッセージが返る',
          () async {
        await container
            .read(authControllerProvider.notifier)
            .register(email: 'bob@somedomain.com', password: 'bob12345');
        final String response = await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'bob@somedomain.com', password: 'bob12345');
        final currentUser =
            container.read(firebaseAuthInstanceProvider).currentUser;
        expect(currentUser!.email, "bob@somedomain.com");
        expect(response, "success");
      });
    });
    group('異常系', () {
      test('会員登録が済んでいない場合エラーメッセージを返す', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(container.read(firebaseAuthInstanceProvider))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));
        final response = await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'someone@somewhere.com', password: "ccccc");
        expect(response, "指定されたユーザーは登録されていません。");
      });

      test('パスワードが間違っている場合エラーメッセージを返す', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(container.read(firebaseAuthInstanceProvider))
            .thenThrow(FirebaseAuthException(code: 'wrong-password'));
        final response = await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'someone@somewhere.com', password: "ccccc");
        expect(response, "メールアドレス、またはパスワードが間違っています。");
      });

      test('ユーザーが無効化されている場合エラーメッセージを返す', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(container.read(firebaseAuthInstanceProvider))
            .thenThrow(FirebaseAuthException(code: 'user-disabled'));
        final response = await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'someone@somewhere.com', password: "");
        expect(response, "指定されたユーザーは無効化されています。");
      });
    });
  });

  group('email-passwordによる会員登録処理', () {
    group('正常系', () {
      test('会員登録に成功するとcurrentUserにユーザーが設定され、successというメッセージが返る', () async {
        final String response = await container
            .read(authControllerProvider.notifier)
            .register(email: 'bob@somedomain.com', password: 'bob12345');
        final currentUser =
            container.read(firebaseAuthInstanceProvider).currentUser;
        expect(currentUser!.email, "bob@somedomain.com");
        expect(response, "success");
      });
    });
    group('異常系', () {
      test('すでにユーザーが登録されている場合エラーメッセージを返す', () async {
        whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
            .on(container.read(firebaseAuthInstanceProvider))
            .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
        final response = await container
            .read(authControllerProvider.notifier)
            .register(email: 'someone@somewhere.com', password: "");
        expect(response, "既に利用されているメールアドレスです。");
      });
      test('ユーザーが無効化されている場合エラーメッセージを返す', () async {
        whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
            .on(container.read(firebaseAuthInstanceProvider))
            .thenThrow(FirebaseAuthException(code: 'user-disabled'));
        final response = await container
            .read(authControllerProvider.notifier)
            .register(email: 'someone@somewhere.com', password: "");
        expect(response, "指定されたユーザーは無効化されています。");
      });
    });
  });

  group('ログアウト処理', () {
    test('ログアウトに成功するとcurrentUserがnullになること', () async {
      await container.read(authControllerProvider.notifier).signOut();
      final currentUser =
          container.read(firebaseAuthInstanceProvider).currentUser;
      expect(currentUser?.email, null);
    });
  });
}
