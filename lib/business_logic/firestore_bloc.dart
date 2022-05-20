import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/models/costs_group.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/firestore_repository.dart';

class FirestoreBloc extends Bloc<FirestoreDataEvent, FirestoreState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  DateTime month = DateTime.now();
  List<CostsGroup> costsGroups = [];
  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<QuerySnapshot?>? _costGroupSubscription;

  FirestoreBloc({
    required FirestoreRepository firestoreRepository,
    required AuthRepository authRepository,
  })  : _firestoreRepository = firestoreRepository,
        _authRepository = authRepository,
        super(FirestoreState(costsGroups: [], month: DateTime.now())) {
    on<UserChangedEvent>((event, emit) async {
      print('FirestoreBloc: DataChangedEvent');
      month = DateTime.now();
      _costGroupSubscription?.cancel();
      final user = event.user;
      if (user != null) {
        _costGroupSubscription = _firestoreRepository.groupSnapshot(userId: user.uid).listen((snapshot) {
          add(CostGroupChangedEvent(snapshot));
        });
      }
    });
    on<CostGroupChangedEvent>((event, emit) async {
      print('FirestoreBloc: CostGroupChangedEvent');
      costsGroups.clear();
      List<QueryDocumentSnapshot<Object?>> snapshots = event.snapshot?.docs ?? [];
      for (QueryDocumentSnapshot<Object?> snapshot in snapshots) {
        CostsGroup group = CostsGroup.fromQueryDocumentSnapshot(snapshot);
        costsGroups.add(group);
        print('costsGroup = ${group.toString()}');
      }
      emit(FirestoreState(costsGroups: costsGroups, month: month));
    });
    on<CostDataChangedEvent>((event, emit) async {
      print('FirestoreBloc: CostGroupChangedEvent');
    });
    on<MonthChangedEvent>((event, emit) async {
      print('FirestoreBloc: CostGroupChangedEvent');
      month = event.dateTime;
      emit(FirestoreState(costsGroups: costsGroups, month: month)); //TODO
    });

    _userSubscription = _authRepository.user.listen((user) {
      add(UserChangedEvent(user));
    });
  }

  @override
  Future<void> close() {
    _costGroupSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}

//------------------------------
abstract class FirestoreDataEvent {}

class UserChangedEvent extends FirestoreDataEvent {
  final User? user;
  UserChangedEvent(this.user);
}

class CostGroupChangedEvent extends FirestoreDataEvent {
  QuerySnapshot? snapshot;
  CostGroupChangedEvent(this.snapshot);
}

class CostDataChangedEvent extends FirestoreDataEvent {
  QuerySnapshot? snapshot;
  CostDataChangedEvent(this.snapshot);
}

class MonthChangedEvent extends FirestoreDataEvent {
  DateTime dateTime;
  MonthChangedEvent(this.dateTime);
}

//------------------------------
class FirestoreState {
  DateTime month;
  List<CostsGroup> costsGroups;
  FirestoreState({required this.costsGroups, required this.month});
}
