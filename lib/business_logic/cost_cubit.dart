import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/models/costs_data.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/firestore_repository.dart';

class CostCubit extends Cubit<CostState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;

  CostCubit({
    required FirestoreRepository firestoreRepository,
    required AuthRepository authRepository,
  })  : _firestoreRepository = firestoreRepository,
        _authRepository = authRepository,
        super(CostState(
          id: '',
          cost: 0.0,
          dateTime: DateTime.now(),
          status: CostStatus.initial,
          error: '',
        ));

  void costChanged(String value) {
    log('costChanged $value');
    emit(state.copyWith(cost: double.tryParse(value.replaceAll(',', '.')), status: CostStatus.initial));
  }

  void dateChanged(DateTime value) {
    log('dateChanged $value');
    emit(state.copyWith(dateTime: value, status: CostStatus.initial));
  }

  void resetState() {
    log('resetState');
    emit(CostState(
      id: '',
      cost: 0.0,
      dateTime: DateTime.now(),
      status: CostStatus.initial,
      error: '',
      costData: null,
    ));
  }

  Future<void> createCost({required String groupId}) async {
    log('createCost');
    emit(state.copyWith(status: CostStatus.inProgress));
    try {
      User? user = await _authRepository.getCurrentUser();
      if (user != null) {
        CostData costData = CostData(id: state.id, cost: state.cost, dateTime: state.dateTime, groupId: groupId);
        await _firestoreRepository.addCost(userId: user.uid, costData: costData);
        emit(state.copyWith(status: CostStatus.success, costData: costData));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: CostStatus.error, error: e.toString()));
    }
  }

  Future<void> deleteCost(CostData costData) async {
    log('deleteCost');
    emit(state.copyWith(status: CostStatus.inProgress));
    try {
      User? user = await _authRepository.getCurrentUser();
      if (user != null) {
        await _firestoreRepository.deleteCost(userId: user.uid, costData: costData);
        emit(state.copyWith(status: CostStatus.success));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: CostStatus.error, error: e.toString()));
    }
  }
}

//------------------------------
enum CostStatus { initial, inProgress, success, error }

//------------------------------
class CostState {
  final String id;
  final double cost;
  final DateTime dateTime;
  final CostStatus status;
  final String error;
  final CostData? costData;

  const CostState({
    required this.id,
    required this.cost,
    required this.dateTime,
    required this.status,
    required this.error,
    this.costData,
  });

  CostState copyWith({
    String? id,
    double? cost,
    DateTime? dateTime,
    CostStatus? status,
    String? error,
    CostData? costData,
  }) {
    return CostState(
      id: id ?? this.id,
      cost: cost ?? this.cost,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      error: error ?? this.error,
      costData: costData ?? this.costData,
    );
  }
}
