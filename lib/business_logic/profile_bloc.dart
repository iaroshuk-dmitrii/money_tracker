import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/storage_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  StreamSubscription<User?>? _userSubscription;
  User? _user;

  ProfileBloc({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository,
        super(ProfileInitialState()) {
    on<ProfileChangedEvent>((event, emit) async {
      print('ProfileBloc: ProfileChangedEvent');
      emit(ProfileUpdatedState(event.user));
    });
    on<UpdatePhotoEvent>((event, emit) async {
      print('ProfileBloc: UpdatePhotoEvent');
      if (_user != null) {
        String? photoURL = await _storageRepository.uploadFile(
          user: _user!,
          file: event.file,
          newFileName: 'avatar.jpg',
        );
        if (photoURL != null) {
          await _user?.updatePhotoURL(photoURL);
        }
      }
    });

    _userSubscription = _authRepository.user.listen((user) {
      _user = user;
      if (user != null) {
        add(ProfileChangedEvent(user));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

//------------------------------
abstract class ProfileEvent {}

class ProfileChangedEvent extends ProfileEvent {
  final User user;
  ProfileChangedEvent(this.user);
}

class UpdatePhotoEvent extends ProfileEvent {
  XFile file;
  UpdatePhotoEvent(this.file);
}

//------------------------------
abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileUpdatedState extends ProfileState {
  final User user;
  ProfileUpdatedState(this.user);
}
