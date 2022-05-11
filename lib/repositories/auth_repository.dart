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
      if (e.code == 'weak-password') {
        throw AuthException('Пароль не надежный.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Email уже используется.');
      }
    } catch (e) {
      throw AuthException('Ошибка, повторите позже.');
      // throw Exception(e.toString());
    }
    return null;
  }

  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Пользователь не найден');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Неверный пароль.');
      }
    } catch (e) {
      throw AuthException('Ошибка, повторите позже.');
      // throw Exception(e.toString());
    }
    return null;
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
