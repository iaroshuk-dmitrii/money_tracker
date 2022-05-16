import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/repositories/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState(
          email: '',
          password: '',
          status: LoginStatus.initial,
          loginType: LoginType.login,
          user: null,
          error: '',
        ));

  void emailChanged(String value) {
    print('emailChanged $value');
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    print('passwordChanged $value');
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  Future<void> signUp() async {
    print('signUp');
    if (state.status == LoginStatus.inProgress) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      var user = await _authRepository.signUp(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(status: LoginStatus.error, error: e.message));
    }
  }

  Future<void> login() async {
    print('login');
    if (state.status == LoginStatus.inProgress) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      var user = await _authRepository.signIn(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(status: LoginStatus.error, error: e.message));
    }
  }

  Future<void> signOut() async {
    print('SignOut');
    await _authRepository.signOut();
    emit(state.copyWith(email: '', password: '', status: LoginStatus.initial));
  }

  void switchToSignUp() {
    print('switchToSignUp');
    if (state.loginType == LoginType.signUp) return;
    emit(state.copyWith(loginType: LoginType.signUp, status: LoginStatus.initial));
  }

  void switchToLogin() {
    print('switchToLogin');
    if (state.loginType == LoginType.login) return;
    emit(state.copyWith(loginType: LoginType.login, status: LoginStatus.initial));
  }
}

//------------------------------
enum LoginStatus { initial, inProgress, success, error }

enum LoginType { login, signUp }

//------------------------------
class LoginState {
  final String email;
  final String password;
  final LoginStatus status;
  final LoginType loginType;
  final User? user;
  final String error;

  const LoginState(
      {required this.email,
      required this.password,
      required this.status,
      required this.loginType,
      this.user,
      required this.error});

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    LoginType? loginType,
    User? user,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      loginType: loginType ?? this.loginType,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
