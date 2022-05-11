import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthUnknownState()) {
    on<UserChangedEvent>((event, emit) async {
      print('AuthBloc: UserChangedEvent');
      if (event.user == null) {
        emit(AuthUnauthenticatedState());
      } else {
        emit(AuthAuthenticatedState(event.user));
      }
    });

    _userSubscription = _authRepository.user.listen((user) {
      add(UserChangedEvent(user));
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

//------------------------------
abstract class AuthEvent {}

class UserChangedEvent extends AuthEvent {
  final User? user;
  UserChangedEvent(this.user);
}

//------------------------------
abstract class AuthState {}

class AuthUnknownState extends AuthState {}

class AuthUnauthenticatedState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final User? user;
  AuthAuthenticatedState(this.user);
}
