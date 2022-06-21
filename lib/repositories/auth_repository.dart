import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  AuthRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw AuthException('Пароль не надежный.');
        case 'email-already-in-use':
          throw AuthException('Email уже используется.');
        case 'invalid-email':
          throw AuthException('Неверный Email');
        default:
          throw AuthException('Что-то пошло не так, повторите позже.');
      }
    } catch (e) {
      throw AuthException('Ошибка, повторите позже.');
      // throw Exception(e.toString());
    }
  }

  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthException('Пользователь не найден');
        case 'wrong-password':
          throw AuthException('Неверный пароль.');
        case 'invalid-email':
          throw AuthException('Неверный Email');
        default:
          throw AuthException('Что-то пошло не так, повторите позже.');
      }
    } catch (e) {
      throw AuthException('Ошибка, повторите позже.');
    }
  }

  Future<User?> getCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<User?> get user {
    return _firebaseAuth.userChanges();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
