import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/models/costs_group.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/firestore_repository.dart';

class GroupCubit extends Cubit<GroupState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;

  GroupCubit({
    required FirestoreRepository firestoreRepository,
    required AuthRepository authRepository,
  })  : _firestoreRepository = firestoreRepository,
        _authRepository = authRepository,
        super(const GroupState(
          name: '',
          intColor: '',
          status: GroupStatus.initial,
          error: '',
        ));

  void nameChanged(String value) {
    print('nameChanged $value');
    emit(state.copyWith(name: value, status: GroupStatus.initial));
  }

  void colorChanged(String value) {
    print('colorChanged $value');
    emit(state.copyWith(intColor: value, status: GroupStatus.initial));
  }

  void resetState() {
    print('resetState');
    emit(state.copyWith(name: '', intColor: '', status: GroupStatus.initial, error: ''));
  }

  Future<void> createGroup() async {
    print('createGroup');
    emit(state.copyWith(status: GroupStatus.inProgress));
    try {
      User? user = await _authRepository.getCurrentUser();
      if (user != null) {
        CostsGroup group = CostsGroup(
          name: state.name,
          color: int.parse(state.intColor, radix: 16),
          costs: [],
        );
        await _firestoreRepository.addGroup(userId: user.uid, group: group);
        emit(state.copyWith(status: GroupStatus.success, group: group));
      }
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: GroupStatus.error, error: e.toString()));
    }
  }

  Future<void> deleteGroup(CostsGroup group) async {
    print('deleteGroup');
    emit(state.copyWith(status: GroupStatus.inProgress));
    try {
      User? user = await _authRepository.getCurrentUser();
      if (user != null) {
        await _firestoreRepository.deleteGroup(userId: user.uid, group: group);
        //TODO удалить документы пользователей
        emit(state.copyWith(status: GroupStatus.success));
      }
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: GroupStatus.error, error: e.toString()));
    }
  }
}

//------------------------------
enum GroupStatus { initial, inProgress, success, error }

//------------------------------
class GroupState {
  final String name;
  final String intColor;
  final GroupStatus status;
  final String error;
  final CostsGroup? group;

  const GroupState({required this.name, required this.intColor, required this.status, required this.error, this.group});

  GroupState copyWith({
    String? name,
    String? intColor,
    GroupStatus? status,
    String? error,
    CostsGroup? group,
  }) {
    return GroupState(
      name: name ?? this.name,
      intColor: intColor ?? this.intColor,
      status: status ?? this.status,
      error: error ?? this.error,
      group: group ?? this.group,
    );
  }
}
