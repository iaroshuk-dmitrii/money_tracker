import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/models/costs_data.dart';
import 'package:money_tracker/models/costs_group.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/firestore_repository.dart';

class FirestoreBloc extends Bloc<FirestoreDataEvent, FirestoreState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<CostsGroup> costsGroups = [];
  List<CostData> costsData = [];
  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<QuerySnapshot?>? _costGroupSubscription;
  StreamSubscription<QuerySnapshot?>? _costDataSubscription;
  User? user;

  FirestoreBloc({
    required FirestoreRepository firestoreRepository,
    required AuthRepository authRepository,
  })  : _firestoreRepository = firestoreRepository,
        _authRepository = authRepository,
        super(FirestoreState(costsGroups: [], month: DateTime.now())) {
    on<UserChangedEvent>((event, emit) async {
      log('FirestoreBloc: DataChangedEvent');
      _costGroupSubscription?.cancel();
      _costDataSubscription?.cancel();
      user = event.user;
      final currentUser = user;
      if (currentUser != null) {
        _costGroupSubscription = _firestoreRepository.groupSnapshot(userId: currentUser.uid).listen((snapshot) {
          add(CostGroupChangedEvent(snapshot));
        });
        _costDataSubscription = _firestoreRepository
            .costsForPeriodSnapshot(
                userId: currentUser.uid,
                startDateTime: selectedMonth,
                finalDateTime: DateTime(selectedMonth.year, selectedMonth.month + 1))
            .listen((snapshot) {
          add(CostDataChangedEvent(snapshot));
        });
      }
    });

    on<CostGroupChangedEvent>((event, emit) async {
      log('FirestoreBloc: CostGroupChangedEvent');
      costsGroups.clear();
      List<QueryDocumentSnapshot<Object?>> snapshots = event.snapshot?.docs ?? [];
      for (QueryDocumentSnapshot<Object?> snapshot in snapshots) {
        CostsGroup group = CostsGroup.fromQueryDocumentSnapshot(snapshot);
        costsGroups.add(group);
      }
      _sortDataIntoGroups();
      emit(FirestoreState(costsGroups: costsGroups, month: selectedMonth));
    });

    on<MonthChangedEvent>((event, emit) async {
      log('FirestoreBloc: MonthChangedEvent');
      selectedMonth = event.dateTime;
      log(selectedMonth.toString());
      _costDataSubscription?.cancel();
      final currentUser = user;
      if (currentUser != null) {
        _costDataSubscription = _firestoreRepository
            .costsForPeriodSnapshot(
                userId: currentUser.uid,
                startDateTime: selectedMonth,
                finalDateTime: DateTime(selectedMonth.year, selectedMonth.month + 1))
            .listen((snapshot) {
          add(CostDataChangedEvent(snapshot));
        });
      }
    });

    on<CostDataChangedEvent>((event, emit) async {
      log('FirestoreBloc: CostDataChangedEvent, ${event.snapshot?.docs ?? []} ');
      costsData.clear();
      List<QueryDocumentSnapshot<Object?>> snapshots = event.snapshot?.docs ?? [];
      for (QueryDocumentSnapshot<Object?> snapshot in snapshots) {
        CostData data = CostData.fromQueryDocumentSnapshot(snapshot);
        costsData.add(data);
      }
      log('${costsData.length}');
      _sortDataIntoGroups();
      emit(FirestoreState(costsGroups: costsGroups, month: selectedMonth));
    });

    _userSubscription = _authRepository.user.listen((user) {
      add(UserChangedEvent(user));
    });
  }

  void _sortDataIntoGroups() {
    for (CostsGroup group in costsGroups) {
      group.costs.clear();
      for (CostData data in costsData) {
        if (group.id == data.groupId) {
          group.costs.add(data);
        }
      }
      group.totalCosts = CostsGroup.getTotalCosts(group.costs);
    }
  }

  @override
  Future<void> close() {
    _costGroupSubscription?.cancel();
    _costDataSubscription?.cancel();
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
